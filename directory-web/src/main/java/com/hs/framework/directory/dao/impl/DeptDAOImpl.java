package com.hs.framework.directory.dao.impl;

import com.hs.framework.directory.context.OrgConstant;
import com.hs.framework.directory.dao.AbstractDAO;
import com.hs.framework.directory.dao.DeptDAO;
import com.hs.framework.directory.info.Dept;
import com.hs.framework.directory.info.impl.DeptImpl;
import com.hs.framework.directory.model.IDandCount;
import com.hs.framework.directory.search.DeptMngAuthKey;
import com.hs.framework.directory.search.DeptOrderByKey;
import com.hs.framework.directory.search.DeptOrderKey;
import com.hs.framework.directory.search.MultiSearchKey;
import com.hs.framework.directory.search.SearchKey;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.RowMapper;

public class DeptDAOImpl extends AbstractDAO implements DeptDAO, OrgConstant {
  private static String COLUMNS_DEPT_DEPTID = "d.dept_id";
  
  private static String COLUMNS_DEPT_ALL = "d.dept_id, d.dept_name, d.community_id, d.par_id, d.seq, d.status, d.dept_code, d.e_mail, d.link_id, d.dept_name_eng, d.comp_id, d.modified_date";
  
  private static String COLUMNS_DEPT_ALL_WITH_DEPTH = "d.dept_id, d.dept_name, d.community_id, d.par_id, d.seq, d.status, d.dept_code, d.e_mail, d.link_id, d.dept_name_eng, d.comp_id, d.modified_date, (select dt.depth from dept_tree dt where dt.dept_id = d.dept_id and dt.par_id = ?) depth";
  
  private static String SELECT_DEPT_DEPT = "SELECT {0} FROM dept_global d WHERE d.dept_id = ?";
  
  private static String SELECT_DEPT_COLUMNS = "SELECT {0}  FROM dept_global WHERE dept_id = ?";
  
  private static String SELECT_DEPT_DEPTS = "SELECT {0}  FROM dept_global d  WHERE d.dept_id in ({1})";
  
  private static String SELECT_DEPT_AUTHDEPT = "SELECT {0} FROM dept_global d WHERE d.dept_id IN (SELECT ua.rel_id FROM usr_auth ua WHERE ua.user_id = ? and ua.auth in ({1})) AND d.status NOT IN ({2})";
  
  private static String COLUMNS_DEPT_DEPTFULLNAME = "d.dept_name";
  
  private static String COLUMNS_DEPT_DEPTFULLNAME_ENG = "CASE WHEN (d.dept_name_eng IS NULL OR d.dept_name_eng = '') THEN d.dept_name ELSE d.dept_name_eng END AS dept_name";
  
  private static String SELECT_DEPT_DEPTFULLNAME = "SELECT {0} FROM dept_global d, dept_tree dt WHERE dt.dept_id = ? AND dt.par_id = d.dept_id ORDER BY dt.depth DESC";
  
  private static String SELECT_DEPT_DEPTFULLNAME2 = "SELECT {0} FROM dept_global d WHERE dept_id = ? ORDER BY dept_id DESC";
  
  private static String SELECT_DEPT_ALL = "SELECT {0} FROM dept_global d WHERE 1 = 1 {1} {2}";
  
  private static String SELECT_DEPT_COMMUNITY = "SELECT {0} FROM dept_global d WHERE 1 = 1 {1} {2} {3}";
  
  private static String SELECT_DEPT_ONELEVEL = "SELECT {0} FROM dept_global d WHERE d.par_id = ? {1} {2}";
  
  private static String SELECT_DEPT_SUBTREE = "SELECT {0} FROM dept_global d WHERE d.par_id IN  (SELECT dept_id FROM dept_tree WHERE par_id = ?) {1} {2}";
  
  private static String SELECT_DEPT_PATH = "SELECT {0} FROM dept_global d, dept_tree dt WHERE dt.dept_id = ? AND d.dept_id = dt.par_id {1} {2}";
  
  private static String COND_DEPT_STATUS = " AND d.status not in (?, ?)";
  
  private static String COND_USER_STATUS = " AND u.status not in (?, ?)";
  
