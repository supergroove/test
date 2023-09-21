var CONTEXT = "/directory-web";

//var USER	= '';
//var EMAIL	= '';
var DEPT	= '$';
var SDEPT	= '$+';
var GROUP	= '@';
var CONTACT	= '#';
var POS		= '~';
var EMP		= '^';
var DIRGROUP = '%';

var GROUP_ORG = "G";

function parseType(s) {
	var arr = new Array(2);
	if (/^\$\+/.test(s)) { // '$+'
		arr[0] = SDEPT;
		arr[1] = s.substring(2);
	} else if (/^\+/.test(s)) { // '+'
		arr[0] = SDEPT;
		arr[1] = s.substring(1);
	} else if (/^\$/.test(s)) { // '$'
		arr[0] = DEPT;
		arr[1] = s.substring(1);
	} else if (/^[@*]/.test(s)) { // '@' or '*'
		arr[0] = GROUP;
		arr[1] = s.substring(1);
	} else if (/^#/.test(s)) { // '#'
		arr[0] = CONTACT;
		arr[1] = s.substring(1);
	} else if (/^~/.test(s)) { // '~'
		arr[0] = POS;
		arr[1] = s.substring(1);
	} else if (/^\^/.test(s)) { // '^'
		arr[0] = EMP;
		arr[1] = s.substring(1);
	} else if (/^%/.test(s)) { // '%'
		arr[0] = DIRGROUP;
		arr[1] = s.substring(1);
	} else {
		arr[0] = '';
		arr[1] = s;
	}
	return arr;
}

function Recipient(uniqueID, name, deptID, deptName, orgType) {
	this.uniqueID = uniqueID;
	if (name != null && name.indexOf("(*") > 0) { // 사용자명(*사원번호)
		name = name.substring(0, name.indexOf("(*"));
	}
	this.name = $.trim(name);
	this.deptID = deptID;
	this.deptName = deptName;
	this.orgType = orgType;
	
	this.isDeptType = function() {
		var type = parseType(this.uniqueID)[0];
		return type == DEPT || type == SDEPT;
	}
	this.isUserType = function() {
		return parseType(this.uniqueID)[0] == '' && this.uniqueID.indexOf('@') < 0;
	}
	this.equals = function(o) {
		if (this.isDeptType() && o.isDeptType()) {
			return parseType(this.uniqueID)[1] == parseType(o.uniqueID)[1];
		} else {
			return this.uniqueID == o.uniqueID;
		}
	}
	this.toString = function(value) {
		switch (value) {
		case "id"  : return this.uniqueID;
		case "name": return this.name;
		case "deptID" : return this.deptID;
		case "deptName" : return this.deptName;
		case "orgType" : return this.orgType;
		default    : return this.uniqueID + "|" + this.name + "|" + this.deptID + "|" + this.deptName + "|" + this.orgType;
		}
	}
}

function RecipientList() {
	this.recipients = [];
	
	this.size = function() {
		return this.recipients.length;
	}
	this.get = function(i) {
		return this.recipients[i];
	}
	this.push = function(o) {
		if (!this.contains(o)) {
			this.recipients.push(o);
		}
	}
	this.remove = function(o) {
		for (var i = 0; i < this.recipients.length; i++) {
			if (this.recipients[i].equals(o)) {
				this.recipients.splice(i, 1);
				break;
			}
		}
	}
	this.removeAll = function() {
		this.recipients = [];
	}
	this.removeUserAll = function() {
		var tmpList = [];
		for (var i = 0; i < this.recipients.length; i++) {
			if (!this.recipients[i].isUserType()) {
				tmpList.push(this.recipients[i]);
			}
		}
		this.recipients = tmpList;
	}
	this.contains = function(o) {
		for (var i = 0; i < this.recipients.length; i++) {
			if (this.recipients[i].equals(o)) return true;
		}
		return false;
	}
	this.toString = function(value) {
		var s = "";
		for (var i = 0; i < this.recipients.length; i++) {
			s += this.recipients[i].toString(value) + ";";
		}
		return s;
	}
	this.parse = function(str) {
		this.removeAll();
		var recArr = str.split(/[,;]/);
		for (var i = 0; i < recArr.length; i++) {
			if ($.trim(recArr[i])) {
				var props = $.trim(recArr[i]).split(/\|/);
				this.push(new Recipient(props[0], props[1], props[2], props[3]));
			}
		}
	}
}

