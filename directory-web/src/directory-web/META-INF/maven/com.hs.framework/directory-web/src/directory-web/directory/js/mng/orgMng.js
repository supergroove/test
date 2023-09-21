var DIRECTORY_CONTEXT = "/directory-web";

//var USER	= '';
//var EMAIL	= '';
var DEPT	= '$';
var SDEPT	= '$+';
var GROUP	= '@';
var CONTACT	= '#';
var POS		= '~';
var EMP		= '^';

var GROUP_ORG = "G";

function orgMngDebg(msg){
	if (true) { // false -> TEST
		return;
	}
	if(window.console && window.console.debug){
		window.console.debug(msg);
	}else if(window.console && window.console.log){
		window.console.log(msg);
	}
}

var directory_orgErrorCode = {
	SUCCESS_SUCCESS				: 0,
	FAILURE_FAILURE				: 3000,
	UNKNOWN_FUNCTION_CODE		: 3001,
	
	DBMS_NO_DATA_FOUND			: 5,
	DBMS_BEGIN_TRANSACTION		: 6,
	DBMS_CLOSE_CONNECTION		: 7,
	DBMS_UPDATE_ERROR			: 8,
	DBMS_SELECT_ERROR			: 9,
	
	CANNOT_CREATE_FILE			: 1000,
	CANNOT_OPEN_FILE			: 1001,
	CANNOT_SEEK_DBF_FILE		: 1204,
	UNIQUE_KEY_ERROR			: 1213,
	INVALID_VALUE				: 1225,
	ALREADY_GIANED				: 3208,
	
	ORG_NOT_MATCH_PASSWORD			: 5001,
	ORG_NOT_MATCH_OLDANDNEWPASSWORD	: 5002,
	ORG_ERROR_PASSWORD_RULES		: 5003,
	ORG_ERROR_MAXFILESIZE			: 5004,
	ORG_NO_AUTHENTICATION			: 5005,
	ORG_NO_AUTHORIZATION			: 5006,
	ORG_ERROR_MAXUPLOADSIZE			: 5007,
	ORG_MATCH_PREVIOUS_PASSWORD		: 5009,
	
	ORG_LOGIN_NOT_MATCH_PASSWORD	: 6001,
	ORG_LOGIN_DUPLICATED_NAME 		: 6002,
	ORG_LOGIN_DUPLICATED_EMPCODE	: 6003,
	ORG_LOGIN_DUPLICATED_LOGINID	: 6004,
	ORG_LOGIN_NOTFOUND_NAME			: 6005,
	ORG_LOGIN_NOTFOUND_EMPCODE		: 6006,
	ORG_LOGIN_NOTFOUND_LOGINID		: 6007,
	ORG_LOGIN_LOCKED_USER			: 6008,
	ORG_LOGIN_EXPIRED_USER			: 6009,
	ORG_LOGIN_DUPLICATED_LOGIN		: 6010,
	ORG_LOGIN_CHANGE_PASSWORD		: 6011,
	ORG_LOGIN_NOTFOUND_USERID		: 6012,
	ORG_LOGIN_NOTALLOWED_IP			: 6013,
	ORG_LOGIN_NOTFOUND_OTHEROFFICE	: 6014,
    ORG_LOGIN_NOTFOUND_EMAIL		: 6015,
    ORG_LOGIN_DUPLICATED_EMAIL 		: 6016,
	
	ORG_GROUP_NAME_ALREADY_EXIST	: 9001,
	
	ORG_ABSENCE_EARLIER_ENDDATE		: 9101,
	ORG_ABSENCE_DUPLICATED_PERIOD	: 9102,
	ORG_ABSENCE_MSGRECIPIENT_SELF	: 9103,
	ORG_ABSENCE_ALTMAILUSER_SELF	: 9104,
	ORG_ABSENCE_ALTMAILUSER_ABS		: 9105,
	
	ORG_MNG_DATA_ALREADY_EXIST		: 10001,
	ORG_MNG_CODE_ALREADY_EXIST		: 10002,
	ORG_MNG_NAME_ALREADY_EXIST		: 10003,
	ORG_MNG_LOGIN_ID_ALREADY_EXIST	: 10004,
	ORG_MNG_NAME_ENG_ALREADY_EXIST	: 10005,
	ORG_MNG_ALIAS_ALREADY_EXIST		: 10006,
	ORG_MNG_EMAIL_ALREADY_EXIST		: 10007,
	
	ORG_MNG_MOVE_TO_SELF			: 10011,
	ORG_MNG_MOVE_TO_SELFSUB			: 10012,
	ORG_MNG_MOVE_TO_SAMEPOSITION	: 10013,
	ORG_MNG_MOVE_TO_DELETEDDEPT		: 10014,
	ORG_MNG_MOVE_NO_AUTH			: 10015,
	
	ORG_MNG_CANNOT_DELETE_IN_USE	: 10041,
	ORG_MNG_CANNOT_DELETE_ADMIN		: 10042,
	ORG_MNG_CANNOT_UPDATE_IN_USE	: 10043,
	
	ORG_MNG_BATCH_UNKNOWN_ORG_TYPE	: 10110,
	ORG_MNG_BATCH_UNKNOWN_OP_TYPE	: 10111,
	ORG_MNG_BATCH_NOTEXIST_ORG_TYPE	: 10112
};

var directory_history = {
	histories : [],
	/**
	 * history에 push되는 화면(viewDept, listUsers, viewUser)에서 back()호출 시,
	 * 자신의 history를 무시하기 위해 count값을 2로 설정해서 호출해야 한다.
	 */
	back : function(count) {
		count = count || 1;
		if (this.histories.length < count) {
			return;
		}
		var i = this.histories.length - count;
		var fun = this.histories[i].fun;
		var thisArg = this.histories[i].thisArg;
		var argsArray = this.histories[i].argsArray;
		this.histories.splice(i, count);
		
		fun.apply(thisArg, argsArray);
	},
	size : function() {
		return this.histories.length;
	},
	push : function(fun, thisArg, argsArray) {
		var equals = false;
		if (this.histories.length > 0) {
			var tmp = this.histories[this.histories.length - 1];
			if (tmp.fun === fun && tmp.thisArg === thisArg
					&& tmp.argsArray.length == argsArray.length) {
				equals = true;
				for (var i = 0; i < argsArray.length; i++) {
					if (tmp.argsArray[i] !== argsArray[i]) {
						equals = false;
						break;
					}
				}
			}
		}
		if (!equals) {
			this.histories.push({
				fun:		fun,
				thisArg:	thisArg,
				argsArray:	argsArray
			});
		}
	},
	remove : function() {
		if (this.histories.length < 1) {
			return;
		}
		var i = this.histories.length - 1;
		this.histories.splice(i, 1);
	},
	removeAll : function() {
		this.histories = [];
	}
};