  private static String COND_DEPT_MODIFIED_DATE = " AND d.modified_date > ?";
  
  private static String COND_COMMUNITY_ID = " AND d.community_id = ?";
  
  private static String COND_DEPT_AUTH_FROM_DEPTTREE = " EXISTS ( SELECT /*+ RULE */dt.dept_id FROM dept_tree dt WHERE d.dept_id = dt.dept_id AND dt.par_id IN ( SELECT ua.rel_id FROM usr_auth ua WHERE ua.user_id = ? and ua.auth = ? ))";
  
  private static String COUNT_DEPT = "SELECT count(*) FROM dept_global d WHERE d.dept_id = ?";
  
  private static String COUNT_DEPT_CODE = "SELECT count(*) FROM dept_global d WHERE d.community_id = ? AND d.dept_code = ?";
  
  private static String COUNT_DEPT_NAME = "SELECT count(*) FROM dept_global d WHERE d.community_id = ? AND d.par_id = ? AND (d.dept_name = ? OR d.dept_name_eng = ?)";
  
  private static String COLUMNS_DEPT_FOR_EXPORT = "d.community_id, d.dept_id, d.dept_name, d.par_id, d.dept_code, d.seq, d.status, d.e_mail, d.link_id, d.dept_name_eng,d.comp_id, (SELECT p.dept_code FROM dept_global p WHERE p.dept_id= d.par_id) par_code, (SELECT count(*) FROM dept_tree dt WHERE dt.dept_id = d.dept_id) depth";
  
  private static String SELECT_DEPT_FOR_EXPORT = "SELECT {0} FROM dept_global d WHERE 1 = 1 {1} {2} {3} ORDER BY depth";
  
  private static String SELECT_DEPT_FOR_ROOT = "SELECT {0} FROM dept_global d WHERE d.par_id = ? {1} ORDER BY d.seq";
  
  private static String SELECT_CHILDDEPT_COUNT_BY_PAR = "SELECT d.par_id, COUNT(d.dept_id) AS count FROM dept_global d WHERE d.par_id IN ({0}) {1} GROUP BY d.par_id";
  
  private static String SELECT_USER_COUNT_BY_DEPT = "SELECT u.dept_id, COUNT(u.dept_id) AS count FROM usr_global u WHERE u.dept_id IN ({0}) {1} GROUP BY u.dept_id";
  
  public Dept getDept(String id) {
    MessageFormat format = new MessageFormat(SELECT_DEPT_DEPT);
    String sql = format.format(new String[] { COLUMNS_DEPT_ALL });
    return (Dept)getJdbcTemplate().queryForObject(sql, new Object[] { id }, deptRowMapper);
  }
  
  public List getAuthDeptList(String userID, String roles) {
    List<Object> params = new ArrayList();
    params.add(userID);
    String[] auths = roles.split(",");
    int size = auths.length;
    String macroAuth = "";
    for (int i = 0; i < size; i++) {
      macroAuth = macroAuth + ((i == 0) ? "?" : ",?");
      params.add(auths[i]);
    } 
    String macroStatus = "?,?";
    params.add("4");
    params.add("8");
    String[] macros = { COLUMNS_DEPT_ALL, macroAuth, macroStatus };
    MessageFormat format = new MessageFormat(SELECT_DEPT_AUTHDEPT);
    String sql = format.format(macros);
    return getJdbcTemplate().query(sql, params.toArray(), deptRowMapper);
  }
  
  public String getDeptFullName(String id, boolean isEnglish) {
    MessageFormat format = new MessageFormat(SELECT_DEPT_DEPTFULLNAME2);
    String sql = format.format(new String[] { isEnglish ? COLUMNS_DEPT_DEPTFULLNAME_ENG : COLUMNS_DEPT_DEPTFULLNAME });
    
    System.out.println("########### sql : "+sql);
    System.out.println("########### id : "+id);
    List<String> deptNames = getJdbcTemplate().query(sql, new Object[] { id }, deptNameRowMapper);
    System.out.println("########### deptNames : "+deptNames.toString());
    String fullDeptName = "";
    if (deptNames != null) {
      int size = deptNames.size();
      for (int i = 0; i < size; i++)
        fullDeptName = fullDeptName + ((i > 0) ? ("." + (String)deptNames.get(i)) : deptNames.get(i)); 
    } 
    return fullDeptName;
  }
  