var orgPopup = {
	toList : new RecipientList(),
	ccList : new RecipientList(),
	bccList : new RecipientList(),
	memberList: new RecipientList(),
	
	load : function(to, cc, bcc) {
		if (to) this.toList.parse(to);
		if (cc) this.ccList.parse(cc);
		if (bcc) this.bccList.parse(bcc);
	},
	printRecipientList : function() {
		$("#hwto").val(this.toList.toString("name"));
		$("#hwcc").val(this.ccList.toString("name"));
		$("#hwbcc").val(this.bccList.toString("name"));
	},
	onSelect : function(select, o) {
		if (select) {
			var list = this[($("#recType").val() || "to") + "List"];
			if ($("#selectMode").val() == 1) {
				list.removeAll();
			} else if ($("#isUserSingle").val() == "true" && o.isUserType()) {
				list.removeUserAll();
			}
			list.push(o);
		} else {
			this.toList.remove(o);
			this.ccList.remove(o);
			this.bccList.remove(o);
		}
	},
	createOrgTree : function() {
		var activeSelect = false;
		if ($("#activeSelect").val() == "1" && $("#selectMode").val() == "1" && $("#checkbox").val() != "list") {
			activeSelect = true;
		}
		$("#orgTree").directorytree({
			idPrefix: "org",
			checkbox: (activeSelect ? false : $("#checkbox").val() != "list"),
			selectMode: $("#selectMode").val(),
			checkMode: $("#checkbox").val(),
			openerType: $("#openerType").val(),						 
			onActivate: function(dtnode) {
				if ($("#checkbox").val() != "tree") {
					orgPopup.viewUserList(dtnode.data.key);
				}
				if (activeSelect && !dtnode.isSelected()) {
					dtnode.toggleSelect();
				}
			},
			onSelect: function(select, dtnode) {
				var deptType = ($("input[name='subdept']:checked").val() == "true") ? SDEPT : DEPT;
				var o = new Recipient(deptType + dtnode.data.key, deptType + dtnode.data.title);
				orgPopup.onSelect(select, o);
				orgPopup.printRecipientList();
				if ($("#useSelectAll").val() == "true" 
						&& $("#selectMode").val() == "2" 
						&& deptType == DEPT) {	// useSelectAll && checkbox && deptList
					if (dtnode.isSelected()) {
						orgPopup.expandAllOrgTree(dtnode);
					} else {
						orgPopup.selectAll(dtnode, false);
					}	
				}							
			},
			onLazyRead: function(dtnode) {
				orgPopup.expandOrgTree(dtnode);
			},
			init: function() {
				orgPopup.initOrgTree();
			}
		});
	},
	initOrgTree : function(isExpandAll) {
		$("#orgTree").dynatree("getRoot").removeChildren();
		$("#orgTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "initOrgTree", baseDept: $("#baseDept").val(), startDept: $("#startDept").val(), isExpandAll: isExpandAll },
			success: function(dtnode) {
				orgPopup.callbackDept(dtnode, $("#notUseDept").val(), $("#openerType").val());
				
				if ( $("#baseDept").val() != undefined ) {
					var actnode = dtnode.tree.getNodeByKey($("#baseDept").val());
					if (actnode != null) {
						actnode.focus();
						// jquery.dynatree.js 의 _getInnerHtml 함수에서 <a> 태그의 href를 제거했기 때문에, focus()를 호출해도 스크롤이 이동하지 않는다.
						// 따라서, 스크롤을 이동시키기 위해 actnode의 위치를 scrollTop으로 설정해야 한다.
						for (var i = 0; i < dtnode.childList.length; i++) {
							if (dtnode.childList[i].data.isFolder) {
								var tmp = 20; // offset top 값으로 위치를 구하기 때문에, actnode의 높이를 더해야 부서명이 보인다.
								tmp += $(actnode.span).offset().top - $(dtnode.childList[i].span).offset().top; // 트리div 내에서의 actnode 위치
								tmp -= document.getElementById("orgTree").clientHeight; // 트리div의 스크롤 안쪽 높이
								$("#orgTree").scrollTop(tmp);
								break;
							}
						}
						actnode.activate(); // do activation
						
						if ($("#selectMode").val() == "1"
								&& $("#checkbox").val() != "list"
								&& (($("#openerType").val() == "A" && actnode.data.rbox == "false")) 
								|| actnode.data.isNotUse) {
							actnode.deactivate();
						}
					}
				}
				if ($("#useRootdept").val() != "true") {
					for (var i = 0; i < dtnode.childList.length; i++) {
						dtnode.childList[i].data.hideCheckbox = true;
						dtnode.childList[i].render();
					}
				}				
			}
		});
	},
	closeAllOrgTree : function() {
		$("#orgTree").dynatree("getRoot").visit(function(node) {
			//if (node.hasChildren()) node.expand(false);
			node.expand(false);
		});
	},
	expandOrgTree : function(dtnode) {
		dtnode.appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "expandOrgTree", deptID: dtnode.data.key },
			success: function(dtnode) {
				orgPopup.callbackDept(dtnode, $("#notUseDept").val(), $("#openerType").val());
			}
		});
	},
	expandAllOrgTree : function(dtnode) {
		dtnode.appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "expandOrgTree", deptID: dtnode.data.key, scope: "subtree" },
			success: function(dtnode) {
				orgPopup.callbackDept(dtnode, $("#notUseDept").val(), $("#openerType").val());
				orgPopup.selectAll(dtnode, true);
			}
		});
	},
	searchDept : function() {
		var searchValue = $("#deptSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length ==	0) {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		if (searchValue.val().length < 2) {
			alert($("#message_minLength").val());
			searchValue.focus();
			return false;
		}
		if (!this.isValidSearchName(searchValue.val())) {
			alert($("#message_invalidvalue").val());
			searchValue.focus();
			return false;
		}
		$("#orgTree").dynatree("getRoot").removeChildren();
		$("#orgTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: {
				acton: "searchDept",
				startDept: $("#startDept").val(),
				searchValue: searchValue.val()
			},
			success: function(dtnode) {
				orgPopup.callbackDept(dtnode, $("#notUseDept").val(), $("#openerType").val());
			}
		});
		return true;
	},
	callbackDept : function(dtnode, notUseDept, openerType) {
		dtnode.visit(function(dtnode) {
			var o = new Recipient(DEPT + dtnode.data.key, DEPT + dtnode.data.title);
			if (orgPopup.toList.contains(o)
					|| orgPopup.ccList.contains(o)
					|| orgPopup.bccList.contains(o)) {
				dtnode._select(true, false, false);
			}
			// FIXME: notUseDept.split(/[,;]/) for (...) ???
			if (notUseDept && notUseDept.indexOf(dtnode.data.key) > -1) {
				dtnode.data.isNotUse = true;
				dtnode.data.addClass = "ui-dynatree-notusedept";
				dtnode.data.unselectable = true;
				dtnode.render();
			}
			if (openerType == "A" && dtnode.data.rbox == "false") {
				dtnode.data.addClass = dtnode.bExpanded ? "ui-dynatree-statusnode-rbox-o" : "ui-dynatree-statusnode-rbox";
				dtnode.data.unselectable = true;
				dtnode.render();
			}
		});
	},
	selectAll : function(dtnode, sel) {
		dtnode.visit(function(node) {
			node.expand(sel);
			node.select(sel);
		});
	},
	viewUserList : function(deptID) {
		$("#userList").load(CONTEXT + "/org.do", {
			acton: "userList",
			display: $("#display").val(),
			dutiesUsed: $("#dutiesUsed").val(),
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			useAbsent: $("#useAbsent").val(),
			deptID: deptID			
		});
	},
	searchUser : function() {
		var searchValue = $("#userSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length == 0 && $("#userSearchType").val() != "role") {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		$("#userList").load(CONTEXT + "/org.do", {
			acton: "searchUser",
			display: $("#display").val(),
			dutiesUsed: $("#dutiesUsed").val(),
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			useAbsent: $("#useAbsent").val(),
			searchType: $("#userSearchType").val(),
			searchValue: searchValue.val(),
			searchRole: $("#userSearchRole").val(),
			role_subdept: $("#role_subdept").is(":checked"),
			deptID: $("#userSearchBase").val(),
			startDept: $("#startDept").val()
		});
		return true;
	},
	toggleUserAll : function() {
		if ($("#checkUserAll").is(":checked")) {
			$("input[name='checkUser']").each(function() {
				if (!$(this).is(":disabled") && !$(this).is(":checked")) {
					$(this).attr("checked", true);
					var o = new Recipient($(this).val(), $("#checkUser_" + $(this).val()).val(), $("#checkDept_" + $(this).val()).val(), $("#checkDeptName_" + $(this).val()).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		} else {
			$("input[name='checkUser']").each(function() {
				if ($(this).is(":checked")) {
					$(this).attr("checked", false);
					var o = new Recipient($(this).val(), $("#checkUser_" + $(this).val()).val(), $("#checkDept_" + $(this).val()).val(), $("#checkDeptName_" + $(this).val()).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		}
		this.printRecipientList();
	},
	toggleUser : function(obj) {
		if ($("#checkUserAll").is(":checked") && !obj.is(":checked")) {
			$("#checkUserAll").attr("checked", false);
		}
		if (($("#selectMode").val() == 1 || $("#isUserSingle").val() == "true") && obj.is(":checked")) {
			$("input[name='checkUser']").each(function() {
				$(this).attr("checked", false);
			});
			obj.attr("checked", true);
		}
		var o = new Recipient(obj.val(), $("#checkUser_" + obj.val()).val(), $("#checkDept_" + obj.val()).val(), $("#checkDeptName_" + obj.val()).val());
		this.onSelect(obj.is(":checked"), o);
		this.printRecipientList();
	},
	viewUserSpec : function(userID) {
		$.ajax({
			url: CONTEXT + "/org.do",
			data: {
				acton: "viewUserSpec",
				viewName: "view/viewUserSpec",
				userID: userID
			},
			success: function(html) {
				directory_divPopup.open(html);
			}
		});
	},
	createContactTree : function() {
		$("#contactTree").directorytree({
			idPrefix: "contact",
			checkbox: $("#checkbox").val() != "list",
			selectMode: $("#selectMode").val(),
			onActivate: function(dtnode) {
				if ($("#checkbox").val() != "tree") {
					orgPopup.viewContactList(dtnode.data.key, dtnode.data.scope);
				}
			},
			onSelect: function(select, dtnode) {
				var o = new Recipient(CONTACT + dtnode.data.key, CONTACT + dtnode.data.title);
				orgPopup.onSelect(select, o);
				orgPopup.printRecipientList();
			},
			init: function() {
				orgPopup.initContactTree();
			}
		});
	},
	initContactTree : function() {
		$("#contactTree").dynatree("getRoot").removeChildren();
		$("#contactTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "contactTree" },
			success: function(dtnode) {
				dtnode.visit(function(dtnode) {
					if (dtnode.data.key) {
						var o = new Recipient(CONTACT + dtnode.data.key, CONTACT + dtnode.data.title);
						if (orgPopup.toList.contains(o)
								|| orgPopup.ccList.contains(o)
								|| orgPopup.bccList.contains(o)) {
							dtnode._select(true, false, false);
						}
					}
				});
				
				for (var i = 0; i < dtnode.childList.length; i++) {
					if (dtnode.childList[i].data.isFolder) {
						dtnode.childList[i].activate(); // do activation
						break;
					}
				}
			}
		});
	},
	viewContactList : function(base, type) {
		var scope = 1;
		if (type == 'dept') scope = 2;
		if (type == 'group') scope = 3;
			
		$("#contactList").load(CONTEXT + "/org.do", {
			acton: "contactList",
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			base: base,
			scope: scope
		});
	},
	searchContact : function() {
		var searchValue = $("#contactSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length == 0) {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		
		var nth;
		switch ($("#contactSearchType").val()) {
		case "name"   : nth = 2; break;
		case "email"  : nth = 3; break;
		case "company": nth = 4; break;
		}
		var s = searchValue.val().toUpperCase();
		$("#directory-table-contactList tr:gt(0)").each(function() {
			$(this).find("td:nth-child("+ nth +")").text().toUpperCase().indexOf(s) > -1 ? $(this).show() : $(this).hide();
		});
		$("input[name='checkContact']:visible").length > 0 ? $("#contactList_NoData").hide() : $("#contactList_NoData").show();
		return true;
	},
	toggleContactAll : function() {
		var a = new Date();
		if ($("#checkContactAll").is(":checked")) {
			$("input[name='checkContact']").each(function() {
				if (!$(this).is(":disabled") && !$(this).is(":checked")) {
					$(this).attr("checked", true);
					var o = new Recipient($(this).val(), $(this).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		} else {
			$("input[name='checkContact']").each(function() {
				if (!$(this).is(":disabled") && $(this).is(":checked")) {
					$(this).attr("checked", false);
					var o = new Recipient($(this).val(), $(this).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		}
		var b = new Date();
		var l = b.getTime() - a.getTime();
		$("#profile1").val(parseInt($("#profile1").val()) + l);
		this.printRecipientList();
	},
	toggleContact : function(obj) {
		if ($("#checkContactAll").is(":checked") && !obj.is(":checked")) {
			$("#checkContactAll").attr("checked", false);
		}
		if ($("#selectMode").val() == 1 && obj.is(":checked")) {
			$("input[name='checkContact']").each(function() {
				$(this).attr("checked", false);
			});
			obj.attr("checked", true);
		}
		var o = new Recipient(obj.val(), obj.val());
		this.onSelect(obj.is(":checked"), o);
		this.printRecipientList();
	},
	createGroupTree : function() {
		var activeSelect = false;
		if ($("#activeSelect").val() == "1" && $("#selectMode").val() == "1" && $("#checkbox").val() != "list") {
			activeSelect = true;
		}
		$("#groupTree").directorytree({
			idPrefix: "group",
			checkbox: (activeSelect ? false : $("#checkbox").val() != "list"),
			selectMode: $("#selectMode").val(),
			onActivate: function(dtnode) {
				if ($("#checkbox").val() != "tree") {
					orgPopup.viewMemberList(dtnode.data.key);
				}
				if (activeSelect && !dtnode.isSelected()) {
					dtnode.toggleSelect();
				}
			},
			onSelect: function(select, dtnode) {
				var o = new Recipient(GROUP + dtnode.data.key, GROUP + dtnode.data.title);
				orgPopup.onSelect(select, o);
				orgPopup.printRecipientList();
			},
			init: function() {
				orgPopup.initGroupTree();
			}
		});
	},
	initGroupTree : function() {
		$("#groupTree").dynatree("getRoot").removeChildren();
		$("#groupTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "groupTree", groupType: $("#groupType").val() },
			success: function(dtnode) {
				dtnode.visit(function(dtnode) {
					if (dtnode.data.key) {
						var o = new Recipient(GROUP + dtnode.data.key, GROUP + dtnode.data.title);
						if (orgPopup.toList.contains(o)
								|| orgPopup.ccList.contains(o)
								|| orgPopup.bccList.contains(o)) {
							dtnode._select(true, false, false);
						}
					}
				});
				
				for (var i = 0; i < dtnode.childList.length; i++) {
					if (dtnode.childList[i].data.isFolder) {
						dtnode.childList[i].activate(); // do activation
						break;
					}
				}
			}
		});
	},	
	viewMemberList : function(base) {
		$("#memberList").load(CONTEXT + "/org.do", {
			acton: "memberList",
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			groupType: $("#groupType").val(),
			base: base
		});
	},
	getMemberJSON : function(base) {
		orgPopup.memberList.removeAll();
		$.ajax({
			type : "post",
			cache : false,
			url : CONTEXT + "/org.do",
			async : false,
			data : {
				acton : "memberJSON",
				base : base
			},
			dataType : "json",
			success : function(data, status) {
				$.each(data,
						function(index, entry) {
							orgPopup.memberList.push(new Recipient(entry["uniqueID"], entry["name"], entry["deptID"], entry["deptName"], GROUP_ORG));
						});
			}
		});
	},
	searchMember : function() {
		var searchValue = $("#memberSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length == 0) {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		
		var nth;
		switch ($("#memberSearchType").val()) {
		case "name": nth = 2; break;
		case "dept": nth = 3; break;
		case "pos" : nth = 4; break;
		}
		var s = searchValue.val().toUpperCase();
		$("#memberList_User tr:gt(0)").each(function()    { $(this).find("td:nth-child("+ nth +")").text().toUpperCase().indexOf(s) > -1 ? $(this).show() : $(this).hide();} );
		$("#memberList_SubDept tr:gt(0)").each(function() { $(this).find("td:nth-child(2)").text().toUpperCase().indexOf(s) > -1 ? $(this).show() : $(this).hide(); });
		$("#memberList_Dept tr:gt(0)").each(function()    { $(this).find("td:nth-child(2)").text().toUpperCase().indexOf(s) > -1 ? $(this).show() : $(this).hide(); });
		$("#memberList_Email tr:gt(0)").each(function()   { $(this).find("td:nth-child(2)").text().toUpperCase().indexOf(s) > -1 ? $(this).show() : $(this).hide(); });
		
		$("input[name='checkMember_User']:visible").length > 0    ? $("#memberList_User th").show()    : $("#memberList_User th").hide();
		$("input[name='checkMember_SubDept']:visible").length > 0 ? $("#memberList_SubDept th").show() : $("#memberList_SubDept th").hide();
		$("input[name='checkMember_Dept']:visible").length > 0    ? $("#memberList_Dept th").show()    : $("#memberList_Dept th").hide();
		$("input[name='checkMember_Email']:visible").length > 0   ? $("#memberList_Email th").show()   : $("#memberList_Email th").hide();
		$("input[name^='checkMember_']:visible").length > 0 ? $("#memberList_NoData").hide() : $("#memberList_NoData").show();
		return true;
	},
	toggleMember_All : function(type) {
		var checkname;
		var prefix = '';
		if (type == 'USER') {
			checkname = "checkMember_User";
		} else if (type == 'SDEPT') {
			checkname = "checkMember_SubDept";
			prefix = SDEPT;
		} else if (type == 'DEPT') {
			checkname = "checkMember_Dept";
			prefix = DEPT;
		} else if (type == 'EMAIL') {
			checkname = "checkMember_Email";
		}
	
		if ($("#" + checkname + "All").is(":checked")) {
			$("input[name='" + checkname + "']").each(function() {
				if ($(this).is(":visible") && !$(this).is(":disabled") && !$(this).is(":checked")) {
					$(this).attr("checked", true);
					var o;
					if (type == 'USER') {
						o = new Recipient(prefix + $(this).val(), prefix + $("#" + checkname + "_" + $(this).val()).val(), 
								prefix + $("#checkMember_Dept_" + $(this).val()).val(), 
								prefix + $("#checkMember_DeptName_" + $(this).val()).val(),
								GROUP_ORG);	
					} else {
						o = new Recipient(prefix + $(this).val(), prefix + (type == 'EMAIL' ? $(this).val()
								: $("#" + checkname + "_" + $(this).val()).val()), "", "", GROUP_ORG);	
					}					
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		} else {
			$("input[name='" + checkname + "']").each(function() {
				if ($(this).is(":visible") && !$(this).is(":disabled") && $(this).is(":checked")) {
					$(this).attr("checked", false);
					var o;
					if (type == 'USER') {
						o = new Recipient(prefix + $(this).val(), prefix + $("#" + checkname + "_" + $(this).val()).val(), 
								prefix + $("#checkMember_Dept_" + $(this).val()).val(),
								prefix + $("#checkMember_DeptName_" + $(this).val()).val(),
								GROUP_ORG);	
					} else {
						o = new Recipient(prefix + $(this).val(), prefix + (type == 'EMAIL' ? $(this).val()
								: $("#" + checkname + "_" + $(this).val()).val()), "", "", GROUP_ORG);	
					}					
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		}
		this.printRecipientList();
	},
	toggleMember : function(type, obj) {
		var checkname;
		if (type == 'USER') {
			checkname = "checkMember_User";
		} else if (type == 'SDEPT') {
			checkname = "checkMember_SubDept";
			prefix = SDEPT;
		} else if (type == 'DEPT') {
			checkname = "checkMember_Dept";
			prefix = DEPT;
		} else if (type == 'EMAIL') {
			checkname = "checkMember_Email";
		}
		
		if ($("#" + checkname + "All").is(":checked") && !obj.is(":checked")) {
			$("#" + checkname + "All").attr("checked", false);
		}
		if ($("#selectMode").val() == 1 && obj.is(":checked")) {
			$("input[name='checkMember_User']").each(function() {
				$(this).attr("checked", false);
			});
			$("input[name='checkMember_SubDept']").each(function() {
				$(this).attr("checked", false);
			});
			$("input[name='checkMember_Dept']").each(function() {
				$(this).attr("checked", false);
			});
			$("input[name='checkMember_Email']").each(function() {
				$(this).attr("checked", false);
			});
			obj.attr("checked", true);
		}
		
		var o;
		if (type == 'USER') {
			o = new Recipient(obj.val(), $("#checkMember_User_" + obj.val()).val(), $("#checkMember_Dept_" + obj.val()).val(), $("#checkMember_DeptName_" + obj.val()).val(), GROUP_ORG);
		} else if (type == 'SDEPT') {
			o = new Recipient(SDEPT + obj.val(), SDEPT + $("#checkMember_SubDept_" + obj.val()).val(), "", "", GROUP_ORG);
		} else if (type == 'DEPT') {
			o = new Recipient(DEPT + obj.val(), DEPT + $("#checkMember_Dept_" + obj.val()).val(), "", "", GROUP_ORG);
		} else if (type == 'EMAIL') {
			o = new Recipient(obj.val(), obj.val(), "", "", GROUP_ORG);
		}
		this.onSelect(obj.is(":checked"), o);
		this.printRecipientList();
	},
/* dirGroup : start */
	createDirGroupTree : function() {
		var activeSelect = false;
		if ($("#activeSelect").val() == "1" && $("#selectMode").val() == "1" && $("#checkbox").val() != "list") {
			activeSelect = true;
		}
		$("#directory-dirGroupTree").directorytree({
			idPrefix: "dirGroup",
			checkbox: (activeSelect ? false : $("#checkbox").val() != "list"),
			selectMode: $("#selectMode").val(),
			onActivate: function(dtnode) {
				if ($("#checkbox").val() != "tree") {
					orgPopup.viewDirGroupMemberList(dtnode.data.key);
				}
				if (activeSelect && !dtnode.isSelected()) {
					dtnode.toggleSelect();
				}
			},
			onSelect: function(select, dtnode) {
				var o = new Recipient(DIRGROUP + dtnode.data.key, DIRGROUP + dtnode.data.title);
				orgPopup.onSelect(select, o);
				orgPopup.printRecipientList();
			},
			onLazyRead: function(dtnode) {
				orgPopup.expandDirGroupTree(dtnode);
			},
			init: function() {
				orgPopup.initDirGroupTree();
			}
		});
	},
	initDirGroupTree : function(isExpandAll) {
		$("#directory-dirGroupTree").dynatree("getRoot").removeChildren();
		if (!$("#directory-dirGroupTree-hirID").val()) {
			return;
		}
		$("#directory-dirGroupTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "initDirGroupTree", hirID: $("#directory-dirGroupTree-hirID").val(), isExpandAll: isExpandAll },
			success: function(dtnode) {
				orgPopup.callbackDirGroup(dtnode);
				
				for (var i = 0; i < dtnode.childList.length; i++) {
					if (dtnode.childList[i].data.isFolder) {
						dtnode.childList[i].activate(); // do activation
						break;
					}
				}
			}
		});
	},
	closeAllDirGroupTree : function() {
		$("#directory-dirGroupTree").dynatree("getRoot").visit(function(node) {
			//if (node.hasChildren()) node.expand(false);
			node.expand(false);
		});
	},
	expandDirGroupTree : function(dtnode) {
		dtnode.appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: { acton: "expandDirGroupTree", groupID: dtnode.data.key },
			success: function(dtnode) {
				orgPopup.callbackDirGroup(dtnode);
			}
		});
	},
	searchDirGroup : function() {
		var searchValue = $("#directory-dirGroupSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length ==	0) {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		if (searchValue.val().length < 2) {
			alert($("#message_minLength").val());
			searchValue.focus();
			return false;
		}
		if (!this.isValidSearchName(searchValue.val())) {
			alert($("#message_invalidvalue").val());
			searchValue.focus();
			return false;
		}
		$("#directory-dirGroupTree").dynatree("getRoot").removeChildren();
		$("#directory-dirGroupTree").dynatree("getRoot").appendAjax({
			url: CONTEXT + "/org.do",
			type: "post",
			data: {
				acton: "searchDirGroup",
				searchValue: searchValue.val()
			},
			success: function(dtnode) {
				orgPopup.callbackDirGroup(dtnode);
			}
		});
		return true;
	},
	callbackDirGroup : function(dtnode) {
		dtnode.visit(function(dtnode) {
			var o = new Recipient(DIRGROUP + dtnode.data.key, DIRGROUP + dtnode.data.title);
			if (orgPopup.toList.contains(o)
					|| orgPopup.ccList.contains(o)
					|| orgPopup.bccList.contains(o)) {
				dtnode._select(true, false, false);
			}
		});
	},
	viewDirGroupMemberList : function(groupID) {
		$("#directory-dirGroupMemberList").load(CONTEXT + "/org.do", {
			acton: "dirGroupMemberList",
			display: $("#display").val(),
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			useAbsent: $("#useAbsent").val(),
			groupID: groupID
		});
	},
	/*searchDirGroupMember : function() {
		var searchValue = $("#directory-dirGroupMemberList-searchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length == 0) {
			alert($("#message_noneterm").val());
			searchValue.focus();
			return false;
		}
		$("#directory-dirGroupMemberList").load(CONTEXT + "/org.do", {
			acton: "searchDirGroupMember",
			display: $("#display").val(),
			selectMode: $("#selectMode").val(),
			openerType: $("#openerType").val(),
			useAbsent: $("#useAbsent").val(),
			searchType: $("#directory-dirGroupMemberList-searchType").val(),
			searchValue: searchValue.val(),
			groupID: $("#directory-dirGroupMemberList-searchBase").val()
		});
		return true;
	},*/
	toggleDirGroupMemberAll : function() {
		$("input[name='directory-dirGroupMemberList-check']").each(function() {
			if ($(this).is(":disabled")) {
				return;
			}
			
			$(this).attr("checked", $("#directory-dirGroupMemberList-checkAll").is(":checked"));
			
			var o = new Recipient($(this).val(),
					$("#directory-dirGroupMemberList-userName_" + $(this).val()).val(),
					$("#directory-dirGroupMemberList-deptID_" + $(this).val()).val(),
					$("#directory-dirGroupMemberList-deptName_" + $(this).val()).val());
			orgPopup.onSelect($(this).is(":checked"), o);
		});
		this.printRecipientList();
	},
	toggleDirGroupMember : function(obj) {
		if ($("#directory-dirGroupMemberList-checkAll").is(":checked") && !obj.is(":checked")) {
			$("#directory-dirGroupMemberList-checkAll").attr("checked", false);
		}
		if (($("#selectMode").val() == 1 || $("#isUserSingle").val() == "true") && obj.is(":checked")) {
			$("input[name='directory-dirGroupMemberList-check']").each(function() {
				$(this).attr("checked", false);
			});
			obj.attr("checked", true);
		}
		var o = new Recipient(obj.val(),
				$("#directory-dirGroupMemberList-userName_" + obj.val()).val(),
				$("#directory-dirGroupMemberList-deptID_" + obj.val()).val(),
				$("#directory-dirGroupMemberList-deptName_" + obj.val()).val());
		this.onSelect(obj.is(":checked"), o);
		this.printRecipientList();
	},
/* dirGroup : end */
	initPositionList : function() {
		$("#positionList").load(CONTEXT + "/org.do", {
			acton: "positionList",
			selectMode: $("#selectMode").val()
		});
	},
	togglePositionAll : function() {
		if ($("#checkPositionAll").is(":checked")) {
			$("input[name='checkPosition']").each(function() {
				if (!$(this).is(":disabled") && !$(this).is(":checked")) {
					$(this).attr("checked", true);
					var o = new Recipient(POS + $(this).val(), POS + $("#checkPosition_" + $(this).val()).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		} else {
			$("input[name='checkPosition']").each(function() {
				if (!$(this).is(":disabled") && $(this).is(":checked")) {
					$(this).attr("checked", false);
					var o = new Recipient(POS + $(this).val(), POS + $("#checkPosition_" + $(this).val()).val());
					orgPopup.onSelect($(this).is(":checked"), o);
				}
			});
		}
		this.printRecipientList();
	},
	togglePosition : function(obj) {
		if ($("#checkPositionAll").is(":checked") && !obj.is(":checked")) {
			$("#checkPositionAll").attr("checked", false);
		}
		if ($("#selectMode").val() == 1 && obj.is(":checked")) {
			$("input[name='checkPosition']").each(function() {
				$(this).attr("checked", false);
			});
			obj.attr("checked", true);
		}
		var o = new Recipient(POS + obj.val(), POS + $("#checkPosition_" + obj.val()).val());
		this.onSelect(obj.is(":checked"), o);
		this.printRecipientList();
	},
	isValidSearchName : function(name) {
		return !/.*[\~.`'"<>@!?&%$#;()\|\\\/\*\^+=:].*/.test(name);
	},
	onLoad : function(to, cc, bcc) {
		this.load(to, cc, bcc);
		this.printRecipientList();
		
		// select tab menu
		directory_orgPopup_switchMenu();
		// tabbar.js
		selectTabButton($("#recType").val());
		
		if ($("#checkbox").val() == "tree") {
			$("#orgTree").parent().width("100%");		// Firefox
			$("#contactTree").parent().width("100%");	// Firefox
			$("#groupTree").parent().width("100%");		// Firefox
			$("#directory-dirGroupTree").parent().width("100%");	// Firefox
			
			$("#orgTree").parent().css("float", "");
			$("#contactTree").parent().css("float", "");
			$("#groupTree").parent().css("float", "");
			$("#directory-dirGroupTree").parent().css("float", "");
			
			$("#userList").hide();
			$("#contactList").hide();
			$("#memberList").hide();
			$("#directory-dirGroupMemberList").hide();
			//$("#positionList").hide();
			resizePopup(400, $("#pop_wrap").height());
		} else { // "both" or "list"
			$("#orgTree").width(240);
			$("#contactTree").width(240);
			$("#groupTree").width(240);
			$("#directory-dirGroupTree").width(240);
			resizePopup(700, $("#pop_wrap").height());
		}
		
		if ($("#display").val().indexOf("subdept") < 0 || $("#checkbox").val() == "list") {
			$("input[name='subdept'][value='false']").attr("checked", true);
			$("input[name='subdept']").parent().hide();
			$("#orgTree").height("287px");
		} else {
			var list = orgPopup[($("#recType").val() || "to") + "List"];
			if ($("#selectMode").val() == "1" && list.size() == 1 && list.get(0).isDeptType()) {
				var deptType = parseType(list.get(0).uniqueID)[0];
				$("input[name='subdept'][value='" + (deptType == SDEPT) + "']").attr("checked", true);
			} else {
				$("input[name='subdept'][value='true']").attr("checked", true);
			}
		}
	},
	onOK : function() {
		if (opener.directory) {
			$(window).bind("beforeunload", function() {
				opener.directory.success(orgPopup.toList, orgPopup.ccList, orgPopup.bccList);
			});
		} else {
			alert("[object Error] opener.directory");
		}
		window.close();
	}
}

function resizePopup(width, height) {
	width = width || 700;
	height = height || document.body.offsetHeight + 5;
	
	if (window.outerHeight - window.innerHeight > 0) {
		height += window.outerHeight - window.innerHeight;
	} else {
		height += 90; // msie 7, 8
	}
	
	var left = screen.width / 2 - width  / 2;
	var top = screen.height / 2 - height / 2;
	try {
		window.moveTo(left, top);
		window.resizeTo(width, height);
	} catch (e) {
		// ignore
	}
}