var directory_orgMng = {
	getBaseDeptID: function() {
		var baseDeptID = null;
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: { acton: "getBaseDeptID" },
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
						alert($("#directory-notAuthorizedUser").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					baseDeptID = result.deptID;
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
		return baseDeptID;
	},
	getCurrentDeptID: function() {
		var tree = $("#directory-deptTree").dynatree("getTree");
		return tree.getActiveNode() != null ? tree.getActiveNode().data.key : $("#directory-baseDept").val();
	},
	createDeptTree : function() {
		if ($("#directory-deptTree").length == 0) {
			return;
		}
		$("#directory-deptTree").directorytree({
			idPrefix: "dept",
			checkbox: false,
			selectMode: 1,
			checkMode: "list",
			openerType: "",
			onActivate: function(dtnode) {
				var deptID = dtnode.data.key;
				var deptName = dtnode.data.title;
				if (/<img/.test(deptName)) {
					deptName = deptName.substring(0, deptName.indexOf("<img")); // remove <img> tag
				}
				
				if ($("#directory-moveDept-targetDeptID").length > 0) {
					$("#directory-moveDept-targetDeptID").val(deptID);
					$("#directory-moveDept-targetDeptName").val(deptName);
				} else if ($("#directory-moveUsers-targetDeptID").length > 0) {
					$("#directory-moveUsers-targetDeptID").val(deptID);
					$("#directory-moveUsers-targetDeptName").val(deptName);
				} else if ("dept" == directory_orgMng_menuType) {
					directory_orgMng.viewDept(deptID);
				} else if ("user" == directory_orgMng_menuType) {
					directory_orgMng.listUsers(deptID);
				}
			},
			onLazyRead: function(dtnode) {
				directory_orgMng.expandDeptTree(dtnode);
			},
			init: function() {
				directory_orgMng.initDeptTree($("#directory-baseDept").val(), true);
			}
		});
	},
	initDeptTree : function(baseDept, isActivate, isExpandAll) {
		$("#directory-deptTree").dynatree("getRoot").removeChildren();
		$("#directory-deptTree").dynatree("getRoot").appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: { acton: "initDeptTree", baseDept: baseDept, isExpandAll: isExpandAll },
			success: function(dtnode) {
				directory_orgMng.callbackDept(dtnode);
				
				var actnode = dtnode.tree.getNodeByKey(baseDept);
				if (actnode) {
					actnode.focus();
					// jquery.dynatree.js 의 _getInnerHtml 함수에서 <a> 태그의 href를 제거했기 때문에, focus()를 호출해도 스크롤이 이동하지 않는다.
					// 따라서, 스크롤을 이동시키기 위해 actnode의 위치를 scrollTop으로 설정해야 한다.
					for (var i = 0; i < dtnode.childList.length; i++) {
						if (dtnode.childList[i].data.isFolder) {
							var tmp = 20; // offset top 값으로 위치를 구하기 때문에, actnode의 높이를 더해야 부서명이 보인다.
							tmp += $(actnode.span).offset().top - $(dtnode.childList[i].span).offset().top; // 트리div 내에서의 actnode 위치
							tmp -= document.getElementById("directory-deptTree").clientHeight; // 트리div의 스크롤 안쪽 높이
							$("#directory-deptTree").scrollTop(tmp);
							break;
						}
					}
				}
				if (isActivate) {
					if (actnode && !actnode.data.noLink) {
						actnode.activate();
					} else {
						baseDept = directory_orgMng.getBaseDeptID();
						if (baseDept) {
							$("#directory-baseDept").val(baseDept);
							directory_orgMng.initDeptTree(baseDept, true);
						}
					}
				}
			}
		});
	},
	closeAllDeptTree : function() {
		$("#directory-deptTree").dynatree("getRoot").visit(function(node) {
			//if (node.hasChildren()) node.expand(false);
			node.expand(false);
		});
	},
	expandDeptTree : function(dtnode) {
		dtnode.appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: { acton: "expandDeptTree", deptID: dtnode.data.key },
			success: function(dtnode) {
				directory_orgMng.callbackDept(dtnode);
			}
		});
	},
	searchDeptTree : function() {
		var searchValue = $("#directory-deptSearchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length == 0) {
			alert($("#directory-search-noneTerm").val());
			searchValue.focus();
			return false;
		}
		if (searchValue.val().length < 2) {
			alert($("#directory-search-minLength").val());
			searchValue.focus();
			return false;
		}
		if (!this.isValidCharacter(searchValue.val())) {
			alert($("#directory-search-invalidValue").val());
			searchValue.focus();
			return false;
		}
		$("#directory-deptTree").dynatree("getRoot").removeChildren();
		$("#directory-deptTree").dynatree("getRoot").appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: {
				acton: "searchDeptTree",
				searchValue: searchValue.val()
			},
			success: function(dtnode) {
				directory_orgMng.callbackDept(dtnode);
			}
		});
		return true;
	},
	callbackDept : function(dtnode) {
		dtnode.visit(function(node) {
			if (node.data.deptStatus == "4") {
				node.data.title = node.data.title + "<img src='" + DIRECTORY_CONTEXT + "/directory/images/OS4.GIF' />"; // add <img> tag
				node.render();
			}
			if (node.hasChildren()) node.expand(true);
		});
	},
	viewDept : function(deptID) {
		directory_history.push(this.viewDept, this, [deptID]); // history push
		directory_orgMng_switchMenu("dept");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewDept",
			deptID: deptID
		}, function() {
			if (typeof(directory_viewDept_onLoad) != "undefined") {
				directory_viewDept_onLoad();
				
				var tree = $("#directory-deptTree").dynatree("getTree");
				if (tree && tree.getNodeByKey) {
					var actnode = tree.getNodeByKey(deptID);
					if (actnode) actnode._activate(true, false); // not call onActivate()
				}
			}
		});
	},
	viewAddDept : function(targetDeptID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddDept",
			targetDeptID: targetDeptID
		}, function() {
			if (typeof(directory_addDept_onLoad) != "undefined") {
				directory_addDept_onLoad();
			}
		});
	},
	addDept : function() {
		if (!this.addDept_validate()) {
			return;
		}
		if (!confirm($("#directory-addDept-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "addDept",
			deptName: $.trim($("#directory-addDept-deptName").val()),
			deptNameEng: $.trim($("#directory-addDept-deptNameEng").val()) || "",
			deptCode: $.trim($("#directory-addDept-deptCode").val()),
			email: $.trim($("#directory-addDept-email").val()),
			targetDeptID: $("#directory-addDept-targetDeptID").val(),
			movePosition: $("#directory-addDept-movePosition").val()
		};
		$('input[id^="directory-addDept-ownerID-"]').each(function() {
			if ($(this).attr("type") == 'checkbox' && !$(this).is(":checked")) return;
			var authCode = $(this).attr("id").substring("directory-addDept-ownerID-".length);
			orgMngDebg("addDept id="+$(this).attr("id")+", value="+$(this).val()+",authCode="+authCode);
			data["ownerID_"+authCode]=$(this).val();
		});
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
						alert($("#directory-addDept-noAuthError").val());
						$("#directory-addDept-movePosition").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addDept-dupDeptCode").val().replace("{0}", $.trim($("#directory-addDept-deptCode").val())));
						$("#directory-addDept-deptCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addDept-dupDeptName").val().replace("{0}", $.trim($("#directory-addDept-deptName").val())));
						$("#directory-addDept-deptName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-addDept-dupDeptName").val().replace("{0}", $.trim($("#directory-addDept-deptNameEng").val())));
						$("#directory-addDept-deptNameEng").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_EMAIL_ALREADY_EXIST:
						alert($("#directory-addDept-dupEmail").val().replace("{0}", $.trim($("#directory-addDept-email").val())));
						$("#directory-addDept-email").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addDept-deptAdded").val());
					
					if ($("#directory-backToDeptTree").is(":visible")) {
						directory_orgMng.viewDept(result.deptID); // Search state, the deptTree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDeptTree(result.deptID, true); // deptTree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addDept_validate : function() {
		// check deptName
		var deptName = $("#directory-addDept-deptName");
		if (this.stringByteSize(deptName.val()) > 200) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptName").val()).replace("{1}", 66).replace("{2}", 200));
			deptName.focus();
			return false;
		}
		if ($.trim(deptName.val()).length == 0) {
			alert($("#directory-addDept-inputDeptName").val());
			deptName.val("");
			deptName.focus();
			return false;
		}
		if (!this.isValidCharacter(deptName.val(), 2)) {
			alert($("#directory-addDept-invalidCharacterError").val().replace("{0}", $("#directory-deptName").val()));
			deptName.focus();
			return false;
		}
		
		// check deptNameEng
		var deptNameEng = $("#directory-addDept-deptNameEng");
		if (deptNameEng.val() !== undefined) {
			if (this.stringByteSize(deptNameEng.val()) > 200) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptNameEng").val()).replace("{1}", 66).replace("{2}", 200));
				deptNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(deptNameEng.val(), 2)) {
				alert($("#directory-addDept-invalidCharacterError").val().replace("{0}", $("#directory-deptNameEng").val()));
				deptNameEng.focus();
				return false;
			}
		}
		
		// check deptCode
		var deptCode = $("#directory-addDept-deptCode");
		if (this.stringByteSize(deptCode.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptCode").val()).replace("{1}", 6).replace("{2}", 20));
			deptCode.focus();
			return false;
		}
		
		// check email
		var email = $("#directory-addDept-email");
		if (this.stringByteSize(email.val()) > 128) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-email").val()).replace("{1}", 42).replace("{2}", 128));
			email.focus();
			return false;
		}
		if ($.trim(email.val()).length > 0 && !this.isValidEmail(email.val())) {
			alert($("#directory-addDept-invalidEmailError").val());
			email.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDept : function(deptID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateDept",
			deptID: deptID
		});
	},
	updateDept : function(deptID) {
		if (!this.updateDept_validate()) {
			return;
		}
		if (!confirm($("#directory-updateDept-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "updateDept",
			deptID: deptID,
			deptName: $.trim($("#directory-updateDept-deptName").val()),
			deptNameEng: $.trim($("#directory-updateDept-deptNameEng").val()) || "",
			deptCode: $.trim($("#directory-updateDept-deptCode").val()),
			deptStatus: $("#directory-updateDept-deptStatus").val(),
			email: $.trim($("#directory-updateDept-email").val())
		};
		$('input[id^="directory-updateDept-ownerID-"]').each(function() {
			if ($(this).attr("type") == 'checkbox' && !$(this).is(":checked")) return;
			var authCode = $(this).attr("id").substring("directory-updateDept-ownerID-".length);
			orgMngDebg("updateDept id="+$(this).attr("id")+", value="+$(this).val()+",authCode="+authCode);
			data["ownerID_"+authCode]=$(this).val();
		});
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-updateDept-dupDeptCode").val().replace("{0}", $.trim($("#directory-updateDept-deptCode").val())));
						$("#directory-updateDept-deptCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateDept-dupDeptName").val().replace("{0}", $.trim($("#directory-updateDept-deptName").val())));
						$("#directory-updateDept-deptName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-updateDept-dupDeptName").val().replace("{0}", $.trim($("#directory-updateDept-deptNameEng").val())));
						$("#directory-updateDept-deptNameEng").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_EMAIL_ALREADY_EXIST:
						alert($("#directory-updateDept-dupEmail").val().replace("{0}", $.trim($("#directory-updateDept-email").val())));
						$("#directory-updateDept-email").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDept-deptUpdated").val());
					
					if ($("#directory-backToDeptTree").is(":visible")) {
						directory_orgMng.viewDept(deptID); // Search state, the deptTree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDeptTree(deptID, true); // deptTree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateDept_validate : function() {
		// check deptName
		var deptName = $("#directory-updateDept-deptName");
		if (this.stringByteSize(deptName.val()) > 200) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptName").val()).replace("{1}", 66).replace("{2}", 200));
			deptName.focus();
			return false;
		}
		if ($.trim(deptName.val()).length == 0) {
			alert($("#directory-updateDept-inputDeptName").val());
			deptName.val("");
			deptName.focus();
			return false;
		}
		if (!this.isValidCharacter(deptName.val(), 2)) {
			alert($("#directory-updateDept-invalidCharacterError").val().replace("{0}", $("#directory-deptName").val()));
			deptName.focus();
			return false;
		}
		
		// check deptNameEng
		var deptNameEng = $("#directory-updateDept-deptNameEng");
		if (deptNameEng.val() !== undefined) {
			if (this.stringByteSize(deptNameEng.val()) > 200) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptNameEng").val()).replace("{1}", 66).replace("{2}", 200));
				deptNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(deptNameEng.val(), 2)) {
				alert($("#directory-updateDept-invalidCharacterError").val().replace("{0}", $("#directory-deptNameEng").val()));
				deptNameEng.focus();
				return false;
			}
		}
		
		// check deptCode
		var deptCode = $("#directory-updateDept-deptCode");
		if (this.stringByteSize(deptCode.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-deptCode").val()).replace("{1}", 6).replace("{2}", 20));
			deptCode.focus();
			return false;
		}
		
		// check email
		var email = $("#directory-updateDept-email");
		if (this.stringByteSize(email.val()) > 128) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-email").val()).replace("{1}", 42).replace("{2}", 128));
			email.focus();
			return false;
		}
		if ($.trim(email.val()).length > 0 && !this.isValidEmail(email.val())) {
			alert($("#directory-updateDept-invalidEmailError").val());
			email.focus();
			return false;
		}
		
		return true;
	},
	viewMoveDept : function(deptID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewMoveDept",
			deptID: deptID
		});
	},
	moveDept : function(deptID, deptName, deptNameEng) {
		var targetDeptID = $("#directory-moveDept-targetDeptID");
		
		if (targetDeptID.val().length == 0) {
			alert($("#directory-moveDept-selectTargetDept").val());
			return;
		}
		if (targetDeptID.val() == deptID) {
			alert($("#directory-moveDept-toSelfError").val());
			return;
		}
		if (!confirm($("#directory-moveDept-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "moveDept",
				deptID: deptID,
				targetDeptID: targetDeptID.val(),
				movePosition: $("#directory-moveDept-movePosition").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_SELF:
						alert($("#directory-moveDept-toSelfError").val());
						break;
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_SELFSUB:
						alert($("#directory-moveDept-toSelfSubError").val());
						break;
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_SAMEPOSITION:
						alert($("#directory-moveDept-toSamePositionError").val());
						break;
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_DELETEDDEPT:
						alert($("#directory-moveDept-toDeletedDeptError").val());
						break;
					case directory_orgErrorCode.ORG_MNG_MOVE_NO_AUTH:
						alert($("#directory-moveDept-noAuthError").val());
						$("#directory-moveDept-movePosition").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-moveDept-dupDeptName").val().replace("{0}", deptName));
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-moveDept-dupDeptName").val().replace("{0}", deptNameEng));
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-moveDept-deptMoved").val());
					
					if ($("#directory-backToDeptTree").is(":visible")) {
						directory_orgMng.viewDept(deptID); // Search state, the deptTree does not reload.
					} else {
						$("#directory-workspace").empty(); // remove directory-moveDept-targetDeptID
						directory_orgMng.initDeptTree(deptID, true); // deptTree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteDept : function(deptID) {
		if (!confirm($("#directory-deleteDept-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteDept",
				deptID: deptID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteDept-deptWithChildError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteDept-deptDeleted").val());
					directory_history.remove(); // history remove
					
					if ($("#directory-backToDeptTree").is(":visible")) {
						directory_orgMng.viewDept(result.deptID); // Search state, the deptTree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDeptTree(result.deptID, true); // deptTree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	repairDept : function(deptID) {
		if (!confirm($("#directory-repairDept-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "repairDept",
				deptID: deptID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					alert(result.errorMessage);
				} else {
					alert($("#directory-repairDept-repaired").val());
					
					if ($("#directory-backToDeptTree").is(":visible")) {
						directory_orgMng.viewDept(deptID); // Search state, the deptTree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDeptTree(deptID, true); // deptTree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listUsers : function(deptID, orderField, orderType) {
		directory_history.push(this.listUsers, this, [deptID, orderField, orderType]); // history push
		directory_orgMng_switchMenu("user");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listUsers",
			display: $("#directory-display").val(),
			useAbsent: $("#directory-useAbsent").val(),
			deptID: deptID,
			orderField: orderField,
			orderType: orderType
		}, function() {
			if (typeof(directory_listUsers_onLoad) != "undefined") {
				directory_listUsers_onLoad();
				
				var tree = $("#directory-deptTree").dynatree("getTree");
				if (tree && tree.getNodeByKey) {
					var actnode = tree.getNodeByKey(deptID);
					if (actnode) actnode._activate(true, false); // not call onActivate()
				}
			}
		});
	},
	viewUser : function(userID) {
		directory_history.push(this.viewUser, this, [userID]); // history push
		directory_orgMng_switchMenu("user");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUser",
			userID: userID
		}, function() {
			if (typeof(directory_viewUser_onLoad) != "undefined") {
				directory_viewUser_onLoad();
			}
		});
	},
	viewAddUser : function(deptID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddUser",
			deptID: deptID
		}, function() {
			if (typeof(directory_addUser_onLoad) != "undefined") {
				directory_addUser_onLoad();
			}
		});
	},
	addUser : function(deptID) {
		if (!this.addUser_validate()) {
			return;
		}
		if (!confirm($("#directory-addUser-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "addUser",
			deptID: deptID,
			userName: $.trim($("#directory-addUser-userName").val()),
			userNameEng: $.trim($("#directory-addUser-userNameEng").val()) || "",
			empCode: $.trim($("#directory-addUser-empCode").val()),
			positionID: $("#directory-addUser-positionID").val(),
			rankID: $("#directory-addUser-rankID").val() || "",
			dutyID: $("#directory-addUser-dutyID").val() || "",
			secLevel: $.trim($("#directory-addUser-secLevel").val()),
			loginID: $.trim($("#directory-addUser-loginID").val()),
			loginPassword: $("#directory-addUser-loginPassword").val(),
			loginLock: $("input[name='directory-addUser-loginLock']:checked").val(),
			expiryDate: $.trim($("#directory-addUser-expiryDate").val()),
			email: $.trim($("#directory-addUser-email").val()),
			phone: $.trim($("#directory-addUser-phone").val()),
			mobilePhone: $.trim($("#directory-addUser-mobilePhone").val()),
			fax: $.trim($("#directory-addUser-fax").val()),
			clientIPAddr: $.trim($("#directory-addUser-clientIPAddr").val()),
			phoneRuleID: $.trim($("#directory-addUser-phoneRuleID").val()) || "",
			extPhone: $.trim($("#directory-addUser-extPhone").val()) || "",
			extPhoneHead: $.trim($("#directory-addUser-extPhoneHead").val()) || "",
			extPhoneExch: $.trim($("#directory-addUser-extPhoneExch").val()) || "",
			phyPhone: $.trim($("#directory-addUser-phyPhone").val()) || "",
			fwdPhone: $.trim($("#directory-addUser-fwdPhone").val()) || "",
			capacity: $.trim($("#directory-addUser-capacity").val()) || "",
			cloudfolderCapacity: $.trim($("#directory-addUser-cloudfolderCapacity").val()) || ""
		};
		$('input[id^="directory-addUser-relID-"]').each(function() {
			if($(this).attr("type") == 'checkbox' && !$(this).is(":checked")) return;
			var authCode = $(this).attr("id").substring("directory-addUser-relID-".length);
			orgMngDebg("addUser id="+$(this).attr("id")+", value="+$(this).val()+",authCode="+authCode);
			data["relID_"+authCode]=$(this).val();
		});
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addUser-dupEmpCode").val().replace("{0}", $.trim($("#directory-addUser-empCode").val())));
						$("#directory-addUser-empCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_LOGIN_ID_ALREADY_EXIST:
						alert($("#directory-addUser-dupLoginID").val().replace("{0}", $.trim($("#directory-addUser-loginID").val())));
						$("#directory-addUser-loginID").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_EMAIL_ALREADY_EXIST:
						alert($("#directory-addUser-dupEmail").val().replace("{0}", $.trim($("#directory-addUser-email").val())));
						$("#directory-addUser-email").focus();
						break;
					case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
						alert($("#directory-addUser-notAuthorizedUser").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addUser-userAdded").val());
					directory_orgMng.listUsers(deptID); // listUsers reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addUser_validate : function() {
		// check userName
		var userName = $("#directory-addUser-userName");
		if (this.stringByteSize(userName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-userName").val()).replace("{1}", 40).replace("{2}", 120));
			userName.focus();
			return false;
		}
		if ($.trim(userName.val()).length == 0) {
			alert($("#directory-addUser-inputUserName").val());
			userName.val("");
			userName.focus();
			return false;
		}
		if($("#directory-addUser-allowPeriodInUsername").val() == "true"){
			if (!this.isValidCharacter(userName.val(), 3)) {
				alert($("#directory-addUser-includePeriodInvalidCharacterError").val().replace("{0}", $("#directory-userName").val()));
				userName.focus();
				return false;
			}
		}else{
			if (!this.isValidCharacter(userName.val())) {
				alert($("#directory-addUser-invalidCharacterError").val().replace("{0}", $("#directory-userName").val()));
				userName.focus();
				return false;
			}
		}
		
		// check userNameEng
		var userNameEng = $("#directory-addUser-userNameEng");
		if (userNameEng.val() !== undefined) {
			if (this.stringByteSize(userNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-userNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				userNameEng.focus();
				return false;
			}
			if($("#directory-addUser-allowPeriodInUsername").val() == "true"){
				if (!this.isValidCharacter(userNameEng.val(), 3)) {
					alert($("#directory-addUser-includePeriodInvalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userNameEng.focus();
					return false;
				}
			}else{
				if (!this.isValidCharacter(userNameEng.val())) {
					alert($("#directory-addUser-invalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userNameEng.focus();
					return false;
				}
			}
		}
		
		// check empCode
		var empCode = $("#directory-addUser-empCode");
		if (this.stringByteSize(empCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-empCode").val()).replace("{1}", 13).replace("{2}", 40));
			empCode.focus();
			return false;
		}
		
		// check positionID
		var positionID = $("#directory-addUser-positionID");
		if (positionID.val().length == 0) {
			alert($("#directory-addUser-selectPosition").val());
			positionID.focus();
			return false;
		}
		
		// check secLevel
		var secLevel = $("#directory-addUser-secLevel");
		if (!this.isValidNumber($.trim(secLevel.val())) || $.trim(secLevel.val()) < 0 || $.trim(secLevel.val()) > 99) {
			alert($("#directory-addUser-invalidSecLevel").val());
			secLevel.focus();
			return false;
		}
		
		// check loginID
		var loginID = $("#directory-addUser-loginID");
		if (this.stringByteSize(loginID.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-loginID").val()).replace("{1}", 6).replace("{2}", 20));
			loginID.focus();
			return false;
		}
		
		// check loginPassword
		var loginPassword = $("#directory-addUser-loginPassword");
		var loginPasswordConfirm = $("#directory-addUser-loginPasswordConfirm");
		if ($("input[name='directory-addUser-loginPassword-assign']:checked").val() == "1") {
			if (this.stringByteSize(loginPassword.val()) > 15) {
				alert($("#directory-maxLength2").val().replace("{0}", $("#directory-loginPassword").val()).replace("{1}", 15));
				loginPassword.focus();
				return false;
			}
			if (loginPassword.val().length == 0) {
				alert($("#directory-addUser-inputLoginPassword").val());
				loginPassword.focus();
				return false;
			}
			if (loginPasswordConfirm.val().length == 0) {
				alert($("#directory-addUser-inputLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
			if (loginPassword.val() != loginPasswordConfirm.val()) {
				alert($("#directory-addUser-incorrectLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
		} else {
			loginPassword.val("");
			loginPasswordConfirm.val("");
		}
		
		// check expiryDate
		var expiryDate = $("#directory-addUser-expiryDate");
		if ($.trim(expiryDate.val()).length > 0 && !this.isValidDate($.trim(expiryDate.val()))) {
			alert($("#directory-addUser-invalidExpiryDate").val());
			expiryDate.focus();
			return false;
		}
		
		// check email
		var email = $("#directory-addUser-email");
		if (this.stringByteSize(email.val()) > 128) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-email").val()).replace("{1}", 42).replace("{2}", 128));
			email.focus();
			return false;
		}
		if ($("#directory-addUser-isEmailRequired").val() == "true"
				&& $.trim(email.val()).length == 0) {
			alert($("#directory-addUser-invalidEmailError").val());
			email.val("");
			email.focus();
			return false;
		}
		if ($.trim(email.val()).length > 0 && !this.isValidEmail(email.val())) {
			alert($("#directory-addUser-invalidEmailError").val());
			email.focus();
			return false;
		}
		
		// check phone
		var phone = $("#directory-addUser-phone");
		if (this.stringByteSize(phone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-phone").val()).replace("{1}", 13).replace("{2}", 40));
			phone.focus();
			return false;
		}
		if (!this.isValidCharacter(phone.val(), 1)) {
			alert($("#directory-addUser-invalidCharacterError-1").val().replace("{0}", $("#directory-phone").val()));
			phone.focus();
			return false;
		}
		
		// check mobilePhone
		var mobilePhone = $("#directory-addUser-mobilePhone");
		if (this.stringByteSize(mobilePhone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-mobilePhone").val()).replace("{1}", 13).replace("{2}", 40));
			mobilePhone.focus();
			return false;
		}
		if (!this.isValidCharacter(mobilePhone.val(), 1)) {
			alert($("#directory-addUser-invalidCharacterError-1").val().replace("{0}", $("#directory-mobilePhone").val()));
			mobilePhone.focus();
			return false;
		}
		
		// check fax
		var fax = $("#directory-addUser-fax");
		if (this.stringByteSize(fax.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-fax").val()).replace("{1}", 13).replace("{2}", 40));
			fax.focus();
			return false;
		}
		if (!this.isValidCharacter(fax.val(), 1)) {
			alert($("#directory-addUser-invalidCharacterError-1").val().replace("{0}", $("#directory-fax").val()));
			fax.focus();
			return false;
		}
		
		// check clientIPAddr
		var clientIPAddr = $("#directory-addUser-clientIPAddr");
		if (this.stringByteSize(clientIPAddr.val()) > 64) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-clientIPAddr").val()).replace("{1}", 21).replace("{2}", 64));
			clientIPAddr.focus();
			return false;
		}
		if (!this.isValidCharacter(clientIPAddr.val(), 1)) {
			alert($("#directory-addUser-invalidCharacterError-1").val().replace("{0}", $("#directory-clientIPAddr").val()));
			clientIPAddr.focus();
			return false;
		}
		
		// check phoneRuleID
		var phoneRuleID = $("#directory-addUser-phoneRuleID");
		if (phoneRuleID.val() !== undefined) {
			if (!this.isValidNumber($.trim(phoneRuleID.val())) || $.trim(phoneRuleID.val()) < 0 || $.trim(phoneRuleID.val()) > 9) {
				alert($("#directory-addUser-invalidPhoneRuleID").val());
				phoneRuleID.focus();
				return false;
			}
		}
		
		// check capacity
		var capacity = $("#directory-addUser-capacity");
		if (capacity.val() !== undefined) {
			if (!this.isValidNumber($.trim(capacity.val())) || $.trim(capacity.val()) < 0 || $.trim(capacity.val()) > 99999) {
				alert($("#directory-addUser-invalidMailCapacity").val());
				capacity.focus();
				return false;
			}
		}
		
		var cloudfolderCapacity = $("#directory-addUser-cloudfolderCapacity");
		if (cloudfolderCapacity.val() !== undefined) {
			if (!this.isValidNumber($.trim(cloudfolderCapacity.val())) || $.trim(cloudfolderCapacity.val()) < 0 || $.trim(cloudfolderCapacity.val()) > 99999) {
				alert($("#directory-addUser-invalidCloudfolderCapacity").val());
				capacity.focus();
				return false;
			}
		}
		
		return true;
	},
	viewUpdateUser : function(userID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateUser",
			userID: userID
		}, function() {
			if (typeof(directory_updateUser_onLoad) != "undefined") {
				directory_updateUser_onLoad();
			}
		});
	},
	updateUser : function(userID) {
		if (!this.updateUser_validate()) {
			return;
		}
		if (!confirm($("#directory-updateUser-confirm").val())) {
			return;
		}
		var data = {
			acton: "updateUser",
			userID: userID,
			userName: $.trim($("#directory-updateUser-userName").val()),
			userNameEng: $.trim($("#directory-updateUser-userNameEng").val()) || "",
			empCode: $.trim($("#directory-updateUser-empCode").val()),
			positionID: $("#directory-updateUser-positionID").val(),
			rankID: $("#directory-updateUser-rankID").val() || "",
			dutyID: $("#directory-updateUser-dutyID").val() || "",
			secLevel: $.trim($("#directory-updateUser-secLevel").val()),
			loginID: $.trim($("#directory-updateUser-loginID").val()),
			loginPassword: $("#directory-updateUser-loginPassword").val(),
			loginLock: $("input[name='directory-updateUser-loginLock']:checked").val(),
			expiryDate: $.trim($("#directory-updateUser-expiryDate").val()),
			userStatus: $("#directory-updateUser-userStatus").val(),
			email: $.trim($("#directory-updateUser-email").val()),
			phone: $.trim($("#directory-updateUser-phone").val()),
			mobilePhone: $.trim($("#directory-updateUser-mobilePhone").val()),
			fax: $.trim($("#directory-updateUser-fax").val()),
			clientIPAddr: $.trim($("#directory-updateUser-clientIPAddr").val()) || "",
			phoneRuleID: $.trim($("#directory-updateUser-phoneRuleID").val()) || "",
			extPhone: $.trim($("#directory-updateUser-extPhone").val()) || "",
			extPhoneHead: $.trim($("#directory-updateUser-extPhoneHead").val()) || "",
			extPhoneExch: $.trim($("#directory-updateUser-extPhoneExch").val()) || "",
			phyPhone: $.trim($("#directory-updateUser-phyPhone").val()) || "",
			fwdPhone: $.trim($("#directory-updateUser-fwdPhone").val()) || "",
			capacity: $.trim($("#directory-updateUser-capacity").val()) || "",
			cloudfolderCapacity: $.trim($("#directory-updateUser-cloudfolderCapacity").val()) || ""
		};
		$('input[id^="directory-updateUser-relID-"]').each(function() {
			if($(this).attr("type") == 'checkbox' && !$(this).is(":checked")) return;
			var authCode = $(this).attr("id").substring("directory-updateUser-relID-".length);
			orgMngDebg("addUser id="+$(this).attr("id")+", value="+$(this).val()+",authCode="+authCode);
			data["relID_"+authCode]=$(this).val();
		});
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-updateUser-dupEmpCode").val().replace("{0}", $.trim($("#directory-updateUser-empCode").val())));
						$("#directory-updateUser-empCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_LOGIN_ID_ALREADY_EXIST:
						alert($("#directory-updateUser-dupLoginID").val().replace("{0}", $.trim($("#directory-updateUser-loginID").val())));
						$("#directory-updateUser-loginID").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_EMAIL_ALREADY_EXIST:
						alert($("#directory-updateUser-dupEmail").val().replace("{0}", $.trim($("#directory-updateUser-email").val())));
						$("#directory-updateUser-email").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_ADMIN:
						alert($("#directory-updateUser-deleteAdminError").val());
						break;
					case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
						alert($("#directory-updateUser-notAuthorizedUser").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateUser-userUpdated").val());
					directory_orgMng.viewUser(userID); // viewUser reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateUser_validate : function() {
		// check userName
		var userName = $("#directory-updateUser-userName");
		if (this.stringByteSize(userName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-userName").val()).replace("{1}", 40).replace("{2}", 120));
			userName.focus();
			return false;
		}
		if ($.trim(userName.val()).length == 0) {
			alert($("#directory-updateUser-inputUserName").val());
			userName.val("");
			userName.focus();
			return false;
		}
		if($("#directory-updateUser-allowPeriodInUsername").val() == 'true'){
			if (!this.isValidCharacter(userName.val(), 3)) {
				alert($("#directory-updateUser-includePeriodInvalidCharacterError").val().replace("{0}", $("#directory-userName").val()));
				userName.focus();
				return false;
			}
		}else{
			if (!this.isValidCharacter(userName.val())) {
				alert($("#directory-updateUser-invalidCharacterError").val().replace("{0}", $("#directory-userName").val()));
				userName.focus();
				return false;
			}
		}
		
		// check userNameEng
		var userNameEng = $("#directory-updateUser-userNameEng");
		if (userNameEng.val() !== undefined) {
			if (this.stringByteSize(userNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-userNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				userNameEng.focus();
				return false;
			}
			if($("#directory-updateUser-allowPeriodInUsername").val() == 'true'){
				if (!this.isValidCharacter(userNameEng.val(), 3)) {
					alert($("#directory-updateUser-includePeriodInvalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userNameEng.focus();
					return false;
				}
			}else{
				if (!this.isValidCharacter(userNameEng.val())) {
					alert($("#directory-updateUser-invalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userNameEng.focus();
					return false;
				}
			}
		}
		
		// check empCode
		var empCode = $("#directory-updateUser-empCode");
		if (this.stringByteSize(empCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-empCode").val()).replace("{1}", 13).replace("{2}", 40));
			empCode.focus();
			return false;
		}
		
		// check positionID
		var positionID = $("#directory-updateUser-positionID");
		if (positionID.val().length == 0) {
			alert($("#directory-updateUser-selectPosition").val());
			positionID.focus();
			return false;
		}
		
		// check secLevel
		var secLevel = $("#directory-updateUser-secLevel");
		if (!this.isValidNumber($.trim(secLevel.val())) || $.trim(secLevel.val()) < 0 || $.trim(secLevel.val()) > 99) {
			alert($("#directory-updateUser-invalidSecLevel").val());
			secLevel.focus();
			return false;
		}
		
		// check loginID
		var loginID = $("#directory-updateUser-loginID");
		if (this.stringByteSize(loginID.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-loginID").val()).replace("{1}", 6).replace("{2}", 20));
			loginID.focus();
			return false;
		}
		
		// check loginPassword
		var loginPassword = $("#directory-updateUser-loginPassword");
		var loginPasswordConfirm = $("#directory-updateUser-loginPasswordConfirm");
		if ($("input[name='directory-updateUser-loginPassword-update']:checked").val() == "1") {
			if (this.stringByteSize(loginPassword.val()) > 15) {
				alert($("#directory-maxLength2").val().replace("{0}", $("#directory-loginPassword").val()).replace("{1}", 15));
				loginPassword.focus();
				return false;
			}
			if (loginPassword.val().length == 0) {
				alert($("#directory-updateUser-inputLoginPassword").val());
				loginPassword.focus();
				return false;
			}
			if (loginPasswordConfirm.val().length == 0) {
				alert($("#directory-updateUser-inputLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
			if (loginPassword.val() != loginPasswordConfirm.val()) {
				alert($("#directory-updateUser-incorrectLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
		} else {
			loginPassword.val("");
			loginPasswordConfirm.val("");
		}
		
		// check expiryDate
		var expiryDate = $("#directory-updateUser-expiryDate");
		if ($.trim(expiryDate.val()).length > 0 && !this.isValidDate($.trim(expiryDate.val()))) {
			alert($("#directory-updateUser-invalidExpiryDate").val());
			expiryDate.focus();
			return false;
		}
		
		// check email
		var email = $("#directory-updateUser-email");
		if (this.stringByteSize(email.val()) > 128) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-email").val()).replace("{1}", 42).replace("{2}", 128));
			email.focus();
			return false;
		}
		if ($("#directory-updateUser-isEmailRequired").val() == "true"
				&& $.trim(email.val()).length == 0) {
			alert($("#directory-updateUser-invalidEmailError").val());
			email.val("");
			email.focus();
			return false;
		}
		if ($.trim(email.val()).length > 0 && !this.isValidEmail(email.val())) {
			alert($("#directory-updateUser-invalidEmailError").val());
			email.focus();
			return false;
		}
		
		// check phone
		var phone = $("#directory-updateUser-phone");
		if (this.stringByteSize(phone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-phone").val()).replace("{1}", 13).replace("{2}", 40));
			phone.focus();
			return false;
		}
		if (!this.isValidCharacter(phone.val(), 1)) {
			alert($("#directory-updateUser-invalidCharacterError-1").val().replace("{0}", $("#directory-phone").val()));
			phone.focus();
			return false;
		}
		
		// check mobilePhone
		var mobilePhone = $("#directory-updateUser-mobilePhone");
		if (this.stringByteSize(mobilePhone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-mobilePhone").val()).replace("{1}", 13).replace("{2}", 40));
			mobilePhone.focus();
			return false;
		}
		if (!this.isValidCharacter(mobilePhone.val(), 1)) {
			alert($("#directory-updateUser-invalidCharacterError-1").val().replace("{0}", $("#directory-mobilePhone").val()));
			mobilePhone.focus();
			return false;
		}
		
		// check fax
		var fax = $("#directory-updateUser-fax");
		if (this.stringByteSize(fax.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-fax").val()).replace("{1}", 13).replace("{2}", 40));
			fax.focus();
			return false;
		}
		if (!this.isValidCharacter(fax.val(), 1)) {
			alert($("#directory-updateUser-invalidCharacterError-1").val().replace("{0}", $("#directory-fax").val()));
			fax.focus();
			return false;
		}
		
		// check clientIPAddr
		var clientIPAddr = $("#directory-updateUser-clientIPAddr");
		if (this.stringByteSize(clientIPAddr.val()) > 64) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-clientIPAddr").val()).replace("{1}", 21).replace("{2}", 64));
			clientIPAddr.focus();
			return false;
		}
		if (!this.isValidCharacter(clientIPAddr.val(), 1)) {
			alert($("#directory-updateUser-invalidCharacterError-1").val().replace("{0}", $("#directory-clientIPAddr").val()));
			clientIPAddr.focus();
			return false;
		}
		
		// check phoneRuleID
		var phoneRuleID = $("#directory-updateUser-phoneRuleID");
		if (phoneRuleID.val() !== undefined) {
			if (!this.isValidNumber($.trim(phoneRuleID.val())) || $.trim(phoneRuleID.val()) < 0 || $.trim(phoneRuleID.val()) > 9) {
				alert($("#directory-updateUser-invalidPhoneRuleID").val());
				phoneRuleID.focus();
				return false;
			}
		}
		
		// check capacity
		var capacity = $("#directory-updateUser-capacity");
		if (capacity.val() !== undefined) {
			if (!this.isValidNumber($.trim(capacity.val())) || $.trim(capacity.val()) < 0 || $.trim(capacity.val()) > 99999) {
				alert($("#directory-updateUser-invalidMailCapacity").val());
				capacity.focus();
				return false;
			}
		}
		var cloudfolderCapacity = $("#directory-updateUser-cloudfolderCapacity");
		if (cloudfolderCapacity.val() !== undefined) {
			if (!this.isValidNumber($.trim(cloudfolderCapacity.val())) || $.trim(cloudfolderCapacity.val()) < 0 || $.trim(cloudfolderCapacity.val()) > 99999) {
				alert($("#directory-updateUser-invalidCloudfolderCapacity").val());
				capacity.focus();
				return false;
			}
		}
		
		return true;
	},
	viewMoveUsers : function(deptID, userIDs) {
		if (!userIDs) {
			userIDs = "";
			$("input[name='directory-listUsers-check']").each(function() {
				if ($(this).is(":checked")) {
					userIDs += $(this).val() + ";";
				}
			});
		}
		
		if ($.trim(userIDs).length == 0) {
			alert($("#directory-listUsers-selectItem").val());
			return;
		}
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewMoveUsers",
			deptID: deptID,
			userIDs: userIDs
		});
	},
	moveUsers : function(deptID, userIDs) {
		var targetDeptID = $("#directory-moveUsers-targetDeptID");
		
		if (!userIDs || userIDs.length == 0) {
			alert($("#directory-moveUsers-noUser").val());
			return;
		}
		if (targetDeptID.val().length == 0) {
			alert($("#directory-moveUsers-selectTargetDept").val());
			return;
		}
		if (targetDeptID.val() == deptID) {
			alert($("#directory-moveUsers-toSelfError").val());
			return;
		}
		if (!confirm($("#directory-moveUsers-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "moveUsers",
				deptID: deptID,
				userIDs: userIDs,
				targetDeptID: targetDeptID.val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_SELF:
						alert($("#directory-moveUsers-toSelfError").val());
						break;
					case directory_orgErrorCode.ORG_MNG_MOVE_TO_DELETEDDEPT:
						alert($("#directory-moveUsers-toDeletedDeptError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-moveUsers-userMoved").val());
					directory_orgMng.listUsers(targetDeptID.val()); // listUsers reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteUsers : function(deptID, userIDs) {
		if (!userIDs) {
			userIDs = "";
			$("input[name='directory-listUsers-check']").each(function() {
				if ($(this).is(":checked")) {
					userIDs += $(this).val() + ";";
				}
			});
		}
		
		if ($.trim(userIDs).length == 0) {
			alert($("#directory-listUsers-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deleteUsers-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteUsers",
				deptID: deptID,
				userIDs: userIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_ADMIN:
						alert($("#directory-deleteUsers-deleteAdminError").val());
						break;
					default:
						alert(result.errorMessage);
					}
					directory_orgMng.listUsers(deptID); // listUsers reload
				} else {
					alert($("#directory-deleteUsers-userDeleted").val());
					directory_history.remove(); // history remove
					directory_orgMng.listUsers(deptID); // listUsers reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	repairUsers : function(deptID, userIDs) {
		if (!userIDs) {
			userIDs = "";
			$("input[name='directory-listUsers-check']").each(function() {
				var status = $("#directory-listUsers-status" + $(this).val()).val();
				if ($(this).is(":checked") && status == "4") {
					userIDs += $(this).val() + ";";
				} else {
					$(this).attr("checked", false);
					if ($("#directory-listUsers-checkAll").is(":checked")) {
						$("#directory-listUsers-checkAll").attr("checked", false);
					}
				}
			});
		}
		
		if ($.trim(userIDs).length == 0) {
			alert($("#directory-listUsers-selectItem").val());
			return;
		}
		if (!confirm($("#directory-repairUsers-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "repairUsers",
				deptID: deptID,
				userIDs: userIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					alert(result.errorMessage);
					directory_orgMng.listUsers(deptID); // listUsers reload
				} else {
					alert($("#directory-repairUsers-repaired").val());
					directory_orgMng.listUsers(deptID); // listUsers reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	repairUser : function(userID) {
		if (!confirm($("#directory-repairUser-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "repairUser",
				userID: userID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					alert(result.errorMessage);
				} else {
					alert($("#directory-repairUser-repaired").val());
					directory_orgMng.viewUser(userID); // viewUser reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	viewUpdateUsersSeq : function(deptID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateUsersSeq",
			deptID: deptID
		});
	},
	updateUsersSeq : function(deptID) {
		var userIDs = "";
		$("#directory-updateUsersSeq-userList").find("option").each(function() {
			userIDs += $(this).val().split(":")[0] + ";";
		});
		
		if (!confirm($("#directory-updateUsersSeq-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateUsersSeq",
				userIDs: userIDs,
				deptID: deptID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateUsersSeq-sequenceUpdated").val());
					directory_orgMng.listUsers(deptID); // listUsers reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	batchUsers : function() {
		alert("// TODO : batchUsers();");
	},
	listPositions : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listPositions"
		}, function() {
			if (typeof(directory_listPositions_onLoad) != "undefined") {
				directory_listPositions_onLoad();
			}
		});
	},
	viewAddPosition : function() {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewAddPosition";
		
		var width = 360;
		var height = 220;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	addPosition : function() {
		if (!this.addPosition_validate()) {
			return;
		}
		if (!confirm($("#directory-addPosition-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "addPosition",
				positionCode: $.trim($("#directory-addPosition-positionCode").val()),
				positionName: $.trim($("#directory-addPosition-positionName").val()),
				positionNameEng: $.trim($("#directory-addPosition-positionNameEng").val()) || "",
				secLevel: $.trim($("#directory-addPosition-secLevel").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addPosition-dupPosCode").val().replace("{0}", $.trim($("#directory-addPosition-positionCode").val())));
						$("#directory-addPosition-positionCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addPosition-dupPosName").val().replace("{0}", $.trim($("#directory-addPosition-positionName").val())));
						$("#directory-addPosition-positionName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-addPosition-dupPosName").val().replace("{0}", $.trim($("#directory-addPosition-positionNameEng").val())));
						$("#directory-addPosition-positionNameEng").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addPosition-positionAdded").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listPositions(); // listPositions reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addPosition_validate : function() {
		// check positionCode
		var positionCode = $("#directory-addPosition-positionCode");
		if (this.stringByteSize(positionCode.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionCode").val()).replace("{1}", 6).replace("{2}", 20));
			positionCode.focus();
			return false;
		}
		if (!this.isValidCharacter(positionCode.val())) {
			alert($("#directory-addPosition-invalidCharacterError").val().replace("{0}", $("#directory-positionCode").val()));
			positionCode.focus();
			return false;
		}
		
		// check positionName
		var positionName = $("#directory-addPosition-positionName");
		if (this.stringByteSize(positionName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionName").val()).replace("{1}", 40).replace("{2}", 120));
			positionName.focus();
			return false;
		}
		if ($.trim(positionName.val()).length == 0) {
			alert($("#directory-addPosition-inputPositionName").val());
			positionName.val("");
			positionName.focus();
			return false;
		}
		if (!this.isValidCharacter(positionName.val())) {
			alert($("#directory-addPosition-invalidCharacterError").val().replace("{0}", $("#directory-positionName").val()));
			positionName.focus();
			return false;
		}
		
		// check positionNameEng
		var positionNameEng = $("#directory-addPosition-positionNameEng");
		if (positionNameEng.val() !== undefined) {
			if (this.stringByteSize(positionNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				positionNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(positionNameEng.val())) {
				alert($("#directory-addPosition-invalidCharacterError").val().replace("{0}", $("#directory-positionNameEng").val()));
				positionNameEng.focus();
				return false;
			}
		}
		
		// check secLevel
		var secLevel = $("#directory-addPosition-secLevel");
		if (!this.isValidNumber($.trim(secLevel.val())) || $.trim(secLevel.val()) < 0 || $.trim(secLevel.val()) > 99) {
			alert($("#directory-addPosition-invalidSecLevel").val());
			secLevel.focus();
			return false;
		}
		
		return true;
	},
	viewUpdatePosition : function(positionID) {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewUpdatePosition";
		url += "&positionID=" + positionID;
		
		var width = 360;
		var height = 240;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	updatePosition : function(positionID) {
		if (!this.updatePosition_validate()) {
			return;
		}
		if (!confirm($("#directory-updatePosition-confirm").val())) {
			return;
		}
		
		var updateUserSecLevel = "";
		if ($("#directory-updatePosition-updateUserSecLevel").is(":checked")) {
			updateUserSecLevel = $("#directory-updatePosition-updateUserSecLevel").val();
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updatePosition",
				positionID: positionID,
				positionCode: $.trim($("#directory-updatePosition-positionCode").val()),
				positionName: $.trim($("#directory-updatePosition-positionName").val()),
				positionNameEng: $.trim($("#directory-updatePosition-positionNameEng").val()) || "",
				secLevel: $.trim($("#directory-updatePosition-secLevel").val()),
				updateUserSecLevel: updateUserSecLevel
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-updatePosition-dupPosCode").val().replace("{0}", $.trim($("#directory-updatePosition-positionCode").val())));
						$("#directory-updatePosition-positionCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updatePosition-dupPosName").val().replace("{0}", $.trim($("#directory-updatePosition-positionName").val())));
						$("#directory-updatePosition-positionName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-updatePosition-dupPosName").val().replace("{0}", $.trim($("#directory-updatePosition-positionNameEng").val())));
						$("#directory-updatePosition-positionNameEng").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updatePosition-positionUpdated").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listPositions(); // listPositions reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updatePosition_validate : function() {
		// check positionCode
		var positionCode = $("#directory-updatePosition-positionCode");
		if (this.stringByteSize(positionCode.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionCode").val()).replace("{1}", 6).replace("{2}", 20));
			positionCode.focus();
			return false;
		}
		if (!this.isValidCharacter(positionCode.val())) {
			alert($("#directory-updatePosition-invalidCharacterError").val().replace("{0}", $("#directory-positionCode").val()));
			positionCode.focus();
			return false;
		}
		
		// check positionName
		var positionName = $("#directory-updatePosition-positionName");
		if (this.stringByteSize(positionName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionName").val()).replace("{1}", 40).replace("{2}", 120));
			positionName.focus();
			return false;
		}
		if ($.trim(positionName.val()).length == 0) {
			alert($("#directory-updatePosition-inputPositionName").val());
			positionName.val("");
			positionName.focus();
			return false;
		}
		if (!this.isValidCharacter(positionName.val())) {
			alert($("#directory-updatePosition-invalidCharacterError").val().replace("{0}", $("#directory-positionName").val()));
			positionName.focus();
			return false;
		}
		
		// check positionNameEng
		var positionNameEng = $("#directory-updatePosition-positionNameEng");
		if (positionNameEng.val() !== undefined) {
			if (this.stringByteSize(positionNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-positionNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				positionNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(positionNameEng.val())) {
				alert($("#directory-updatePosition-invalidCharacterError").val().replace("{0}", $("#directory-positionNameEng").val()));
				positionNameEng.focus();
				return false;
			}
		}
		
		// check secLevel
		var secLevel = $("#directory-updatePosition-secLevel");
		if (!this.isValidNumber($.trim(secLevel.val())) || $.trim(secLevel.val()) < 0 || $.trim(secLevel.val()) > 99) {
			alert($("#directory-updatePosition-invalidSecLevel").val());
			secLevel.focus();
			return false;
		}
		
		return true;
	},
	deletePositions : function() {
		var positionIDs = "";
		$("input[name='directory-listPositions-check']").each(function() {
			if ($(this).is(":checked")) {
				positionIDs += $(this).val() + ";";
			}
		});
		
		if ($.trim(positionIDs).length == 0) {
			alert($("#directory-listPositions-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deletePositions-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deletePositions",
				positionIDs: positionIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deletePositions-usedPositionError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deletePositions-positionDeleted").val());
					directory_orgMng.listPositions(); // listPositions reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listRanks : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listRanks"
		}, function() {
			if (typeof(directory_listRanks_onLoad) != "undefined") {
				directory_listRanks_onLoad();
			}
		});
	},
	viewAddRank : function() {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewAddRank";
		
		var width = 360;
		var height = 220;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	addRank : function() {
		if (!this.addRank_validate()) {
			return;
		}
		if (!confirm($("#directory-addRank-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "addRank",
				rankCode: $.trim($("#directory-addRank-rankCode").val()),
				rankName: $.trim($("#directory-addRank-rankName").val()),
				rankNameEng: $.trim($("#directory-addRank-rankNameEng").val()) || "",
				rankLevel: $.trim($("#directory-addRank-rankLevel").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addRank-dupRankCode").val().replace("{0}", $.trim($("#directory-addRank-rankCode").val())));
						$("#directory-addRank-rankCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addRank-dupRankName").val().replace("{0}", $.trim($("#directory-addRank-rankName").val())));
						$("#directory-addRank-rankName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-addRank-dupRankName").val().replace("{0}", $.trim($("#directory-addRank-rankNameEng").val())));
						$("#directory-addRank-rankNameEng").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addRank-rankAdded").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listRanks(); // listRanks reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addRank_validate : function() {
		// check rankCode
		var rankCode = $("#directory-addRank-rankCode");
		if (this.stringByteSize(rankCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankCode").val()).replace("{1}", 13).replace("{2}", 40));
			rankCode.focus();
			return false;
		}
		if (!this.isValidCharacter(rankCode.val())) {
			alert($("#directory-addRank-invalidCharacterError").val().replace("{0}", $("#directory-rankCode").val()));
			rankCode.focus();
			return false;
		}
		
		// check rankName
		var rankName = $("#directory-addRank-rankName");
		if (this.stringByteSize(rankName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankName").val()).replace("{1}", 40).replace("{2}", 120));
			rankName.focus();
			return false;
		}
		if ($.trim(rankName.val()).length == 0) {
			alert($("#directory-addRank-inputRankName").val());
			rankName.val("");
			rankName.focus();
			return false;
		}
		if (!this.isValidCharacter(rankName.val())) {
			alert($("#directory-addRank-invalidCharacterError").val().replace("{0}", $("#directory-rankName").val()));
			rankName.focus();
			return false;
		}
		
		// check rankNameEng
		var rankNameEng = $("#directory-addRank-rankNameEng");
		if (rankNameEng.val() !== undefined) {
			if (this.stringByteSize(rankNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				rankNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(rankNameEng.val())) {
				alert($("#directory-addRank-invalidCharacterError").val().replace("{0}", $("#directory-rankNameEng").val()));
				rankNameEng.focus();
				return false;
			}
		}
		
		// check rankLevel
		var rankLevel = $("#directory-addRank-rankLevel");
		if (!this.isValidNumber($.trim(rankLevel.val())) || $.trim(rankLevel.val()) < 0 || $.trim(rankLevel.val()) > 999) {
			alert($("#directory-addRank-invalidRankLevel").val());
			rankLevel.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateRank : function(rankID) {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewUpdateRank";
		url += "&rankID=" + rankID;
		
		var width = 360;
		var height = 240;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	updateRank : function(rankID) {
		if (!this.updateRank_validate()) {
			return;
		}
		if (!confirm($("#directory-updateRank-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateRank",
				rankID: rankID,
				rankCode: $.trim($("#directory-updateRank-rankCode").val()),
				rankName: $.trim($("#directory-updateRank-rankName").val()),
				rankNameEng: $.trim($("#directory-updateRank-rankNameEng").val()) || "",
				rankLevel: $.trim($("#directory-updateRank-rankLevel").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-updateRank-dupRankCode").val().replace("{0}", $.trim($("#directory-updateRank-rankCode").val())));
						$("#directory-updateRank-rankCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateRank-dupRankName").val().replace("{0}", $.trim($("#directory-updateRank-rankName").val())));
						$("#directory-updateRank-rankName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ENG_ALREADY_EXIST: // English Name
						alert($("#directory-updateRank-dupRankName").val().replace("{0}", $.trim($("#directory-updateRank-rankNameEng").val())));
						$("#directory-updateRank-rankNameEng").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateRank-rankUpdated").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listRanks(); // listRanks reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateRank_validate : function() {
		// check rankCode
		var rankCode = $("#directory-updateRank-rankCode");
		if (this.stringByteSize(rankCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankCode").val()).replace("{1}", 13).replace("{2}", 40));
			rankCode.focus();
			return false;
		}
		if (!this.isValidCharacter(rankCode.val())) {
			alert($("#directory-updateRank-invalidCharacterError").val().replace("{0}", $("#directory-rankCode").val()));
			rankCode.focus();
			return false;
		}
		
		// check rankName
		var rankName = $("#directory-updateRank-rankName");
		if (this.stringByteSize(rankName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankName").val()).replace("{1}", 40).replace("{2}", 120));
			rankName.focus();
			return false;
		}
		if ($.trim(rankName.val()).length == 0) {
			alert($("#directory-updateRank-inputRankName").val());
			rankName.val("");
			rankName.focus();
			return false;
		}
		if (!this.isValidCharacter(rankName.val())) {
			alert($("#directory-updateRank-invalidCharacterError").val().replace("{0}", $("#directory-rankName").val()));
			rankName.focus();
			return false;
		}
		
		// check rankNameEng
		var rankNameEng = $("#directory-updateRank-rankNameEng");
		if (rankNameEng.val() !== undefined) {
			if (this.stringByteSize(rankNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-rankNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				rankNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(rankNameEng.val())) {
				alert($("#directory-updateRank-invalidCharacterError").val().replace("{0}", $("#directory-rankNameEng").val()));
				rankNameEng.focus();
				return false;
			}
		}
		
		// check rankLevel
		var rankLevel = $("#directory-updateRank-rankLevel");
		if (!this.isValidNumber($.trim(rankLevel.val())) || $.trim(rankLevel.val()) < 0 || $.trim(rankLevel.val()) > 999) {
			alert($("#directory-updateRank-invalidRankLevel").val());
			rankLevel.focus();
			return false;
		}
		
		return true;
	},
	deleteRanks : function() {
		var rankIDs = "";
		$("input[name='directory-listRanks-check']").each(function() {
			if ($(this).is(":checked")) {
				rankIDs += $(this).val() + ";";
			}
		});
		
		if ($.trim(rankIDs).length == 0) {
			alert($("#directory-listRanks-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deleteRanks-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteRanks",
				rankIDs: rankIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteRanks-usedRankError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteRanks-rankDeleted").val());
					directory_orgMng.listRanks(); // listRanks reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listDuties : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listDuties"
		}, function() {
			if (typeof(directory_listDuties_onLoad) != "undefined") {
				directory_listDuties_onLoad();
			}
		});
	},
	viewAddDuty : function() {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewAddDuty";
		
		var width = 360;
		var height = 220;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	addDuty : function() {
		if (!this.addDuty_validate()) {
			return;
		}
		if (!confirm($("#directory-addDuty-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "addDuty",
				dutyCode: $.trim($("#directory-addDuty-dutyCode").val()),
				dutyName: $.trim($("#directory-addDuty-dutyName").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addDuty-dupDutyCode").val().replace("{0}", $.trim($("#directory-addDuty-dutyCode").val())));
						$("#directory-addDuty-dutyCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addDuty-dupDutyName").val().replace("{0}", $.trim($("#directory-addDuty-dutyName").val())));
						$("#directory-addDuty-dutyName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addDuty-dutyAdded").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listDuties(); // listDuties reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addDuty_validate : function() {
		// check dutyCode
		var dutyCode = $("#directory-addDuty-dutyCode");
		if (this.stringByteSize(dutyCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dutyCode").val()).replace("{1}", 13).replace("{2}", 40));
			dutyCode.focus();
			return false;
		}
		if (!this.isValidCharacter(dutyCode.val())) {
			alert($("#directory-addDuty-invalidCharacterError").val().replace("{0}", $("#directory-dutyCode").val()));
			dutyCode.focus();
			return false;
		}
		
		// check dutyName
		var dutyName = $("#directory-addDuty-dutyName");
		if (this.stringByteSize(dutyName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dutyName").val()).replace("{1}", 40).replace("{2}", 120));
			dutyName.focus();
			return false;
		}
		if ($.trim(dutyName.val()).length == 0) {
			alert($("#directory-addDuty-inputDutyName").val());
			dutyName.val("");
			dutyName.focus();
			return false;
		}
		if (!this.isValidCharacter(dutyName.val())) {
			alert($("#directory-addDuty-invalidCharacterError").val().replace("{0}", $("#directory-dutyName").val()));
			dutyName.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDuty : function(dutyID) {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewUpdateDuty";
		url += "&dutyID=" + dutyID;
		
		var width = 360;
		var height = 240;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	updateDuty : function(dutyID) {
		if (!this.updateDuty_validate()) {
			return;
		}
		if (!confirm($("#directory-updateDuty-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateDuty",
				dutyID: dutyID,
				dutyCode: $.trim($("#directory-updateDuty-dutyCode").val()),
				dutyName: $.trim($("#directory-updateDuty-dutyName").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-updateDuty-dupDutyCode").val().replace("{0}", $.trim($("#directory-updateDuty-dutyCode").val())));
						$("#directory-updateDuty-dutyCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateDuty-dupDutyName").val().replace("{0}", $.trim($("#directory-updateDuty-dutyName").val())));
						$("#directory-updateDuty-dutyName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDuty-dutyUpdated").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listDuties(); // listDuties reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateDuty_validate : function() {
		// check dutyCode
		var dutyCode = $("#directory-updateDuty-dutyCode");
		if (this.stringByteSize(dutyCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dutyCode").val()).replace("{1}", 13).replace("{2}", 40));
			dutyCode.focus();
			return false;
		}
		if (!this.isValidCharacter(dutyCode.val())) {
			alert($("#directory-updateDuty-invalidCharacterError").val().replace("{0}", $("#directory-dutyCode").val()));
			dutyCode.focus();
			return false;
		}
		
		// check dutyName
		var dutyName = $("#directory-updateDuty-dutyName");
		if (this.stringByteSize(dutyName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dutyName").val()).replace("{1}", 40).replace("{2}", 120));
			dutyName.focus();
			return false;
		}
		if ($.trim(dutyName.val()).length == 0) {
			alert($("#directory-updateDuty-inputDutyName").val());
			dutyName.val("");
			dutyName.focus();
			return false;
		}
		if (!this.isValidCharacter(dutyName.val())) {
			alert($("#directory-updateDuty-invalidCharacterError").val().replace("{0}", $("#directory-dutyName").val()));
			dutyName.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDutiesSeq : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateDutiesSeq"
		});
	},
	updateDutiesSeq : function() {
		var dutyIDs = "";
		$("#directory-updateDutiesSeq-dutyList").find("option").each(function() {
			dutyIDs += $(this).val() + ";";
		});
		
		if (!confirm($("#directory-updateDutiesSeq-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateDutiesSeq",
				dutyIDs: dutyIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDutiesSeq-sequenceUpdated").val());
					directory_orgMng.listDuties(); // listDuties reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteDuties : function() {
		var dutyIDs = "";
		$("input[name='directory-listDuties-check']").each(function() {
			if ($(this).is(":checked")) {
				dutyIDs += $(this).val() + ";";
			}
		});
		
		if ($.trim(dutyIDs).length == 0) {
			alert($("#directory-listDuties-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deleteDuties-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteDuties",
				dutyIDs: dutyIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteDuties-usedDutyError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteDuties-dutyDeleted").val());
					directory_orgMng.listDuties(); // listDuties reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listAuthes : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listAuthes"
		}, function() {
			if (typeof(directory_listAuthes_onLoad) != "undefined") {
				directory_listAuthes_onLoad();
			}
		});
	},
	viewAddAuth : function() {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewAddAuth";
		
		var width = 360;
		var height = 285;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	addAuth : function() {
		if (!this.addAuth_validate()) {
			return;
		}
		if (!confirm($("#directory-addAuth-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "addAuth",
				authName: $.trim($("#directory-addAuth-authName").val()),
				authCode: $.trim($("#directory-addAuth-authCode").val()),
				authType: $.trim($("#directory-addAuth-authType").val()),
				authMultiFlag: $.trim($("#directory-addAuth-authMultiFlag").val()),
				authDescription: $.trim($("#directory-addAuth-authDescription").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addAuth-authDupAuthCode").val().replace("{0}", $.trim($("#directory-addAuth-authCode").val())));
						$("#directory-addAuth-authCode").focus();
						break;
					/* TODO 이름 중복검사 추가 필요
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addAuth-authDupAuthName").val().replace("{0}", $.trim($("#directory-addAuth-authName").val())));
						$("#directory-addAuth-authName").focus();
						break;
					*/
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addAuth-authAdded").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listAuthes(); // listAuthes reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addAuth_validate : function() {
		// check authCode
		var authCode = $("#directory-addAuth-authCode");
		if (this.stringByteSize(authCode.val()) > 3) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-authCode").val()).replace("{1}", 1).replace("{2}", 3));
			authCode.focus();
			return false;
		}
		if ($.trim(authCode.val()).length == 0) {
			alert($("#directory-addAuth-inputAuthCode").val());
			authCode.val("");
			authCode.focus();
			return false;
		}
		if (!this.isValidCharacter(authCode.val())) {
			alert($("#directory-addAuth-invalidCharacterError").val().replace("{0}", $("#directory-authCode").val()));
			authCode.focus();
			return false;
		}
		
		// check authName
		var authName = $("#directory-addAuth-authName");
		if (this.stringByteSize(authName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-authName").val()).replace("{1}", 20).replace("{2}", 60));
			authName.focus();
			return false;
		}
		if ($.trim(authName.val()).length == 0) {
			alert($("#directory-addAuth-inputAuthName").val());
			authName.val("");
			authName.focus();
			return false;
		}
		if (!this.isValidCharacter(authName.val())) {
			alert($("#directory-addAuth-invalidCharacterError").val().replace("{0}", $("#directory-authName").val()));
			authName.focus();
			return false;
		}
		
		// check authDescription
		var authDescription = $("#directory-addAuth-authDescription");
		if (this.stringByteSize(authDescription.val()) > 200) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-authDescription").val()).replace("{1}", 66).replace("{2}", 200));
			authDescription.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateAuth : function(authCode) {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewUpdateAuth";
		url += "&authCode=" + authCode;
		
		var width = 360;
		var height = 285;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	updateAuth : function(authCode) {
		if (!this.updateAuth_validate()) {
			return;
		}
		if (!confirm($("#directory-updateAuth-confirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateAuth",
				authName: $.trim($("#directory-updateAuth-authName").val()),
				authCode: authCode,
				authType: $.trim($("#directory-updateAuth-authType").val()),
				authMultiFlag: $.trim($("#directory-updateAuth-authMultiFlag").val()),
				authDescription: $.trim($("#directory-updateAuth-authDescription").val())
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_UPDATE_IN_USE:
						alert($("#directory-updateAuth-updateAuthError").val());
						break;
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateAuth-authUpdated").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listAuthes(); // listAuthes reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateAuth_validate : function() {
		// check authName
		var authName = $("#directory-updateAuth-authName");
		if (this.stringByteSize(authName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-authName").val()).replace("{1}", 20).replace("{2}", 60));
			authName.focus();
			return false;
		}
		if ($.trim(authName.val()).length == 0) {
			alert($("#directory-updateAuth-inputAuthName").val());
			authName.val("");
			authName.focus();
			return false;
		}
		if (!this.isValidCharacter(authName.val())) {
			alert($("#directory-updateAuth-invalidCharacterError").val().replace("{0}", $("#directory-authName").val()));
			authName.focus();
			return false;
		}
		
		// check authDescription
		var authDescription = $("#directory-updateAuth-authDescription");
		if (this.stringByteSize(authDescription.val()) > 200) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-authDescription").val()).replace("{1}", 66).replace("{2}", 200));
			authDescription.focus();
			return false;
		}
		
		return true;
	},
	deleteAuthes : function() {
		var authCodes = "";
		$("input[name='directory-listAuthes-check']").each(function() {
			if ($(this).is(":checked")) {
				authCodes += $(this).val() + ";";
			}
		});
		
		if ($.trim(authCodes).length == 0) {
			alert($("#directory-listAuthes-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deleteAuthes-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteAuthes",
				authCodes: authCodes
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteAuthes-usedAuthError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteAuthes-authDeleted").val());
					directory_orgMng.listAuthes(); // listAuthes reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteAuth : function(authCode) {
		if ($.trim(authCode).length == 0) {
			alert($("#directory-listAuthes-selectItem").val());
			return;
		}
		if (!confirm($("#directory-deleteAuthes-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteAuth",
				authCode: authCode
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteAuthes-usedAuthError").val());
						break;
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert($("#directory-deleteAuthes-usedAuthError").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteAuthes-authDeleted").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listAuthes(); // listAuthes reload
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listSearch : function(searchType, searchValue, orderField, orderType) {
		searchValue = $.trim(searchValue); // trim
		
		if (searchType && searchValue.length == 0 && !orderField) {
			alert($("#directory-listSearch-noneTerm").val());
			$("#directory-listSearch-searchValue").val("");
			$("#directory-listSearch-searchValue").focus();
			return false;
		}
		
		directory_history.removeAll(); // history remove all
		directory_history.push(this.listSearch, this, [searchType, searchValue, orderField, orderType]); // history push
		directory_orgMng_switchMenu("search");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listSearch",
			display: $("#directory-display").val(),
			useAbsent: $("#directory-useAbsent").val(),
			searchType: searchType,
			searchValue: searchValue,
			orderField: orderField,
			orderType: orderType
		}, function() {
			if (typeof(directory_listSearch_onLoad) != "undefined") {
				directory_listSearch_onLoad();
			}
		});
	},
	
	listBatchs : function(page) {
		
		var listType = "all";
		var currentPage = 1;
		
		if($("#directory-listBatchs-currentPage").length > 0)
			currentPage = $("#directory-listBatchs-currentPage").val();
		
		if($("#directory-listBatchs-listType").length > 0)
			listType = $("#directory-listBatchs-listType").val();

		if(page)
			currentPage = page;
				
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listBatchs",
			listType: listType,
			currentPage: currentPage						
		}, function() {
			if (typeof(directory_listBatchs_onLoad) != "undefined") {
				directory_listBatchs_onLoad();
			}
		});
	},
	viewAddBatch : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddBatch"		
		});
	},
	addBatch : function(charset) {
		var stoped = false;		
		
		if (!confirm($("#directory-addBatch-confirm").val())) {
			return;
		}
		var data = {
			//acton: "addBatch"	
		};
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=addBatch";
		if(typeof(charset) != 'undefined'){
			url += "&charset="+charset;
		}		
				
		var options = {
				
			url: url,
			type: "post",
			async: false,			
			data: data,				
			dataType:"json",
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.CANNOT_OPEN_FILE:
						alert($("#directory-addBatch-fileReadError").val())
						break;
					case directory_orgErrorCode.ORG_MNG_BATCH_NOTEXIST_ORG_TYPE:
						alert($("#directory-addBatch-notExistOrgType").val())
						break;
					case directory_orgErrorCode.ORG_MNG_BATCH_UNKNOWN_ORG_TYPE:
						alert($("#directory-addBatch-unknownOrgType").val())
						break;
					case directory_orgErrorCode.ORG_MNG_BATCH_UNKNOWN_OP_TYPE:	 
						alert($("#directory-addBatch-unknwonOpType").val())
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addBatch-batchAdded").val());
				
					directory_orgMng.listBatchs();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		};

		$('#directory-addBatch-addBatchform').ajaxForm(options);
		$('#directory-addBatch-addBatchform').submit();
		
	},
	viewExportBatch : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewExportBatch"		
		});
	},
	exportBatch : function(type, exportDate, charset) {

		var typeStr = '';			
		
		if (type == '0')
			typeStr = $('#directory-exportBatch-user').val();
		else if (type == '1')
			typeStr = $('#directory-exportBatch-dept').val();
		else if (type == '2')
			typeStr = $('#directory-exportBatch-position').val();
		else if (type == '3')
			typeStr = $('#directory-exportBatch-rank').val();
		else if (type == '4')
			typeStr = $('#directory-exportBatch-duty').val();
		else
			typeStr = $('#directory-exportBatch-auth').val();

		if (!confirm($('#directory-exportBatch-confirm').val().replace("{0}", typeStr))) {
			return;
		}
		
		var acton = "exportBatch";
		
		var iframe = document.createElement("iframe");
		var iframeSrc = DIRECTORY_CONTEXT + "/orgMng.do?" + "acton=" + acton + "&type=" + type;
		if(typeof(exportDate) != 'undefined'){
			iframeSrc += "&exportDate="+exportDate;
		}
		if(typeof(charset) != 'undefined'){
			iframeSrc += "&charset="+charset;
		}
		iframe.src = iframeSrc;
		iframe.style.display = "none";
		 
		document.body.appendChild(iframe);
	},
	retryBatch : function() {
		if (!confirm($("#directory-listBatchs-batchRetryConfirm").val())) {
			return;
		}
				
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			
			data: {
				acton: "retryBatch",
				listType: $("#directory-listBatchs-listType").val(),
				currentPage: $("#directory-listBatchs-currentPage").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listBatchs-batchIsWaited").val());					
					directory_orgMng.listBatchs();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteBatch : function(batchIDs) {
		
		if (!batchIDs) {
			batchIDs = "";
			$("input[name='directory-listBatchs-check']").each(function() {
				if ($(this).is(":checked")) {
					batchIDs += $(this).val() + ";";
				}
			});
		}
		
		if ($.trim(batchIDs).length == 0) {
			alert($("#directory-listBatchs-selectItem").val());
			return;
		}		

		if (!confirm($("#directory-listBatchs-batchDeleteConfirm").val())) {
			return;
		}	
		
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteBatch",
				listType: $("#directory-listBatchs-listType").val(),				
				batchIDs: batchIDs,
				currentPage: $("#directory-listBatchs-currentPage").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listBatchs-batchDeleted").val());
					directory_orgMng.listBatchs();
								
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},	
	deleteAllBatchs : function() {
		
		var listType = $("#directory-listBatchs-listType").val();
		
		if (listType == "success") {
			if(!confirm($("#directory-listBatchs-batchDeleteSuccessAllConfirm").val()))
				return;
		} else {
			if(!confirm($("#directory-listBatchs-batchDeleteAllConfirm").val()))
				return;
		}
				
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			
			data: {
				acton: "deleteAllBatchs",
				listType: $("#directory-listBatchs-listType").val(),
				currentPage: $("#directory-listBatchs-currentPage").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listBatchs-batchDeleted").val());					
					directory_orgMng.listBatchs();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	runBatchProcess : function() {
		if (!confirm($("#directory-listBatchs-runBatchProcess-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "runBatchProcess"
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listBatchs-runBatchProcess-success").val());
					directory_orgMng.initDeptTree($("#directory-baseDept").val(), true);			
					directory_orgMng.listBatchs();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	viewBatchMsg : function(batchID) {
		var url = DIRECTORY_CONTEXT + "/orgMng.do?acton=viewBatchMsg";
		url += "&batchID="+ batchID + "&listType=" + $("#directory-listBatchs-listType").val();
		
		var width = 680;
		var height = 600;
		var features = "left="+(screen.width/2-width/2)+",top="+(screen.height/2-height/2)+",width="+width+",height="+height+",";
		features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
		window.open(url, "orgMngPopup", features);
	},
	deleteBatchMsg : function(batchID) {
		if (!confirm($("#directory-listBatchs-batchDeleteConfirm").val())) {
			return;
		}
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteBatch",
				listType: $("#directory-listBatchs-listType").val(),
				currentPage: $("#directory-listBatchs-currentPage").val(),				
				batchIDs: batchID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listBatchs-batchDeleted").val());
					$(window).bind("beforeunload", function() {
						window.opener.directory_orgMng.listBatchs();
					});
					window.close();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listCommunities : function() {
		directory_history.push(this.listCommunities, this, []); // history push
		directory_orgMng_switchMenu("community");
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listCommunities"
		}, function() {
			if (typeof(directory_listCommunities_onLoad) != "undefined") {
				directory_listCommunities_onLoad();
			}
		});
	},
	viewCommunity : function(communityID) {
		directory_history.push(this.viewCommunity, this, [communityID]); // history push
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton:	"viewCommunity",
			communityID: communityID
		});
	},
	viewAddCommunity : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddCommunity"
		}, function() {
			if (typeof(directory_addCommunity_onLoad) != "undefined") {
				directory_addCommunity_onLoad();
			}
		});
	},
	addCommunity : function() {
		if (!this.addCommunity_validate()) {
			return;
		}
		
		if (!confirm($("#directory-addCommunity-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "addCommunity",
			communityName: $.trim($("#directory-addCommunity-communityName").val()),
			communityAlias: $.trim($("#directory-addCommunity-communityAlias").val()),
			communityManagerName: $.trim($("#directory-addCommunity-communityManagerName").val()),
			communityMaxUser: $.trim($("#directory-addCommunity-communityMaxUser").val()),
			communityExpiryDate: $.trim($("#directory-addCommunity-communityExpiryDate").val()),
			communityExpiryDateUnlimited: $("#directory-addCommunity-communityExpiryDateUnlimited").is(":checked"),
			communityPhone: $.trim($("#directory-addCommunity-communityPhone").val()),
			communityFax: $.trim($("#directory-addCommunity-communityFax").val()),
			communityHomeUrl: $.trim($("#directory-addCommunity-communityHomeUrl").val()),
			communityEmail: $.trim($("#directory-addCommunity-communityEmail").val()),
			communityDefaultLocale: $.trim($("#directory-addCommunity-communityDefaultLocale").val())
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addCommunity-dupCommunityName").val().replace("{0}", $.trim($("#directory-addCommunity-communityName").val())));
						$("#directory-addCommunity-communityName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_ALIAS_ALREADY_EXIST:
						alert($("#directory-addCommunity-dupCommunityAlias").val().replace("{0}", $.trim($("#directory-addCommunity-communityAlias").val())));
						$("#directory-addCommunity-communityAlias").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addCommunity-communityAdded").val());
					$("#directory-workspace").empty();
					if (result.communityID) {
						directory_orgMng.viewCommunity(result.communityID);
					} else {
						directory_orgMng.listCommunities();
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addCommunity_validate : function() {
		// check communityName
		var communityName = $("#directory-addCommunity-communityName");
		if (this.stringByteSize(communityName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityName").val()).replace("{1}", 20).replace("{2}", 60));
			communityName.focus();
			return false;
		}
		if ($.trim(communityName.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityName").val());
			communityName.val("");
			communityName.focus();
			return false;
		}
		if (!this.isValidCharacter(communityName.val())) {
			alert($("#directory-addCommunity-invalidCharacterError").val().replace("{0}", $("#directory-communityName").val()));
			communityName.focus();
			return false;
		}

		// check communityAlias
		var communityAlias = $("#directory-addCommunity-communityAlias");
		if (this.stringByteSize(communityAlias.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityAlias").val()).replace("{1}", 20).replace("{2}", 60));
			communityName.focus();
			return false;
		}
		if ($.trim(communityAlias.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityAlias").val());
			communityAlias.val("");
			communityAlias.focus();
			return false;
		}
		if (!this.isValidAlphaNum(communityAlias.val(), "_")) {
			alert($("#directory-addCommunity-invalidCommunityAlias").val().replace("{0}", 60));
			communityAlias.focus();
			return false;
		}

		// check communityManagerName
		var communityManagerName = $("#directory-addCommunity-communityManagerName");
		if (this.stringByteSize(communityManagerName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityManagerName").val()).replace("{1}", 20).replace("{2}", 60));
			communityManagerName.focus();
			return false;
		}
		if ($.trim(communityManagerName.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityManagerName").val());
			communityManagerName.val("");
			communityManagerName.focus();
			return false;
		}
		if (!this.isValidCharacter(communityManagerName.val())) {
			alert($("#directory-addCommunity-invalidCharacterError").val().replace("{0}", $("#directory-communityManagerName").val()));
			communityManagerName.focus();
			return false;
		}

		// check communityMaxUser
		var communityMaxUser = $("#directory-addCommunity-communityMaxUser");
		if (this.stringByteSize(communityMaxUser.val()) > 10) {
			alert($("#directory-maxLength-3").val().replace("{0}", $("#directory-communityMaxUser").val()).replace("{1}", 10));
			communityMaxUser.focus();
			return false;
		}
		if ($.trim(communityMaxUser.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityMaxUser").val());
			communityMaxUser.val("");
			communityMaxUser.focus();
			return false;
		}
		if (!this.isValidNumber($.trim(communityMaxUser.val())) || Number($.trim(communityMaxUser.val())) <= 0) {
			alert($("#directory-addCommunity-invalidCommunityMaxUser").val());
			communityMaxUser.focus();
			return false;
		}

		// check communityExpiryDate
		var communityExpiryDate = $("#directory-addCommunity-communityExpiryDate");
		var isUnlimited = $("#directory-addCommunity-communityExpiryDateUnlimited").is(":checked");
		if (!isUnlimited && $.trim(communityExpiryDate.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityExpiryDate").val());
			communityExpiryDate.val("");
			communityExpiryDate.focus();
			return false;
		}
		if (!isUnlimited && $.trim(communityExpiryDate.val()).length > 0 && !this.isValidDate($.trim(communityExpiryDate.val()), "after")) {
			alert($("#directory-addCommunity-invalidCommunityExpiryDate").val());
			communityExpiryDate.focus();
			return false;
		}

		// check communityPhone
		var communityPhone = $("#directory-addCommunity-communityPhone");
		if (this.stringByteSize(communityPhone.val()) > 40) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityPhone").val()).replace("{1}", 40));
			communityPhone.focus();
			return false;
		}

		// check communityFax
		var communityFax = $("#directory-addCommunity-communityFax");
		if (this.stringByteSize(communityFax.val()) > 40) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityFax").val()).replace("{1}", 40));
			communityFax.focus();
			return false;
		}

		// check communityHomeUrl
		var communityHomeUrl = $("#directory-addCommunity-communityHomeUrl");
		if (this.stringByteSize(communityHomeUrl.val()) > 200) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityHomeUrl").val()).replace("{1}", 200));
			communityHomeUrl.focus();
			return false;
		}

		// check communityEmail
		var communityEmail = $("#directory-addCommunity-communityEmail");
		if (this.stringByteSize(communityEmail.val()) > 128) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityEmail").val()).replace("{1}", 128));
			communityEmail.focus();
			return false;
		}
		if ($.trim(communityEmail.val()).length == 0) {
			alert($("#directory-addCommunity-inputCommunityEmail").val());
			communityEmail.val("");
			communityEmail.focus();
			return false;
		}
		if ($.trim(communityEmail.val()).length > 0 && !this.isValidEmail(communityEmail.val())) {
			alert($("#directory-addCommunity-invalidEmailError").val());
			communityEmail.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateCommunity : function(communityID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateCommunity",
			communityID: communityID
		}, function() {
			if (typeof(directory_updateCommunity_onLoad) != "undefined") {
				directory_updateCommunity_onLoad();
			}
		});
	},
	updateCommunity : function(communityID) {
		if (!this.updateCommunity_validate()) {
			return;
		}
		
		if (!confirm($("#directory-updateCommunity-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "updateCommunity",
			communityID: communityID,
			communityName: $.trim($("#directory-updateCommunity-communityName").val()),
			communityAlias: $.trim($("#directory-updateCommunity-communityAlias").val()),
			communityManagerName: $.trim($("#directory-updateCommunity-communityManagerName").val()),
			communityMaxUser: $.trim($("#directory-updateCommunity-communityMaxUser").val()),
			communityExpiryDate: $.trim($("#directory-updateCommunity-communityExpiryDate").val()),
			communityExpiryDateUnlimited: $("#directory-updateCommunity-communityExpiryDateUnlimited").is(":checked"),
			communityPhone: $.trim($("#directory-updateCommunity-communityPhone").val()),
			communityFax: $.trim($("#directory-updateCommunity-communityFax").val()),
			communityHomeUrl: $.trim($("#directory-updateCommunity-communityHomeUrl").val()),
			communityEmail: $.trim($("#directory-updateCommunity-communityEmail").val()),
			communityDefaultLocale: $.trim($("#directory-updateCommunity-communityDefaultLocale").val())
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateCommunity-dupCommunityName").val().replace("{0}", $.trim($("#directory-updateCommunity-communityName").val())));
						$("#directory-updateCommunity-communityName").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_ALIAS_ALREADY_EXIST:
						alert($("#directory-updateCommunity-dupCommunityAlias").val().replace("{0}", $.trim($("#directory-updateCommunity-communityAlias").val())));
						$("#directory-updateCommunity-communityAlias").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateCommunity-communityAdded").val());
					$("#directory-workspace").empty();
					if (result.communityID) {
						directory_orgMng.viewCommunity(result.communityID);
					} else {
						directory_orgMng.listCommunities();
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateCommunity_validate : function() {
		// check communityName
		var communityName = $("#directory-updateCommunity-communityName");
		if (this.stringByteSize(communityName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityName").val()).replace("{1}", 20).replace("{2}", 60));
			communityName.focus();
			return false;
		}
		if ($.trim(communityName.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityName").val());
			communityName.val("");
			communityName.focus();
			return false;
		}
		if (!this.isValidCharacter(communityName.val())) {
			alert($("#directory-updateCommunity-invalidCharacterError").val().replace("{0}", $("#directory-communityName").val()));
			communityName.focus();
			return false;
		}
		
		// check communityAlias
		var communityAlias = $("#directory-updateCommunity-communityAlias");
		if (this.stringByteSize(communityAlias.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityAlias").val()).replace("{1}", 20).replace("{2}", 60));
			communityName.focus();
			return false;
		}
		if ($.trim(communityAlias.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityAlias").val());
			communityAlias.val("");
			communityAlias.focus();
			return false;
		}
		if (!this.isValidAlphaNum(communityAlias.val(), "_")) {
			alert($("#directory-updateCommunity-invalidCommunityAlias").val().replace("{0}", 60));
			communityAlias.focus();
			return false;
		}
		
		// check communityManagerName
		var communityManagerName = $("#directory-updateCommunity-communityManagerName");
		if (this.stringByteSize(communityManagerName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-communityManagerName").val()).replace("{1}", 20).replace("{2}", 60));
			communityManagerName.focus();
			return false;
		}
		if ($.trim(communityManagerName.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityManagerName").val());
			communityManagerName.val("");
			communityManagerName.focus();
			return false;
		}
		if (!this.isValidCharacter(communityManagerName.val())) {
			alert($("#directory-updateCommunity-invalidCharacterError").val().replace("{0}", $("#directory-communityManagerName").val()));
			communityManagerName.focus();
			return false;
		}
		
		// check communityMaxUser
		var communityMaxUser = $("#directory-updateCommunity-communityMaxUser");
		if (this.stringByteSize(communityMaxUser.val()) > 10) {
			alert($("#directory-maxLength-3").val().replace("{0}", $("#directory-communityMaxUser").val()).replace("{1}", 10));
			communityMaxUser.focus();
			return false;
		}
		if ($.trim(communityMaxUser.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityMaxUser").val());
			communityMaxUser.val("");
			communityMaxUser.focus();
			return false;
		}
		if (!this.isValidNumber($.trim(communityMaxUser.val())) || Number($.trim(communityMaxUser.val())) <= 0) {
			alert($("#directory-updateCommunity-invalidCommunityMaxUser").val());
			communityMaxUser.focus();
			return false;
		}

		// check communityExpiryDate
		var communityExpiryDate = $("#directory-updateCommunity-communityExpiryDate");
		var isUnlimited = $("#directory-updateCommunity-communityExpiryDateUnlimited").is(":checked");
		if (!isUnlimited && $.trim(communityExpiryDate.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityExpiryDate").val());
			communityExpiryDate.val("");
			communityExpiryDate.focus();
			return false;
		}
		if (!isUnlimited && $.trim(communityExpiryDate.val()).length > 0 && !this.isValidDate($.trim(communityExpiryDate.val()), "after")) {
			alert($("#directory-updateCommunity-invalidCommunityExpiryDate").val());
			communityExpiryDate.focus();
			return false;
		}

		// check communityPhone
		var communityPhone = $("#directory-updateCommunity-communityPhone");
		if (this.stringByteSize(communityPhone.val()) > 40) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityPhone").val()).replace("{1}", 40));
			communityPhone.focus();
			return false;
		}

		// check communityFax
		var communityFax = $("#directory-updateCommunity-communityFax");
		if (this.stringByteSize(communityFax.val()) > 40) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityFax").val()).replace("{1}", 40));
			communityFax.focus();
			return false;
		}

		// check communityHomeUrl
		var communityHomeUrl = $("#directory-updateCommunity-communityHomeUrl");
		if (this.stringByteSize(communityHomeUrl.val()) > 200) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityHomeUrl").val()).replace("{1}", 200));
			communityHomeUrl.focus();
			return false;
		}
		
		// check communityEmail
		var communityEmail = $("#directory-updateCommunity-communityEmail");
		if (this.stringByteSize(communityEmail.val()) > 128) {
			alert($("#directory-maxLength-2").val().replace("{0}", $("#directory-communityEmail").val()).replace("{1}", 128));
			communityEmail.focus();
			return false;
		}
		if ($.trim(communityEmail.val()).length == 0) {
			alert($("#directory-updateCommunity-inputCommunityEmail").val());
			communityEmail.val("");
			communityEmail.focus();
			return false;
		}
		if ($.trim(communityEmail.val()).length > 0 && !this.isValidEmail(communityEmail.val())) {
			alert($("#directory-updateCommunity-invalidEmailError").val());
			communityEmail.focus();
			return false;
		}
		
		return true;
	},
	deleteCommunity : function(communityID) {
		if (!confirm($("#directory-deleteCommunity-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "deleteCommunity",
			communityID: communityID
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						if (result.errorMessage) {
							alert(result.errorMessage);
						} else {
							alert($("#directory-deleteCommunity-cannotDeleteInUse").val());
						}
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteCommunity-success").val());
					directory_orgMng.listCommunities();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listCommunityRequests : function(status) {
		directory_history.push(this.listCommunityRequests, this, [status]); // history push
		directory_orgMng_switchMenu("community");
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listCommunityRequests",
			status: status
		}, function() {
			if (typeof(directory_listCommunityRequests_onLoad) != "undefined") {
				directory_listCommunityRequests_onLoad();
			}
		});
	},
	viewCommunityRequest : function(communityRequestID) {
		directory_history.push(this.viewCommunityRequest, this, [communityRequestID]); // history push
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewCommunityRequest",
			communityRequestID: communityRequestID
		});
	},
	approveCommunityRequest : function(communityRequestID) {
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {acton: "approveCommunityRequest", communityRequestID: communityRequestID},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					alert(result.errorMessage);
				} else {
					alert($("#directory-approveCommunityRequest-success").val());
					$("#directory-workspace").empty();
					if (result.communityRequestID) {
						directory_orgMng.viewCommunityRequest(result.communityRequestID);
					} else {
						directory_orgMng.listCommunityRequests();
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	resetDeptTree : function(communityID) {
		if (!confirm($("#directory-resetDeptTree-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "resetDeptTree",
			communityID: communityID
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-resetDeptTree-success").val());
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	resetDirGroupTree : function(communityID) {
		if (!confirm($("#directory-resetDirGroupTree-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "resetDirGroupTree",
			communityID: communityID
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-resetDirGroupTree-success").val());
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
/* dirGroup : start */
	createDirGroupTree : function() {
		if ($("#directory-dirGroupMng-tree").length == 0) {
			return;
		}
		$("#directory-dirGroupMng-tree").directorytree({
			idPrefix: "dirGroup",
			checkbox: false,
			onActivate: function(dtnode) {
				var groupID = dtnode.data.key;
				var groupName = dtnode.data.title;
				
				if ($("#directory-moveDirGroup-targetGroupID").length > 0) {
					$("#directory-moveDirGroup-targetGroupID").val(groupID);
					$("#directory-moveDirGroup-targetGroupName").val(groupName);
				} else if ("dirGroup" == directory_dirGroupMng_menuType) {
					directory_orgMng.viewDirGroup(groupID);
				}
			},
			onLazyRead: function(dtnode) {
				directory_orgMng.expandDirGroupTree(dtnode);
			},
			init: function() {
				directory_orgMng.initDirGroupTree();
			}
		});
	},
	initDirGroupTree : function(isExpandAll) {
		$("#directory-dirGroupMng-tree").dynatree("getRoot").removeChildren();
		if (!$("#directory-dirGroupMng-hirID").val()) {
			if ("dirGroup" == directory_dirGroupMng_menuType) {
				directory_orgMng.viewDirGroup(null);
			}
			return;
		}
		$("#directory-dirGroupMng-tree").dynatree("getRoot").appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: { acton: "initDirGroupTree", hirID: $("#directory-dirGroupMng-hirID").val(), isExpandAll: isExpandAll },
			success: function(dtnode) {
				directory_orgMng.callbackDirGroup(dtnode);
				
				var isCallEmptyViewPage = true;
				
				for (var i = 0; i < dtnode.childList.length; i++) {
					if (dtnode.childList[i].data.isFolder) {
						dtnode.childList[i].activate(); // do activation
						isCallEmptyViewPage = false;
						break;
					}
				}
				if (isCallEmptyViewPage && "dirGroup" == directory_dirGroupMng_menuType) {
					directory_orgMng.viewDirGroup(null, $("#directory-dirGroupMng-hirID").val());
				}
			}
		});
	},
	closeAllDirGroupTree : function() {
		$("#directory-dirGroupMng-tree").dynatree("getRoot").visit(function(node) {
			//if (node.hasChildren()) node.expand(false);
			node.expand(false);
		});
	},
	expandDirGroupTree : function(dtnode) {
		dtnode.appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: { acton: "expandDirGroupTree", groupID: dtnode.data.key },
			success: function(dtnode) {
				directory_orgMng.callbackDirGroup(dtnode);
			}
		});
	},
	searchDirGroup : function() {
		var searchValue = $("#directory-dirGroupMng-searchValue");
		searchValue.val($.trim(searchValue.val())); // trim
		
		if (searchValue.val().length ==	0) {
			alert($("#directory-dirGroupMng-search-noneTerm").val());
			searchValue.focus();
			return false;
		}
		if (searchValue.val().length < 2) {
			alert($("#directory-dirGroupMng-search-minLength").val());
			searchValue.focus();
			return false;
		}
		if (!this.isValidCharacter(searchValue.val())) {
			alert($("#directory-dirGroupMng-search-invalidValue").val());
			searchValue.focus();
			return false;
		}
		$("#directory-dirGroupMng-tree").dynatree("getRoot").removeChildren();
		$("#directory-dirGroupMng-tree").dynatree("getRoot").appendAjax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			data: {
				acton: "searchDirGroup",
				searchValue: searchValue.val()
			},
			success: function(dtnode) {
				directory_orgMng.callbackDirGroup(dtnode);
			}
		});
		return true;
	},
	callbackDirGroup : function(dtnode) {
		dtnode.visit(function(node) {
			if (node.hasChildren()) node.expand(true);
		});
	},
	viewDirGroup : function(groupID, hirID) {
		directory_history.push(this.viewDirGroup, this, [groupID, hirID]); // history push
		directory_dirGroupMng_switchMenu("dirGroup");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewDirGroup",
			groupID: groupID,
			hirID: hirID || ""
		}, function() {
			if (typeof(directory_viewDirGroup_onLoad) != "undefined") {
				directory_viewDirGroup_onLoad();
				
				var tree = $("#directory-dirGroupMng-tree").dynatree("getTree");
				if (tree && tree.getNodeByKey) {
					var actnode = tree.getNodeByKey(groupID);
					if (actnode) actnode._activate(true, false); // not call onActivate()
				}
			}
		});
	},
	viewAddDirGroup : function(targetGroupID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddDirGroup",
			targetGroupID: targetGroupID
		}, function() {
			if (typeof(directory_addDirGroup_onLoad) != "undefined") {
				directory_addDirGroup_onLoad();
			}
		});
	},
	addDirGroup : function() {
		if (!this.addDirGroup_validate()) {
			return;
		}
		if (!confirm($("#directory-addDirGroup-confirm").val())) {
			return;
		}
		
		var memberIDs = "";
		$("#directory-addDirGroup-memberList").find("option").each(function() {
			memberIDs += $(this).val() + ";";
		});
		
		var data = {
			acton: "addDirGroup",
			groupName: $.trim($("#directory-addDirGroup-groupName").val()),
			memberIDs: memberIDs,
			targetGroupID: $("#directory-addDirGroup-targetGroupID").val(),
			movePosition: $("#directory-addDirGroup-movePosition").val()
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addDirGroup-dupGroupName").val().replace("{0}", $.trim($("#directory-addDirGroup-groupName").val())));
						$("#directory-addDirGroup-groupName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addDirGroup-added").val());
					
					if ($("#directory-dirGroupMng-backToTree").is(":visible")) {
						directory_orgMng.viewDirGroup(result.groupID); // Search state, the tree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDirGroupTree(); // tree reload
						// TODO : 초기화 후 추가된 그룹 선택
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addDirGroup_validate : function() {
		// check groupName
		var groupName = $("#directory-addDirGroup-groupName");
		if (this.stringByteSize(groupName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dirGroup-groupName").val()).replace("{1}", 20).replace("{2}", 60));
			groupName.focus();
			return false;
		}
		if ($.trim(groupName.val()).length == 0) {
			alert($("#directory-addDirGroup-inputGroupName").val());
			groupName.val("");
			groupName.focus();
			return false;
		}
		if (!this.isValidCharacter(groupName.val())) {
			alert($("#directory-addDirGroup-invalidCharacterError").val().replace("{0}", $("#directory-dirGroup-groupName").val()));
			groupName.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDirGroup : function(groupID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateDirGroup",
			groupID: groupID
		});
	},
	updateDirGroup : function(groupID) {
		if (!this.updateDirGroup_validate()) {
			return;
		}
		if (!confirm($("#directory-updateDirGroup-confirm").val())) {
			return;
		}
		
		var memberIDs = "";
		$("#directory-updateDirGroup-memberList").find("option").each(function() {
			memberIDs += $(this).val() + ";";
		});
		
		var data = {
			acton: "updateDirGroup",
			groupID: groupID,
			groupName: $.trim($("#directory-updateDirGroup-groupName").val()),
			groupStatus: $("#directory-updateDirGroup-groupStatus").val(),
			memberIDs: memberIDs
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateDirGroup-dupGroupName").val().replace("{0}", $.trim($("#directory-updateDirGroup-groupName").val())));
						$("#directory-updateDirGroup-groupName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDirGroup-updated").val());
					
					if ($("#directory-dirGroupMng-backToTree").is(":visible")) {
						directory_orgMng.viewDirGroup(groupID); // Search state, the tree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDirGroupTree(); // tree reload
						// TODO : 초기화 후 변경된 그룹 선택
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateDirGroup_validate : function() {
		// check groupName
		var groupName = $("#directory-updateDirGroup-groupName");
		if (this.stringByteSize(groupName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dirGroup-groupName").val()).replace("{1}", 20).replace("{2}", 60));
			groupName.focus();
			return false;
		}
		if ($.trim(groupName.val()).length == 0) {
			alert($("#directory-updateDirGroup-inputGroupName").val());
			groupName.val("");
			groupName.focus();
			return false;
		}
		if (!this.isValidCharacter(groupName.val())) {
			alert($("#directory-updateDirGroup-invalidCharacterError").val().replace("{0}", $("#directory-dirGroup-groupName").val()));
			groupName.focus();
			return false;
		}
		
		return true;
	},
	deleteDirGroup : function(groupID) {
		if (!confirm($("#directory-deleteDirGroup-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteDirGroup",
				groupID: groupID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteDirGroup-notDeleteGroupWithChild").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteDirGroup-deleted").val());
					directory_history.remove(); // history remove
					
					if ($("#directory-dirGroupMng-backToTree").is(":visible")) {
						directory_orgMng.viewDirGroup(result.groupID, result.hirID); // Search state, the tree does not reload.
					} else {
						$("#directory-workspace").empty();
						directory_orgMng.initDirGroupTree(); // tree reload
						// TODO : 초기화 후 그룹 선택
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	listDirGroupHir : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listDirGroupHir"
		}, function() {
			if (typeof(directory_listDirGroupHir_onLoad) != "undefined") {
				directory_listDirGroupHir_onLoad();
			}
		});
	},
	viewDirGroupHir : function(hirID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton:	"viewDirGroupHir",
			hirID: hirID
		});
	},
	viewAddDirGroupHir : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddDirGroupHir"
		}, function() {
			if (typeof(directory_addDirGroupHir_onLoad) != "undefined") {
				directory_addDirGroupHir_onLoad();
			}
		});
	},
	addDirGroupHir : function() {
		if (!this.addDirGroupHir_validate()) {
			return;
		}
		if (!confirm($("#directory-addDirGroupHir-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "addDirGroupHir",
			hirName: $.trim($("#directory-addDirGroupHir-hirName").val())
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-addDirGroupHir-dupHirName").val().replace("{0}", $.trim($("#directory-addDirGroupHir-hirName").val())));
						$("#directory-addDirGroupHir-hirName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addDirGroupHir-added").val());
					
					directory_orgMng.viewDirGroupHir(result.hirID);
					
					$("#directory-dirGroupMng-hirID").append("<option value='" + result.hirID + "'>" + $.trim($("#directory-addDirGroupHir-hirName").val()) + "</option>"); // select's option add
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addDirGroupHir_validate : function() {
		// check hirName
		var hirName = $("#directory-addDirGroupHir-hirName");
		if (this.stringByteSize(hirName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dirGroup-hirName").val()).replace("{1}", 20).replace("{2}", 60));
			hirName.focus();
			return false;
		}
		if ($.trim(hirName.val()).length == 0) {
			alert($("#directory-addDirGroupHir-inputHirName").val());
			hirName.val("");
			hirName.focus();
			return false;
		}
		if (!this.isValidCharacter(hirName.val())) {
			alert($("#directory-addDirGroupHir-invalidCharacterError").val().replace("{0}", $("#directory-dirGroup-hirName").val()));
			hirName.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDirGroupHir : function(hirID) {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateDirGroupHir",
			hirID: hirID
		});
	},
	updateDirGroupHir : function(hirID) {
		if (!this.updateDirGroupHir_validate()) {
			return;
		}
		if (!confirm($("#directory-updateDirGroupHir-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "updateDirGroupHir",
			hirID: hirID,
			hirName: $.trim($("#directory-updateDirGroupHir-hirName").val()),
			hirStatus: $("#directory-updateDirGroupHir-hirStatus").val()
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_NAME_ALREADY_EXIST:
						alert($("#directory-updateDirGroupHir-dupHirName").val().replace("{0}", $.trim($("#directory-updateDirGroupHir-hirName").val())));
						$("#directory-updateDirGroupHir-hirName").focus();
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDirGroupHir-updated").val());
					
					directory_orgMng.viewDirGroupHir(hirID);
					
					$("#directory-dirGroupMng-hirID option[value='" + hirID + "']").text($.trim($("#directory-updateDirGroupHir-hirName").val())); // select's option update
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	updateDirGroupHir_validate : function() {
		// check hirName
		var hirName = $("#directory-updateDirGroupHir-hirName");
		if (this.stringByteSize(hirName.val()) > 60) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-dirGroup-hirName").val()).replace("{1}", 20).replace("{2}", 60));
			hirName.focus();
			return false;
		}
		if ($.trim(hirName.val()).length == 0) {
			alert($("#directory-updateDirGroupHir-inputHirName").val());
			hirName.val("");
			hirName.focus();
			return false;
		}
		if (!this.isValidCharacter(hirName.val())) {
			alert($("#directory-updateDirGroupHir-invalidCharacterError").val().replace("{0}", $("#directory-dirGroup-hirName").val()));
			hirName.focus();
			return false;
		}
		
		return true;
	},
	viewUpdateDirGroupHirSeq : function() {
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewUpdateDirGroupHirSeq"
		});
	},
	updateDirGroupHirSeq : function() {
		var hirIDs = "";
		$("#directory-updateDirGroupHirSeq-hirList").find("option").each(function() {
			hirIDs += $(this).val() + ";";
		});
		
		if (!confirm($("#directory-updateDirGroupHirSeq-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "updateDirGroupHirSeq",
				hirIDs: hirIDs
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-updateDirGroupHirSeq-sequenceUpdated").val());
					directory_orgMng.listDirGroupHir(); // listDirGroupHir reload
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	deleteDirGroupHir : function(hirID) {
		if (!confirm($("#directory-deleteDirGroupHir-confirm").val())) {
			return;
		}
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "deleteDirGroupHir",
				hirID: hirID
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CANNOT_DELETE_IN_USE:
						alert($("#directory-deleteDirGroupHir-notDeleteHirWithChild").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-deleteDirGroupHir-deleted").val());
					
					directory_orgMng.listDirGroupHir(); // listDirGroupHir reload
					
					var preSelectedHirID = $("#directory-dirGroupMng-hirID").val();
					$("#directory-dirGroupMng-hirID option[value='" + hirID + "']").remove(); // select's option remove
					
					if (preSelectedHirID == hirID && !$("#directory-dirGroupMng-backToTree").is(":visible")) {
						directory_orgMng.initDirGroupTree(); // tree reload
					}
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
/* dirGroup : end */
	viewAddExternalUser : function(communityID) {
		if ($("#directory-addExternalUser-dialog").length < 1) {
			$("body").append($("<div id='directory-addExternalUser-dialog'></div>"));
		}
		
		$("#directory-addExternalUser-dialog").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "viewAddExternalUser",
			communityID: communityID,	// required
			display: "",				// optional (default: "") - "empCode, rank, loginID"
			required: ""				// optional (default: "") - "empCode, loginID, email, phone"
		}, function() {
			$("#directory-addExternalUser-dialog").dialog({
				title: $("#directory-addExternalUser-title").val(),
				width: 500,
				modal: true,
				resizable: false,
				close: function() {
					$(this).dialog("destroy");
				}
			});
			
			if (typeof(directory_addExternalUser_onLoad) != "undefined") {
				directory_addExternalUser_onLoad();
			}
		});
	},
	addExternalUser : function() {
		var deptID = $("#directory-addExternalUser-deptID").val();
		if (!this.addExternalUser_validate()) {
			return;
		}
		if (!confirm($("#directory-addExternalUser-confirm").val())) {
			return;
		}
		
		var data = {
			acton: "addExternalUser",
			communityID: $.trim($("#directory-addExternalUser-communityID").val()),
			deptID: $.trim($("#directory-addExternalUser-deptID").val()),
			userName: $.trim($("#directory-addExternalUser-userName").val()),
			userNameEng: $.trim($("#directory-addExternalUser-userNameEng").val()) || "",
			empCode: $.trim($("#directory-addExternalUser-empCode").val()),
			positionID: $("#directory-addExternalUser-positionID").val(),
			rankID: $("#directory-addExternalUser-rankID").val() || "",
			dutyID: $("#directory-addExternalUser-dutyID").val() || "",
			secLevel: $.trim($("#directory-addExternalUser-secLevel").val()),
			loginID: $.trim($("#directory-addExternalUser-loginID").val()),
			loginPassword: $("#directory-addExternalUser-loginPassword").val(),
			email: $.trim($("#directory-addExternalUser-email").val()),
			phone: $.trim($("#directory-addExternalUser-phone").val()),
			mobilePhone: $.trim($("#directory-addExternalUser-mobilePhone").val()),
			fax: $.trim($("#directory-addExternalUser-fax").val()),
			phoneRuleID: $.trim($("#directory-addExternalUser-phoneRuleID").val()) || "",
			extPhone: $.trim($("#directory-addExternalUser-extPhone").val()) || "",
			extPhoneHead: $.trim($("#directory-addExternalUser-extPhoneHead").val()) || "",
			extPhoneExch: $.trim($("#directory-addExternalUser-extPhoneExch").val()) || "",
			phyPhone: $.trim($("#directory-addExternalUser-phyPhone").val()) || "",
			fwdPhone: $.trim($("#directory-addExternalUser-fwdPhone").val()) || ""
		};
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: data,
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.ORG_MNG_CODE_ALREADY_EXIST:
						alert($("#directory-addExternalUser-dupEmpCode").val().replace("{0}", $.trim($("#directory-addExternalUser-empCode").val())));
						$("#directory-addExternalUser-empCode").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_LOGIN_ID_ALREADY_EXIST:
						alert($("#directory-addExternalUser-dupLoginID").val().replace("{0}", $.trim($("#directory-addExternalUser-loginID").val())));
						$("#directory-addExternalUser-loginID").focus();
						break;
					case directory_orgErrorCode.ORG_MNG_EMAIL_ALREADY_EXIST:
						alert($("#directory-addExternalUser-dupEmail").val().replace("{0}", $.trim($("#directory-addExternalUser-email").val())));
						$("#directory-addExternalUser-email").focus();
						break;
					case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
						alert($("#directory-addExternalUser-notAuthorizedUser").val());
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-addExternalUser-userAdded").val());
					directory_orgMng.closeExternalUser();
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	addExternalUser_validate : function() {
		var required = $("#directory-addExternalUser-required").val(); // required option
		
		// check userName
		var userName = $("#directory-addExternalUser-userName");
		if (this.stringByteSize(userName.val()) > 120) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-userName").val()).replace("{1}", 40).replace("{2}", 120));
			userName.focus();
			return false;
		}
		if ($.trim(userName.val()).length == 0) {
			alert($("#directory-addExternalUser-inputUserName").val());
			userName.val("");
			userName.focus();
			return false;
		}
		if (!this.isValidCharacter(userName.val())) {
			alert($("#directory-addExternalUser-invalidCharacterError").val().replace("{0}", $("#directory-userName").val()));
			userName.focus();
			return false;
		}
		
		// check userNameEng
		var userNameEng = $("#directory-addExternalUser-userNameEng");
		if (userNameEng.val() !== undefined) {
			if (this.stringByteSize(userNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-userNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				userNameEng.focus();
				return false;
			}
			if (!this.isValidCharacter(userNameEng.val())) {
				alert($("#directory-addExternalUser-invalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
				userNameEng.focus();
				return false;
			}
		}
		
		// check empCode
		var empCode = $("#directory-addExternalUser-empCode");
		if (this.stringByteSize(empCode.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-empCode").val()).replace("{1}", 13).replace("{2}", 40));
			empCode.focus();
			return false;
		}
		if (required.indexOf("empCode") > -1 && $.trim(empCode.val()).length == 0) {
			alert($("#directory-addExternalUser-inputEmpCode").val());
			empCode.val("");
			empCode.focus();
			return false;
		}
		
		// check positionID
		var positionID = $("#directory-addExternalUser-positionID");
		if (positionID.val().length == 0) {
			alert($("#directory-addExternalUser-selectPosition").val());
			positionID.focus();
			return false;
		}
		
		// check secLevel
		var secLevel = $("#directory-addExternalUser-secLevel");
		if (!this.isValidNumber($.trim(secLevel.val())) || $.trim(secLevel.val()) < 0 || $.trim(secLevel.val()) > 99) {
			alert($("#directory-addExternalUser-invalidSecLevel").val());
			secLevel.focus();
			return false;
		}
		
		// check loginID
		var loginID = $("#directory-addExternalUser-loginID");
		if (this.stringByteSize(loginID.val()) > 20) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-loginID").val()).replace("{1}", 6).replace("{2}", 20));
			loginID.focus();
			return false;
		}
		if (required.indexOf("loginID") > -1 && $.trim(loginID.val()).length == 0) {
			alert($("#directory-addExternalUser-inputLoginID").val());
			loginID.val("");
			loginID.focus();
			return false;
		}
		
		// check loginPassword
		var loginPassword = $("#directory-addExternalUser-loginPassword");
		var loginPasswordConfirm = $("#directory-addExternalUser-loginPasswordConfirm");
		if ($("input[name='directory-addExternalUser-loginPassword-assign']:checked").val() == "1") {
			if (this.stringByteSize(loginPassword.val()) > 15) {
				alert($("#directory-maxLength2").val().replace("{0}", $("#directory-loginPassword").val()).replace("{1}", 15));
				loginPassword.focus();
				return false;
			}
			if (loginPassword.val().length == 0) {
				alert($("#directory-addExternalUser-inputLoginPassword").val());
				loginPassword.focus();
				return false;
			}
			if (loginPasswordConfirm.val().length == 0) {
				alert($("#directory-addExternalUser-inputLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
			if (loginPassword.val() != loginPasswordConfirm.val()) {
				alert($("#directory-addExternalUser-incorrectLoginPasswordConfirm").val());
				loginPasswordConfirm.focus();
				return false;
			}
		} else {
			loginPassword.val("");
			loginPasswordConfirm.val("");
		}
		
		// check email
		var email = $("#directory-addExternalUser-email");
		if (this.stringByteSize(email.val()) > 128) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-email").val()).replace("{1}", 42).replace("{2}", 128));
			email.focus();
			return false;
		}
		if (($("#directory-addExternalUser-isEmailRequired").val() == "true" || required.indexOf("email") > -1)
				&& $.trim(email.val()).length == 0) {
			alert($("#directory-addExternalUser-invalidEmailError").val());
			email.val("");
			email.focus();
			return false;
		}
		if ($.trim(email.val()).length > 0 && !this.isValidEmail(email.val())) {
			alert($("#directory-addExternalUser-invalidEmailError").val());
			email.focus();
			return false;
		}
		
		// check phone
		var phone = $("#directory-addExternalUser-phone");
		if (this.stringByteSize(phone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-phone").val()).replace("{1}", 13).replace("{2}", 40));
			phone.focus();
			return false;
		}
		if (required.indexOf("phone") > -1 && $.trim(phone.val()).length == 0) {
			alert($("#directory-addExternalUser-inputPhone").val());
			phone.val("");
			phone.focus();
			return false;
		}
		if (!this.isValidCharacter(phone.val(), 1)) {
			alert($("#directory-addExternalUser-invalidCharacterError-1").val().replace("{0}", $("#directory-phone").val()));
			phone.focus();
			return false;
		}
		
		// check mobilePhone
		var mobilePhone = $("#directory-addExternalUser-mobilePhone");
		if (this.stringByteSize(mobilePhone.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-mobilePhone").val()).replace("{1}", 13).replace("{2}", 40));
			mobilePhone.focus();
			return false;
		}
		if (!this.isValidCharacter(mobilePhone.val(), 1)) {
			alert($("#directory-addExternalUser-invalidCharacterError-1").val().replace("{0}", $("#directory-mobilePhone").val()));
			mobilePhone.focus();
			return false;
		}
		
		// check fax
		var fax = $("#directory-addExternalUser-fax");
		if (this.stringByteSize(fax.val()) > 40) {
			alert($("#directory-maxLength").val().replace("{0}", $("#directory-fax").val()).replace("{1}", 13).replace("{2}", 40));
			fax.focus();
			return false;
		}
		if (!this.isValidCharacter(fax.val(), 1)) {
			alert($("#directory-addExternalUser-invalidCharacterError-1").val().replace("{0}", $("#directory-fax").val()));
			fax.focus();
			return false;
		}
		
		return true;
	},
	closeExternalUser : function() {
		if ($("#directory-addExternalUser-dialog").length > 0) {
			$("#directory-addExternalUser-dialog").dialog("close");
		} else {
			window.close();
		}
	},
	listExternalUsers : function(deptID, searchType, searchValue, orderField, orderType, currentPage) {
		orgMngDebg("listExternalUsers 1 deptID["+deptID+"],searchType["+searchType+"], searchValue["+searchValue+"], orderField["+orderField+"], orderType["+orderType+"], currentPage["+currentPage+"]");
		var searchType = searchType ? searchType : $("#directory-listExternalUsers-searchType").length < 1 ? "" : $("#directory-listExternalUsers-searchType").val();
		var searchValue = searchValue ? searchValue : $("#directory-listExternalUsers-searchValue").length < 1 ? "" : $("#directory-listExternalUsers-searchValue").val();
		if(!searchType && searchType == 'status'){
			searchValue = $("#directory-listExternalUsers-searchValue-status").length > 0 ? $("#directory-listExternalUsers-searchValue-status").val() : "";
		}
		var orderField = orderField ? orderField : $("#directory-listExternalUsers-orderField").length < 1 ? "" : $("#directory-listExternalUsers-orderField").val();
		var orderType = orderType ? orderType : $("#directory-listExternalUsers-orderType").length < 1 ? "" : $("#directory-listExternalUsers-orderType").val();
		var currentPage = currentPage ? currentPage : $("#directory-listExternalUsers-currentPage").length < 1 ? "" : $("#directory-listExternalUsers-currentPage").val();
		if(!searchValue){
			searchType = "";
		}
		orgMngDebg("listExternalUsers 2 deptID["+deptID+"],searchType["+searchType+"], searchValue["+searchValue+"], orderField["+orderField+"], orderType["+orderType+"], currentPage["+currentPage+"]");
		
		directory_history.removeAll(); // history remove all
		directory_history.push(this.listExternalUsers, this, [deptID, searchType, searchValue, orderField, orderType, currentPage]); // history push
		directory_orgMng_switchMenu("externalUser");
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/orgMng.do", {
			acton: "listExternalUsers",
			display: $("#directory-display").val(),
			deptID: deptID,
			currentPage: currentPage,
			orderField: orderField,
			orderType: orderType,
			searchType: searchType,
			searchValue: searchValue
		}, function() {
			if (typeof(directory_listExternalUsers_onLoad) != "undefined") {
				directory_listExternalUsers_onLoad();
			}
		});
	},
	confirmExternalUsers : function(deptID) {
		
		var userIDs = "";
		$("input[name='directory-listExternalUsers-check']").each(function() {
			if ($(this).is(":checked")) {
				userIDs += $(this).val() + ";";
			}
		});
		
		if ($.trim(userIDs).length == 0) {
			alert($("#directory-listExternalUsers-selectItem").val());
			return;
		}		

		if (!confirm($("#directory-listExternalUsers-confirm").val())) {
			return;
		}	
		var searchType = $("#directory-listExternalUsers-searchType").length > 0 ? $("#directory-listExternalUsers-searchType").val() : "";
		var searchValue = $("#directory-listExternalUsers-searchValue").length > 0 ? $("#directory-listExternalUsers-searchValue").val() : "";
		if(searchType == 'status'){
			searchValue = $("#directory-listExternalUsers-searchValue-status").length > 0 ? $("#directory-listExternalUsers-searchValue-status").val() : "";
		}
		var orderField = $("#directory-listExternalUsers-orderField").length > 0 ? $("#directory-listExternalUsers-orderField").val() : "";
		var orderType = $("#directory-listExternalUsers-orderType").length > 0 ? $("#directory-listExternalUsers-orderType").val() : "";
		var currentPage = ($("#directory-listExternalUsers-currentPage").length > 0) ? $("#directory-listExternalUsers-currentPage").val() : 1;
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "confirmExternalUsers",
				userIDs: userIDs,
				currentPage: $("#directory-listExternalUsers-currentPage").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listExternalUsers-confirmed").val());
					directory_orgMng.listExternalUsers(deptID, searchType, searchValue, orderField, orderType, currentPage);
								
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	rejectExternalUsers : function(deptID) {
		
		var userIDs = "";
		$("input[name='directory-listExternalUsers-check']").each(function() {
			if ($(this).is(":checked")) {
				userIDs += $(this).val() + ";";
			}
		});
		
		if ($.trim(userIDs).length == 0) {
			alert($("#directory-listExternalUsers-selectItem").val());
			return;
		}		

		if (!confirm($("#directory-listExternalUsers-reject").val())) {
			return;
		}	
		
		var searchType = $("#directory-listExternalUsers-searchType").length > 0 ? $("#directory-listExternalUsers-searchType").val() : "";
		var searchValue = $("#directory-listExternalUsers-searchValue").length > 0 ? $("#directory-listExternalUsers-searchValue").val() : "";
		if(searchType == 'status'){
			searchValue = $("#directory-listExternalUsers-searchValue-status").length > 0 ? $("#directory-listExternalUsers-searchValue-status").val() : "";
		}
		var orderField = $("#directory-listExternalUsers-orderField").length > 0 ? $("#directory-listExternalUsers-orderField").val() : "";
		var orderType = $("#directory-listExternalUsers-orderType").length > 0 ? $("#directory-listExternalUsers-orderType").val() : "";
		var currentPage = ($("#directory-listExternalUsers-currentPage").length > 0) ? $("#directory-listExternalUsers-currentPage").val() : 1;
		
		$.ajax({
			url: DIRECTORY_CONTEXT + "/orgMng.do",
			type: "post",
			async: false,
			dataType: "json",
			data: {
				acton: "rejectExternalUsers",
				userIDs: userIDs,
				currentPage: $("#directory-listExternalUsers-currentPage").val()
			},
			success: function(result, status) {
				if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
					switch (result.errorCode) {
					case directory_orgErrorCode.FAILURE_FAILURE:
						alert(result.errorMessage);
						break;
					default:
						alert(result.errorMessage);
					}
				} else {
					alert($("#directory-listExternalUsers-rejected").val());
					directory_orgMng.listExternalUsers(deptID, searchType, searchValue, orderField, orderType, currentPage);
								
				}
			},
			error: function(result, status) {
				alert("ERROR : " + status);
			}
		});
	},
	
	charByteSize : function(ch) {
		if (ch == null || ch.length == 0) {
			return 0;
		}
		
		var charCode = ch.charCodeAt(0);

		if (charCode <= 0x00007F) {
			return 1;
		} else if (charCode <= 0x0007FF) {
			return 2;
		} else if (charCode <= 0x00FFFF) {
			return 3;
		} else {
			return 4;
		}
	},
	stringByteSize : function(str) {
		if (str == null || str.length == 0) {
			return 0;
		}
		
		var size = 0;
		for (var i = 0; i < str.length; i++) {
			size += this.charByteSize(str.charAt(i));
		}
		
		return size;
	},
	isValidCharacter : function(str, type) {
//		if (type)
//			return (str.search("[(<!#$%*\',:\";@^\\\\>&)]") == -1) // !@#$%^&*()\[];:'",<>
//		else
//			return (str.search("[(<!#$%*\'.,:\";@^+\\\\>&)]") == -1) // !@#$%^&*()+\[];:'",.<>
		
		// added ~`=|?
		if (type == 1) {
			// usable _-{}/.+
			return !/.*[\~`!@#$%\^&\*()=\|\\\[\];:'",<>?].*/.test(str); // ~`!@#$%^&*()=|\[];:'",<>?
		} else if (type == 2){ // for deptname
			// usable ()
			return !/.*[\~`!@#$%\^&\*+=\|\\\[\];:'",.<>?].*/.test(str); // ~`!@#$%^&*+=|\[];:'",.<>?
		} else if (type == 3){ // fro username
			// usable .
			return !/.*[\~`!@#$%\^&\*()+=\|\\\[\];:'",<>?].*/.test(str); // ~`!@#$%^&*()+=|\[];:'",<>?
		} else {
			// usable _-{}/
			return !/.*[\~`!@#$%\^&\*()+=\|\\\[\];:'",.<>?].*/.test(str); // ~`!@#$%^&*()+=|\[];:'",.<>?
		}
	},
	isValidEmail : function(str) {
		return /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(str);
	},
	isValidNumber : function(str) {
		return /^[0-9]+$/.test(str);
	},
	isValidDate : function(str, flag) {
		var arr = str.split(".");
		if (arr.length != 3)
			return false;
		var year = arr[0];
		var month = arr[1];
		var date = arr[2];
		if (year > 1900 && year < 3000 && month > 0 && month < 13 && date > 0 && date < 32) {
			if (flag == "after") {
				var inputDate = new Date();
				inputDate.setFullYear(year, month - 1, date);
				return inputDate.getTime() > new Date().getTime();
			}
			return true;
		} else {
			return false;
		}
	},
	isValidBatchFile: function(str) {
		return ( $.trim(str).length > 0)
				&& (str.toLowerCase().indexOf('.csv') != -1);
	},
	isValidAlphaNum: function(str, pattern) {
		if (pattern) {
			return (new RegExp("^[a-zA-Z0-9" + pattern + "]+$")).test(str);
		} else {
			return /^[a-zA-Z0-9]+$/.test(str);
		}
	}
};