  private String toDeptQuery(SearchKey key, List<Object> params) {
    if (key != null) {
      if (key instanceof DeptMngAuthKey) {
        DeptMngAuthKey tmp = (DeptMngAuthKey)key;
        params.add(tmp.getUserID());
        params.add(tmp.getAuth());
        return " AND " + COND_DEPT_AUTH_FROM_DEPTTREE;
      } 
      if (key instanceof MultiSearchKey) {
        List<SearchKey> keys = ((MultiSearchKey)key).keys();
        if (keys == null || keys.size() < 1)
          return ""; 
        String str = "";
        for (int i = 0; i < keys.size(); i++) {
          SearchKey tmp = keys.get(i);
          String condition = toDeptQuery(tmp, params);
          if (condition != null) {
            str = str + condition;
          } else {
            throw new IllegalArgumentException(key + " : " + tmp);
          } 
        } 
        return str;
      } 
      String query = SearchQuery.toDeptQuery(key, params);
      if (query != null)
        return " AND " + query; 
      throw new IllegalArgumentException(key.toString());
    } 
    return "";
  }
  
  public List getDeptList(List ids) {
    List<Object> params = new ArrayList();
    List<String> macros = new ArrayList<String>();
    macros.add(COLUMNS_DEPT_ALL);
    String macroIds = "";
    int size = ids.size();
    for (int i = 0; i < size; i++) {
      macroIds = macroIds + ((i == 0) ? "?" : ",?");
      params.add(ids.get(i));
    } 
    macros.add(macroIds);
    MessageFormat format = new MessageFormat(SELECT_DEPT_DEPTS);
    String sql = format.format(macros.toArray());
    return getJdbcTemplate().query(sql, params.toArray(), deptRowMapper);
  }
  
  public List getDeptList(String communityID, String base, int scope, SearchKey key) {
    return getDeptList(communityID, base, scope, key, false, false);
  }
  
  public List getDeptList(String communityID, String base, int scope, SearchKey key, DeptOrderByKey deptOrderByKey) {
    return getDeptList(communityID, base, scope, key, deptOrderByKey, false, false);
  }
  
  public List getDeptList(String communityID, String base, int scope, SearchKey key, boolean allStatus) {
    return getDeptList(communityID, base, scope, key, false, allStatus);
  }
  
  public List getDeptList(String communityID, String base, int scope, SearchKey key, DeptOrderByKey deptOrderByKey, boolean allStatus) {
    return getDeptList(communityID, base, scope, key, deptOrderByKey, false, allStatus);
  }
  
  public List getDeptIDs(String communityID, String base, int scope, SearchKey key) {
    return getDeptList(communityID, base, scope, key, true, false);
  }
  
  private List getDeptList(String communityID, String base, int scope, SearchKey key, boolean idOnly, boolean allStatus) {
    return getDeptList(communityID, base, scope, key, null, idOnly, allStatus);
  }
  
