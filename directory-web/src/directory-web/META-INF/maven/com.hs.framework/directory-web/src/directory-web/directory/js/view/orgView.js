var DIRECTORY_CONTEXT = "/directory-web";

function orgViewDebg(msg){
	if (true) { // false -> TEST
		return;
	}
	if(window.console && window.console.debug){
		window.console.debug(msg);
	}else if(window.console && window.console.log){
		window.console.log(msg);
	}
}

var directory_orgView = {
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
				
				directory_orgView_callMethod(deptID);
			},
			onLazyRead: function(dtnode) {
				directory_orgView.expandDeptTree(dtnode);
			},
			init: function() {
				directory_orgView.initDeptTree($("#directory-baseDept").val(), true);
			}
		});
	},
	initDeptTree : function(baseDept, isActivate, isExpandAll) {
		$("#directory-deptTree").dynatree("getRoot").removeChildren();
		$("#directory-deptTree").dynatree("getRoot").appendAjax({
			url: DIRECTORY_CONTEXT + "/org.do",
			type: "post",
			data: { acton: "initOrgTree", baseDept: baseDept, isExpandAll: isExpandAll },
			success: function(dtnode) {
				directory_orgView.callbackDept(dtnode);
				
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
				if (actnode && isActivate) {
					actnode.activate();
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
			url: DIRECTORY_CONTEXT + "/org.do",
			type: "post",
			data: { acton: "expandOrgTree", deptID: dtnode.data.key },
			success: function(dtnode) {
				directory_orgView.callbackDept(dtnode);
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
			url: DIRECTORY_CONTEXT + "/org.do",
			type: "post",
			data: {
				acton: "searchDept",
				searchValue: searchValue.val()
			},
			success: function(dtnode) {
				directory_orgView.callbackDept(dtnode);
			}
		});
		return true;
	},
	callbackDept : function(dtnode) {
		//dtnode.visit(function(node) {
		//	if (node.hasChildren()) node.expand(true);
		//});
	},
	listUsers : function(deptID) {
		
		var currentPage = ($("#directory-listUsers-currentPage").length > 0) ? $("#directory-listUsers-currentPage").val() : 1;
		
		var listType = ($("#directory-listUsers-listType").length > 0) ? $("#directory-listUsers-listType").val() : "normalList";
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "userList",
			viewName: "view/listUsers",
			display: $("#directory-display").val(),
			useAbsent: $("#directory-useAbsent").val(),
			deptID: deptID,
			currentPage: currentPage,
			orderField: $("#directory-listUsers-orderField").val(),
			orderType: $("#directory-listUsers-orderType").val(),
			searchType: $("#directory-listUsers-searchType").val(),
			searchValue: $("#directory-listUsers-searchValue").val(),
			listType: listType
		}, function() {
			if (typeof(directory_listUsers_onLoad) != "undefined") {
				directory_listUsers_onLoad();
			}
			
			var title = null;
			if (listType == "searchList") {
				title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listUsers-userCount").val() + ")";
			} else {
				title = $("#directory-listUsers-deptName").val() + " (" + $("#directory-listUsers-userCount").val() + ")";
				title = "<a href=\"#\" onclick=\"javascript:directory_orgView.viewDeptSpec('" + $("#directory-listUsers-deptID").val() + "');\">" + title + "</a>";
			}
			$("#directory-orgView-title").html(title);
		});
	},
	searchUser : function(searchType, searchValue) {
		searchValue = $.trim(searchValue); // trim
		
		if (searchType && searchValue.length == 0) {
			alert($("#directory-listSearch-noneTerm").val());
			$("#directory-listSearch-searchValue").val("");
			$("#directory-listSearch-searchValue").focus();
			return false;
		}
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "searchUser",
			viewName: "view/listUsers",
			display: $("#directory-display").val(),
			useAbsent: $("#directory-useAbsent").val(),
			searchType: searchType,
			searchValue: searchValue,
			listType: "searchList"
		}, function() {
			if (typeof(directory_listUsers_onLoad) != "undefined") {
				directory_listUsers_onLoad();
			}
			
			var title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listUsers-userCount").val() + ")";
			$("#directory-orgView-title").html(title);
		});
	},
	listAbsentUsers : function(deptID) {
		
		var currentPage = ($("#directory-listAbsentUsers-currentPage").length > 0) ? $("#directory-listAbsentUsers-currentPage").val() : 1;
		
		var listType = $("#directory-listAbsentUsers-listType").val();
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "absentUserList",
			viewName: "view/listAbsentUsers",
			deptID: deptID,
			currentPage: currentPage,
			orderField: $("#directory-listAbsentUsers-orderField").val(),
			orderType: $("#directory-listAbsentUsers-orderType").val(),
			searchType: $("#directory-listAbsentUsers-searchType").val(),
			searchValue: $("#directory-listAbsentUsers-searchValue").val(),
			listType: listType
		}, function() {
			if (typeof(directory_listAbsentUsers_onLoad) != "undefined") {
				directory_listAbsentUsers_onLoad();
			}
			
			var title = null;
			if (listType == "searchList") {
				title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listAbsentUsers-userCount").val() + ")";
			} else {
				title = $("#directory-listAbsentUsers-deptName").val() + " (" + $("#directory-listAbsentUsers-userCount").val() + ")";
				title = "<a href=\"#\" onclick=\"javascript:directory_orgView.viewDeptSpec('" + $("#directory-listAbsentUsers-deptID").val() + "');\">" + title + "</a>";
			}
			$("#directory-orgView-title").html(title);
		});
	},
	searchAbsentUser : function(searchType, searchValue) {
		searchValue = $.trim(searchValue); // trim
		
		if (searchType && searchValue.length == 0) {
			alert($("#directory-listSearch-noneTerm").val());
			$("#directory-listSearch-searchValue").val("");
			$("#directory-listSearch-searchValue").focus();
			return false;
		}
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "searchAbsentUser",
			viewName: "view/listAbsentUsers",
			searchType: searchType,
			searchValue: searchValue,
			listType: "searchList"
		}, function() {
			if (typeof(directory_listAbsentUsers_onLoad) != "undefined") {
				directory_listAbsentUsers_onLoad();
			}
			
			var title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listAbsentUsers-userCount").val() + ")";
			$("#directory-orgView-title").html(title);
		});
	},
	listLoginUsers : function(deptID) {
		
		var currentPage = ($("#directory-listLoginUsers-currentPage").length > 0) ? $("#directory-listLoginUsers-currentPage").val() : 1;
		
		var listType = $("#directory-listLoginUsers-listType").val();
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "loginUserList",
			viewName: "view/listLoginUsers",
			display: $("#directory-display").val(),
			deptID: deptID,
			currentPage: currentPage,
			orderField: $("#directory-listLoginUsers-orderField").val(),
			orderType: $("#directory-listLoginUsers-orderType").val(),
			searchType: $("#directory-listLoginUsers-searchType").val(),
			searchValue: $("#directory-listLoginUsers-searchValue").val(),
			listType: listType
		}, function() {
			if (typeof(directory_listLoginUsers_onLoad) != "undefined") {
				directory_listLoginUsers_onLoad();
			}
			
			var title = null;
			if (listType == "searchList") {
				title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listLoginUsers-userCount").val() + ")";
			} else {
				title = $("#directory-listLoginUsers-deptName").val() + " (" + $("#directory-listLoginUsers-userCount").val() + ")";
				title = "<a href=\"#\" onclick=\"javascript:directory_orgView.viewDeptSpec('" + $("#directory-listLoginUsers-deptID").val() + "');\">" + title + "</a>";
			}
			$("#directory-orgView-title").html(title);
		});
	},
	searchLoginUser : function(searchType, searchValue) {
		searchValue = $.trim(searchValue); // trim
		
		if (searchType && searchValue.length == 0) {
			alert($("#directory-listSearch-noneTerm").val());
			$("#directory-listSearch-searchValue").val("");
			$("#directory-listSearch-searchValue").focus();
			return false;
		}
		
		$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
			acton: "searchLoginUser",
			viewName: "view/listLoginUsers",
			searchType: searchType,
			searchValue: searchValue,
			listType: "searchList"			
		}, function() {
			if (typeof(directory_listLoginUsers_onLoad) != "undefined") {
				directory_listLoginUsers_onLoad();
			}
			
			var title = $("#directory-listSearch-allDept").val() + " (" + $("#directory-listLoginUsers-userCount").val() + ")";
			$("#directory-orgView-title").html(title);
		});
	},
	viewUserSpec : function(userID) {
		$.ajax({
			url: DIRECTORY_CONTEXT + "/org.do",
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
	viewDeptSpec : function(deptID) {
		$.ajax({
			url: DIRECTORY_CONTEXT + "/org.do",
			data: {
				acton: "viewDeptSpec",
				deptID: deptID
			},
			success: function(html) {
				directory_divPopup.open(html);
			}
		});
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
		} else {
			// usable _-{}/
			return !/.*[\~`!@#$%\^&\*()+=\|\\\[\];:'",.<>?].*/.test(str); // ~`!@#$%^&*()+=|\[];:'",.<>?
		}
	}
};