  private List getDeptList(String communityID, String base, int scope, SearchKey key, DeptOrderByKey deptOrderByKey, boolean idOnly, boolean allStatus) {
    DeptOrderKey deptOrderKey = null;
    
    List<Object> params = new ArrayList();
    List<String> macros = new ArrayList<String>();
    String sql = null;
    if (idOnly) {
      macros.add(COLUMNS_DEPT_DEPTID);
    } else if (scope != 3 && deptOrderByKey != null && deptOrderByKey.withDepth()) {
      macros.add(COLUMNS_DEPT_ALL_WITH_DEPTH);
      params.add((base == null) ? "000000101" : base);
    } else {
      macros.add(COLUMNS_DEPT_ALL);
    } 
    if (StringUtils.isBlank(base)) {
      if (StringUtils.isBlank(communityID)) {
        sql = SELECT_DEPT_ALL;
      } else {
        sql = SELECT_DEPT_COMMUNITY;
      } 
    } else {
      switch (scope) {
        case 1:
          sql = SELECT_DEPT_ONELEVEL;
          params.add(base);
          if (deptOrderByKey == null)
            deptOrderKey = new DeptOrderKey("5"); 
          break;
        case 2:
          sql = SELECT_DEPT_SUBTREE;
          params.add(base);
          break;
        case 3:
          sql = SELECT_DEPT_PATH;
          params.add(base);
          if (deptOrderKey == null)
            deptOrderKey = new DeptOrderKey("99", true); 
          break;
        default:
          throw new IllegalArgumentException(String.valueOf(scope));
      } 
    } 
    String statusMacro = "";
    if (!allStatus) {
      statusMacro = COND_DEPT_STATUS;
      params.add("4");
      params.add("8");
    } 
    macros.add(statusMacro);
    macros.add(toDeptQuery(key, params));
    if (StringUtils.isNotBlank(communityID))
      if (StringUtils.isBlank(base)) {
        macros.add(COND_COMMUNITY_ID);
        params.add(communityID);
      } else {
        sql = sql + " {3}";
        macros.add(COND_COMMUNITY_ID);
        params.add(communityID);
      }  
    MessageFormat format = new MessageFormat(sql);
    sql = format.format(macros.toArray());
    if (idOnly)
      return getJdbcTemplate().query(sql, params.toArray(), deptIDRowMapper); 
    if (deptOrderKey != null)
      sql = sql + " ORDER BY " + deptOrderKey.toString(); 
    
    return getJdbcTemplate().query(sql, params.toArray(), deptRowMapper);
  }
  
  public List getDeptListForExport(String communityID, boolean allStatus) {
    return getDeptListForExport(communityID, allStatus, null);
  }
  
  public List getDeptListForExport(String communityID, boolean allStatus, Date exportDate) {
    List<Object> params = new ArrayList();
    List<String> macros = new ArrayList<String>();
    String sql = SELECT_DEPT_FOR_EXPORT;
    macros.add(COLUMNS_DEPT_FOR_EXPORT);
    if (null == communityID) {
      macros.add("");
    } else {
      macros.add(COND_COMMUNITY_ID);
      params.add(communityID);
    } 
    String statusMacro = "";
    if (!allStatus) {
      statusMacro = COND_DEPT_STATUS;
      params.add("4");
      params.add("8");
    } 
    macros.add(statusMacro);
    if (exportDate != null) {
      macros.add(COND_DEPT_MODIFIED_DATE);
      params.add(exportDate);
    } else {
      macros.add("");
    } 
    MessageFormat format = new MessageFormat(sql);
    sql = format.format(macros.toArray());
    return getJdbcTemplate().query(sql, params.toArray(), exportDeptRowMapper);
  }
  
  public Map getAttribute(String id, String attribute) {
    MessageFormat format = new MessageFormat(SELECT_DEPT_COLUMNS);
    String sql = format.format(new String[] { attribute });
    return getJdbcTemplate().queryForMap(sql, new Object[] { id });
  }
  
  public boolean existDept(String id) {
    return (getJdbcTemplate().queryForInt(COUNT_DEPT, new Object[] { id }) > 0);
  }
  
  public boolean existDeptByCode(String communityID, String code) {
    return (getJdbcTemplate().queryForInt(COUNT_DEPT_CODE, new Object[] { communityID, code }) > 0);
  }
  
  public boolean existDeptByName(String communityID, String parentID, String name) {
    return (getJdbcTemplate().queryForInt(COUNT_DEPT_NAME, new Object[] { communityID, parentID, name, name }) > 0);
  }
  
  public List getRootDeptList(String communityID, String parID) {
    List<Object> params = new ArrayList();
    List<String> macros = new ArrayList<String>();
    String sql = SELECT_DEPT_FOR_ROOT;
    macros.add(COLUMNS_DEPT_ALL);
    params.add(parID);
    if (communityID != null) {
      macros.add(COND_COMMUNITY_ID);
      params.add(communityID);
    } else {
      macros.add("");
    } 
    MessageFormat format = new MessageFormat(sql);
    sql = format.format(macros.toArray());
    return getJdbcTemplate().query(sql, params.toArray(), deptRowMapper);
  }
  
  public List countChildDept(List parentIDs, boolean allStatus) {
    if (parentIDs == null || parentIDs.size() < 1)
      return null; 
    int[] counts = new int[parentIDs.size()];
    List<Object> params = new ArrayList();
    String macroIDs = "";
    for (int i = 0; i < parentIDs.size(); i++) {
      macroIDs = macroIDs + ((i == 0) ? "?" : ",?");
      params.add(parentIDs.get(i));
    } 
    String statusMacro = "";
    if (!allStatus) {
      statusMacro = COND_DEPT_STATUS;
      params.add("4");
      params.add("8");
    } 
    String sql = (new MessageFormat(SELECT_CHILDDEPT_COUNT_BY_PAR)).format(new String[] { macroIDs, statusMacro });
    return getJdbcTemplate().query(sql, params.toArray(), idAndCountMapper);
  }
  
  public List countUser(List deptIDs, boolean allStatus) {
    if (deptIDs == null || deptIDs.size() < 1)
      return null; 
    List<Object> params = new ArrayList();
    String macroIDs = "";
    for (int i = 0; i < deptIDs.size(); i++) {
      macroIDs = macroIDs + ((i == 0) ? "?" : ",?");
      params.add(deptIDs.get(i));
    } 
    String statusMacro = "";
    if (!allStatus) {
      statusMacro = COND_USER_STATUS;
      params.add("4");
      params.add("8");
    } 
    String sql = (new MessageFormat(SELECT_USER_COUNT_BY_DEPT)).format(new String[] { macroIDs, statusMacro });
    return getJdbcTemplate().query(sql, params.toArray(), idAndCountMapper);
  }
  
  private static RowMapper deptRowMapper = new RowMapper() {
      public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        DeptImpl deptImpl = new DeptImpl();
        deptImpl.setID(rs.getString("dept_id"));
        deptImpl.setName(rs.getString("dept_name"));
        deptImpl.setCommunityID(rs.getString("community_id"));
        deptImpl.setParentID(rs.getString("par_id"));
        deptImpl.setSeq(rs.getInt("seq"));
        deptImpl.setStatus(rs.getString("status"));
        deptImpl.setDeptCode(rs.getString("dept_code"));
        deptImpl.setEmail(rs.getString("e_mail"));
        deptImpl.setLinkID(rs.getString("link_id"));
        deptImpl.setNameEng(rs.getString("dept_name_eng"));
        deptImpl.setCompanyID(rs.getString("comp_id"));
        deptImpl.setModifiedDate(rs.getTimestamp("modified_date"));
        return deptImpl;
      }
    };
  
  private static RowMapper exportDeptRowMapper = new RowMapper() {
      public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("COMMUNITY_ID", rs.getString("community_id"));
        map.put("DEPT_ID", rs.getString("dept_id"));
        map.put("DEPT_NAME", rs.getString("dept_name"));
        map.put("PAR_ID", rs.getString("par_id"));
        map.put("DEPT_CODE", rs.getString("dept_code"));
        map.put("SEQ", Integer.valueOf(rs.getInt("seq")));
        map.put("STATUS", rs.getString("status"));
        map.put("E_MAIL", rs.getString("e_mail"));
        map.put("LINK_ID", rs.getString("link_id"));
        map.put("DEPT_NAME_ENG", rs.getString("dept_name_eng"));
        map.put("COMP_ID", rs.getString("comp_id"));
        map.put("PAR_CODE", rs.getString("par_code"));
        map.put("DEPTH", Integer.valueOf(rs.getInt("depth")));
        return map;
      }
    };
  
  private static RowMapper deptNameRowMapper = new RowMapper() {
      public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        return rs.getString("dept_name");
      }
    };
  
  private static RowMapper deptIDRowMapper = new RowMapper() {
      public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        return rs.getString("dept_id");
      }
    };
  
  private static RowMapper idAndCountMapper = new RowMapper() {
      public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
        return new IDandCount(rs.getString(1), rs.getInt(2));
      }
    };
}
