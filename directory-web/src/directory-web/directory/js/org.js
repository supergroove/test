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
	ORG_NOT_SUPPORT_FILE		: 5010,
	
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

function orgDebug(msg) {
	if (true) { // false -> TEST
		return;
	}
	if (window.console && window.console.debug) {
		window.console.debug(msg);
	} else if (window.console && window.console.log) {
		window.console.log(msg);
	}
}

var directory_org = {
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
		} else if (type == 3){ // fro username
			// usable .
			return !/.*[\~`!@#$%\^&\*()+=\|\\\[\];:'",<>?].*/.test(str); // ~`!@#$%^&*()+=|\[];:'",<>?
		} else {
			// usable _-{}/
			return !/.*[\~`!@#$%\^&\*()+=\|\\\[\];:'",.<>?].*/.test(str); // ~`!@#$%^&*()+=|\[];:'",.<>?
		}
	}
};

/**
 * ex) viewChangePasswordDialog(userKey);
 */
function viewChangePasswordDialog(userKey, context) {
	userKey = userKey || "";
	context = context || "/directory-web";
	
	if ($("#directory-changePassword-dialog").length < 1) {
		$("body").append($("<div id='directory-changePassword-dialog'></div>"));
	}
	
	$("#directory-changePassword-dialog").load(context + "/org.do", {
		acton: "viewChangePassword",
		K: userKey,
		isDialog: true
	}, function() {
		$("#directory-changePassword-dialog").dialog({
			title: $("#directory-changePassword-title").val(),
			width: 300,
			modal: true,
			resizable: false,
			close: function() {
				$(this).dialog("destroy");
			}
		});
		
		if (typeof(directory_changePassword_onLoad) != "undefined") {
			directory_changePassword_onLoad();
		}
	});
}

/**
 * ex) directoryLogout({
 *         context: "",
 *         logoutCallback: function() {}
 *     });
 */
function directoryLogout(initial) {
	directoryLogoutSettings = $.extend({
		context: "/directory-web",
		logoutCallback: function() {
			window.location = this.context + "/directory/test.jsp";
		}
	}, initial || {});
	$.ajax({
		url: directoryLogoutSettings.context + "/org.do",
		type: "post",
		async: false,
		dataType: "json",
		data: {
			acton: "logout"
		},
		success: function(result, status) {
			directoryLogoutSettings.logoutCallback();
		},
		error: function(jqXHR, status, error) {
			alert(status + " : " + error);
		}
	});
}

var publicKeyModulus = false;
var publicKeyExponent = false;
function directoryGenerateKeyPairs(initial){
	var directoryGenerateKeyPairsSettings = {context: initial && initial.context ? initial.context : "/directory-web",
												communityID: initial && initial.communityID ? initial.communityID : "001000000",
												successCallback: initial && initial.successCallback ? initial.successCallback : 
																			function(publicKey, exponent){
																				orgDebug("publicKey["+data.publicKey+ ", exponent["+exponent+"]");
																				publicKeyModulus = publicKey ? publicKey : false;
																				publicKeyExponent = exponent ? exponent : false;
																				orgDebug("publicKeyModulus["+publicKeyModulus+"], publicKeyExponent["+publicKeyExponent+"]");
																			},
												failCallback: initial && initial.failCallback ? initial.failCallback : 
																			function(msg, errorCode){
																				if(msg) alert(msg);
																			}
	};
	
	var data = {
			acton: "generateKeyPairs",
			communityID: directoryGenerateKeyPairsSettings.communityID,
			FRAMEWORK_DIRECTORY_LOCALE: $("#directory-lang").val()
		};
	$.ajax({
		url: directoryGenerateKeyPairsSettings.context + "/org.do",
		type: "post",
		async: false,
		dataType: "json",
		data: data,
		success: function(result, status) {
			if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
				directoryGenerateKeyPairsSettings.failCallback(result.errorMessage, result.errorCode);
			}else{
				directoryGenerateKeyPairsSettings.successCallback(result.publicKey, result.exponent);
			}
		},
		error: function(jqXHR, status, error) {
			alert(status + " : " + error);
		}
	});
}

(function($){
	$.fn.directoryLogin = function(initial)
	{
		directoryLoginSettings = $.extend(
						{
							context: "/directory-web",
							communityID: "001000000",
							loginType: "name",
							checkDupLogin: "0", // "0": false, "1": true
							loginSuccessCallback: function(K){
								window.location = this.context+"/directory/org.do?acton=main&K="+K;
							},
							loginFailCallback: function(message){
								alert(message);
							},
							publicKeyModulus : false,
							publicKeyExponent : false,
							cryptedParam : ""
						}, 
						initial||{}
					);
		directoryLoginSettings.debug = function(obj) {
			if (window.console && window.console.log) {
				window.console.log(obj);
			}
		}
		directoryLoginSettings.debug("publicKeyModulus["+publicKeyModulus+"], publicKeyExponent["+publicKeyExponent+"]");
		if(publicKeyModulus && publicKeyExponent){
			directoryLoginSettings.publicKeyModulus = publicKeyModulus;
			directoryLoginSettings.publicKeyExponent = publicKeyExponent;
		}
		directoryLoginSettings.debug("directoryLoginSettings.publicKeyModulus["+directoryLoginSettings.publicKeyModulus+"], directoryLoginSettings.publicKeyExponent["+directoryLoginSettings.publicKeyExponent+"]");
		
		directoryLoginSettings.encryptParameter = function(key, value){
			if(directoryLoginSettings.publicKeyModulus && directoryLoginSettings.publicKeyExponent && typeof("RSAKey") != 'undefined'){
			    var rsa = new RSAKey();
			    rsa.setPublic(directoryLoginSettings.publicKeyModulus, directoryLoginSettings.publicKeyExponent);
			    directoryLoginSettings.cryptedParam = typeof(directoryLoginSettings.cryptedParam) != 'undefined' && directoryLoginSettings.cryptedParam.length > 0 ? directoryLoginSettings.cryptedParam + "," + key : key;
				return rsa.encrypt(value);
			}
			directoryLoginSettings.cryptedParam = "";
			return password;
		}
		
		var that = this;
		
		directoryLoginSettings.login = function()
		{
			var loginName = $("#directory-login-name").val();
			var password = $("#directory-login-password").val();
			
			var loginByEmpcode = $("#directory-login-empcode").attr("checked");
			directoryLoginSettings.cryptedParam = "";
			var data = {
				acton: "login",
				communityID: directoryLoginSettings.communityID,
				loginName: directoryLoginSettings.encryptParameter("loginName", loginName),
				password: directoryLoginSettings.encryptParameter("password", password),
				cryptedParam : directoryLoginSettings.cryptedParam,
				loginType: loginByEmpcode ? "empcode" : directoryLoginSettings.loginType,
				checkDupLogin: directoryLoginSettings.checkDupLogin,
				FRAMEWORK_DIRECTORY_LOCALE: $("#directory-lang").val()
			};
			orgDebug("login :"+data.loginName+","+data.password+","+data.loginType);
			$.ajax({
				url: directoryLoginSettings.context + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
                    directoryLoginSettings.processLoginCallback(result, loginName);
				},
				error: function(jqXHR, status, error) {
					alert(status + " : " + error);
				}
			});
		}
        
        directoryLoginSettings.processLoginCallback = function(result, loginName){
			if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
				
                orgDebug("result.errorCode:"+result.errorCode+",loginName="+loginName);
                
				switch (result.errorCode) {
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_LOGINID:
					//alert($("#directory-login-notFoundLoginID").val().replace("{0}", $.trim(loginName)));
					alert($("#directory-login-notMatchUserOrPassword").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_LOGINID:
					alert($("#directory-login-duplicatedLoginID").val().replace("{0}", $.trim(loginName)));
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_EMPCODE:
					//alert($("#directory-login-notFoundEmpcode").val().replace("{0}", $.trim(loginName)));
					alert($("#directory-login-notMatchUserOrPassword").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_EMPCODE:
					alert($("#directory-login-duplicatedEmpcode").val().replace("{0}", $.trim(loginName)));
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_NAME:
					//alert($("#directory-login-notFoundName").val().replace("{0}", $.trim(loginName)));
					alert($("#directory-login-notMatchUserOrPassword").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_NAME:
					//alert($("#directory-login-duplicatedName").val().replace("{0}", $.trim(loginName)));
					// display homonyms
					$("#directory-login-name").blur();
					$("#directory-login-password").blur();
					$("#directory-homonyms").directoryHomonymsLogin(directoryLoginSettings, password, result.homonyms).display();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOT_MATCH_PASSWORD:
					//alert($("#directory-login-notMatchPassword").val());
					alert($("#directory-login-notMatchUserOrPassword").val());
					$("#directory-login-password").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_LOCKED_USER:
					alert($("#directory-login-lockedUser").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_EXPIRED_USER:
					alert($("#directory-login-expiredUser").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_LOGIN:
					if (confirm($("#directory-login-duplicatedLogin").val().replace("{0}", result.dupLoginClientName))) {
						directoryLoginSettings.checkDupLogin = "0";
						directoryLoginSettings.login();
						directoryLoginSettings.checkDupLogin = "1";
					}
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTALLOWED_IP:
					alert($("#directory-login-notallowedip").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_EMAIL:
					alert($("#directory-login-notFoundEmail").val().replace("{0}", $.trim(loginName)));
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_EMAIL:
					//alert($("#directory-login-duplicatedEmail").val().replace("{0}", $.trim(loginName)));
					// display homonyms
					$("#directory-login-name").blur();
					$("#directory-login-password").blur();
					$("#directory-homonyms").directoryHomonymsLogin(directoryLoginSettings, password, result.homonyms).display();
					break;
				default:
					orgDebug("default");
					alert($("#directory-login-errorMessage").val() + "(" + result.errorMessage + " : " + result.errorCode + ")");
				}
			} else {
				if (result.changePassword) {
					// popup for password changing
					directoryLoginSettings.popupChangePassword(result.K, result, loginName);
				} else if (result.isOtherOffice) {
					// display otheroffices
					$("#directory-login-name").blur();
					$("#directory-login-password").blur();
					$("#directory-otheroffices").directoryOtherOfficeLogin(directoryLoginSettings, result.K, result.users).display();
				} else {
					directoryLoginSettings.loginSuccessCallback(result.K, result, loginName);
				}
			}        
        }
		
		directoryLoginSettings.display = function(){
			var idImg = "<img src='"+directoryLoginSettings.context+"/directory/images/"+(directoryLoginSettings.loginType.toUpperCase())+".GIF' />";
			var pwImg = "<img src='"+directoryLoginSettings.context+"/directory/images/PASSWORD.GIF' />";
			that.append("<div id='directory-login-name-label'>"+directoryLoginSettings.loginType.toUpperCase()+"</div><input type='text' id='directory-login-name' size='15' maxlength='60'/>");
			that.append("<div id='directory-login-password-label'>PASSWORD</div><input type='password' id='directory-login-password' size='20' maxlength='15' />");
			that.append("<img id='directory-login-button' src='"+directoryLoginSettings.context+"/directory/images/LOGIN.GIF' />");
			$("#directory-login-button").bind("click", directoryLoginSettings.login);
			$("#directory-login-password").bind("keypress", function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-login-button").click();
				}
			});
			that.append("<div id='directory-homonyms'></div>");
			that.append("<div id='directory-otheroffices'></div>");
			that.append("<div>Language selection&nbsp;<select id='directory-lang'><option value='ko_KR'>Korean</option><option value='en_US'>English</option></select></div>");
			$("#directory-login-name").focus();
		}
		
		directoryLoginSettings.popupChangePassword = function(K, result, loginName) {
			var that = this;
			$.popupChangePasswordCallback = function(){
				directoryLoginSettings.loginSuccessCallback(K, result, loginName);
			}
			
			$.ajax({
				url: directoryLoginSettings.context + "/org.do",
				data: {
					acton: "popupChangePassword",
					viewName: "env/popupChangePassword",
					K: K,
					popupChangePasswordCallback:"popupChangePasswordCallback"
				},
				success: function(html) {
					directory_divPopup.open(html);
				}
			});
		}
		
		return directoryLoginSettings;
	}
})(jQuery);

(function($){
	$.fn.directoryHomonymsLogin = function(initial, password, homonyms)	{
		directoryHomonymsLoginSettings = {};
		
		var that = this;
		
		directoryHomonymsLoginSettings.login = function() {
			that.hide();
			var selected = $("#directory-homonyms-select option:selected");
			if (selected.length == 0) {
				alert($("#directory-login-selectHomonym").val());
				$("#directory-homonyms-select").focus();
				return;
			}
			var userID = selected.val();
			var loginName = $("#directory-homonyms-select option:selected").text();
			
			directoryLoginSettings.cryptedParam = "";
			var data = {
				acton: "login",
				communityID: initial.communityID,
				loginName: directoryLoginSettings.encryptParameter("loginName", userID),
				password: directoryLoginSettings.encryptParameter("password", password),
				cryptedParam : directoryLoginSettings.cryptedParam,
				loginType: "userid",
				checkDupLogin: initial.checkDupLogin,
				FRAMEWORK_DIRECTORY_LOCALE: $("#directory-lang").val()
			};
			orgDebug("login :"+data.loginName+","+data.password+","+data.loginType);
			$.ajax({
				url: initial.context + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						switch (result.errorCode) {
						case directory_orgErrorCode.ORG_LOGIN_NOT_MATCH_PASSWORD:
							//alert($("#directory-login-notMatchPassword").val());
							alert($("#directory-login-notMatchUserOrPassword").val());
							$("#directory-login-password").focus();
							break;
						case directory_orgErrorCode.ORG_LOGIN_LOCKED_USER:
							alert($("#directory-login-lockedUser").val());
							$("#directory-login-name").focus();
							break;
						case directory_orgErrorCode.ORG_LOGIN_EXPIRED_USER:
							alert($("#directory-login-expiredUser").val());
							$("#directory-login-name").focus();
							break;
						case directory_orgErrorCode.ORG_LOGIN_DUPLICATED_LOGIN:
							if (confirm($("#directory-login-duplicatedLogin").val().replace("{0}", result.dupLoginClientName))) {
								initial.checkDupLogin = "0";
								directoryHomonymsLoginSettings.login();
								initial.checkDupLogin = "1";
							}
							break;
						default:
							orgDebug("default");
							alert($("#directory-login-errorMessage").val() + "(" + result.errorMessage + " : " + result.errorCode + ")");
						}
					} else {
						if (result.changePassword) {
							// popup for password changing
							initial.popupChangePassword(result.K, result, loginName);
						} else if (result.isOtherOffice) {
							// display otheroffices
							$("#directory-login-name").blur();
							$("#directory-login-password").blur();
							$("#directory-otheroffices").directoryOtherOfficeLogin(initial, result.K, result.users).display();
							return; // do not close divPopup
						} else {
							initial.loginSuccessCallback(result.K, result, loginName);
						}
					}
					if (typeof(directory_divPopup) != 'undefined') {
						directory_divPopup.close();
					}
				},
				error: function(jqXHR, status, error) {
					alert(status + " : " + error);
					if (typeof(directory_divPopup) != 'undefined') {
						directory_divPopup.close();
					}
				}
			});
		}
		
		directoryHomonymsLoginSettings.display_ = function() {
			var title = $("#directory-login-homonymTitle").val();
			var select = "<select id='directory-homonyms-select'>";
			for (var i = 0; i < homonyms.length; i++) {
				select += "<option value='" + homonyms[i].uniqueID + "'>" + homonyms[i].name + "</option>";
			}
			select += "</select>";
			var button = "<input type='button' id='directory-homonyms-button' value='" + $("#directory-login-select").val() + "'/>";
			var dummy = $("<div>");
			var div = $("<div style='margin:10px 10px 10px 10px; font-family: Arial, Verdana, MS Gothic, Gulim, Dotum, sans-serif; font-size: 12px; color: #444'>");
			dummy.append(div);
			div.append(title);
			div.append($("<br/>"));
			div.append($(select));
			div.append($("<br/>"));
			div.append($("<br/>"));
			div.append($(button));
			directory_divPopup.open(dummy.html());
			$("#directory-homonyms-button").bind("click", directoryHomonymsLoginSettings.login);
			
			/*var select = "<select id='directory-homonyms-select'>";
			for (var i = 0; i < homonyms.length; i++) {
				select += "<option value='" + homonyms[i].uniqueID + "'>" + homonyms[i].name + "</option>";
			}
			select += "</select>";
			
			that.show();
			that.empty();
			that.append($("#directory-login-homonymTitle").val());
			that.append("<br />");
			that.append(select);
			that.append("<input type='button' id='directory-homonyms-button' value='" + $("#directory-login-select").val() + "' />");
			$("#directory-homonyms-button").bind("click", directoryHomonymsLoginSettings.login);
			*/
		}
		directoryHomonymsLoginSettings.display = function() {
			var title = $("#directory-login-homonymTitle").val();
			var select = "<select id='directory-homonyms-select' STYLE='WIDTH: 100%;' size='3'>";
			for (var i = 0; i < homonyms.length; i++) {
				select += "<option value='" + homonyms[i].uniqueID + "'>" + homonyms[i].name + "</option>";
			}
			select += "</select>";
			var div = "<div id='pop_wrap' style='min-width: 0px;'>"+
			"<h1>"+
			"        <p>"+title+"</p>"+
			"    </h1>"+
			"    "+
			"    <table class='basic_table' border='0' cellSpacing='0' cellPadding='0' width='100%'>"+
			"		<tbody>"+
			"			<tr>"+
			"				<th>"+
			"					"+$("#directory-login-existHomonym").val()+
			"					<br>"+
			"					"+$("#directory-login-selectHomonym").val()+
			"				</th>"+
			"			</tr>"+
			"		</tbody>"+
			"	</table>		"+
			"	<!-- content start-->"+
			"    <div id='pop_container'>"+
			"		<div class='contents'> "+
			"            <table class='basic_table' border='0' cellSpacing='0' cellPadding='0' width='100%'>"+
			"				<col width='60px'>								"+
			"				<col width='100%'>"+
			"				<tbody>"+
			"					<tr>"+
			"						<th>"+
			"							"+$("#directory-login-select").val()+
			"						</th>"+
			"						<td>"+
			"							"+select+
			"						</td>"+
			"					</tr>"+
			"				</tbody>"+
			"			</table>"+
			"		</div>"+
			"	</div>"+
			"	<!-- content start-->"+
			"	<div class='footcen'>"+
			"		<ul class='btns'>"+
			"			<li>"+
			"				<span><a href='#' id='directory-homonyms-ok-button'>"+$("#directory-login-ok").val()+"</a></span>"+
			"			</li>"+
			"			<li>"+
			"				<span><a href='#' onclick='javascript:directory_divPopup.close()'>"+$("#directory-login-cancel").val()+"</a></span>"+
			"			</li>"+
			"		</ul>"+
			"	</div>"+
			"						                "+
			"</div>";
			directory_divPopup.open(div);
			$("#directory-homonyms-ok-button").bind("click", directoryHomonymsLoginSettings.login);
			
			/*var select = "<select id='directory-homonyms-select'>";
			for (var i = 0; i < homonyms.length; i++) {
				select += "<option value='" + homonyms[i].uniqueID + "'>" + homonyms[i].name + "</option>";
			}
			select += "</select>";
			
			that.show();
			that.empty();
			that.append($("#directory-login-homonymTitle").val());
			that.append("<br />");
			that.append(select);
			that.append("<input type='button' id='directory-homonyms-button' value='" + $("#directory-login-select").val() + "' />");
			$("#directory-homonyms-button").bind("click", directoryHomonymsLoginSettings.login);
			*/
		}
		
		return directoryHomonymsLoginSettings;
	}
})(jQuery);

(function($){
	$.fn.directoryOtherOfficeLogin = function(initial, userKey, otheroffices)	{
		directoryOtherOfficeLoginSettings = {};
		
		var that = this;
		
		directoryOtherOfficeLoginSettings.successCallback = function(result, status){
			if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
				switch (result.errorCode) {
				case directory_orgErrorCode.CANNOT_SEEK_DBF_FILE:
					alert($("#directory-login-notFoundUserKey").val().replace("{0}", $.trim(data.K)));
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_USERID:
					alert($("#directory-login-notFoundUserID").val().replace("{0}", $.trim(data.userID)));
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTFOUND_OTHEROFFICE:
					alert($("#directory-login-notFoundOtherOffice").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_LOCKED_USER:
					alert($("#directory-login-lockedUser").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_EXPIRED_USER:
					alert($("#directory-login-expiredUser").val());
					$("#directory-login-name").focus();
					break;
				case directory_orgErrorCode.ORG_LOGIN_NOTALLOWED_IP:
					alert($("#directory-login-notallowedip").val());
					$("#directory-login-name").focus();
					break;
				default:
					orgDebug("default");
					alert($("#directory-login-errorMessage").val() + "(" + result.errorMessage + " : " + result.errorCode + ")");
				}
			} else {
				var loginName = $("#directory-otheroffices-select option:selected").text();
				initial.loginSuccessCallback(result.K, result, loginName);
			}
			if (typeof(directory_divPopup) != 'undefined') {
				directory_divPopup.close();
			}
		};
		
		directoryOtherOfficeLoginSettings.login = function() {
			that.hide();
			var selected = $("#directory-otheroffices-select option:selected");
			if (selected.length == 0) {
				alert($("#directory-login-selectHomonym").val());
				$("#directory-homonyms-select").focus();
				return;
			}
			var userID = selected.val();
			var data = {
				acton: "loginOtherOffice",
				communityID: initial.communityID,
				userID: userID,
				K: userKey
			};
			if ($("#directory-lang").val() != '') {
				data["FRAMEWORK_DIRECTORY_LOCALE"] = $("#directory-lang").val();
			}
			orgDebug("loginOtherOffice :"+data.userID+","+data.K);
			$.ajax({
				url: initial.context + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: directoryOtherOfficeLoginSettings.successCallback,
				error: function(jqXHR, status, error) {
					alert(status + " : " + error);
					if (typeof(directory_divPopup) != 'undefined') {
						directory_divPopup.close();
					}
				}
			});
		};
		
		directoryOtherOfficeLoginSettings.changeAdditionalUser = function(userID) {
			that.hide();
			var data = {
				acton: "loginOtherOffice",
				communityID: initial.communityID,
				userID: userID,
				K: userKey
			};
			if ($("#directory-lang").val() != '') {
				data["FRAMEWORK_DIRECTORY_LOCALE"] = $("#directory-lang").val();
			}
			orgDebug("loginOtherOffice :"+data.userID+","+data.K);
			$.ajax({
				url: initial.context + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: directoryOtherOfficeLoginSettings.successCallback,
				error: function(jqXHR, status, error) {
					alert(status + " : " + error);
					if (typeof(directory_divPopup) != 'undefined') {
						directory_divPopup.close();
					}
				}
			});
		};
		
		directoryOtherOfficeLoginSettings.display_ = function() {
			var title = $("#directory-login-otherofficesTitle").val();
			var select = "<select id='directory-otheroffices-select'>";
			for (var i = 0; i < otheroffices.length; i++) {
				select += "<option value='" + otheroffices[i].id + "'>" + otheroffices[i].name + "</option>";
			}
			select += "</select>";
			var button = "<input type='button' id='directory-otheroffices-button' value='" + $("#directory-login-select").val() + "'/>";
			var dummy = $("<div>");
			var div = $("<div style='margin:10px 10px 10px 10px; font-family: Arial, Verdana, MS Gothic, Gulim, Dotum, sans-serif; font-size: 12px; color: #444'>");
			dummy.append(div);
			div.append(title);
			div.append($("<br/>"));
			div.append($(select));
			div.append($("<br/>"));
			div.append($("<br/>"));
			div.append($(button));
			directory_divPopup.open(dummy.html());
			$("#directory-otheroffices-button").bind("click", directoryOtherOfficeLoginSettings.login);
		}
		directoryOtherOfficeLoginSettings.display = function() {
			var title = $("#directory-login-otherofficesTitle").val();
			var select = "<select id='directory-otheroffices-select' STYLE='WIDTH: 100%;' size='3'>";
			for (var i = 0; i < otheroffices.length; i++) {
				select += "<option value='" + otheroffices[i].id + "'>" + otheroffices[i].name + "</option>";
			}
			select += "</select>";
			var div = "<div id='pop_wrap' style='min-width: 0px;'>"+
			"<h1>"+
			"        <p>"+title+"</p>"+
			"    </h1>"+
			"    "+
			"    <table class='basic_table' border='0' cellSpacing='0' cellPadding='0' width='100%'>"+
			"		<tbody>"+
			"			<tr>"+
			"				<th>"+
			"					"+$("#directory-login-existOtheroffices").val()+
			"					<br>"+
			"					"+$("#directory-login-selectOtheroffices").val()+
			"				</th>"+
			"			</tr>"+
			"		</tbody>"+
			"	</table>		"+
			"	<!-- content start-->"+
			"    <div id='pop_container'>"+
			"		<div class='contents'> "+
			"            <table class='basic_table' border='0' cellSpacing='0' cellPadding='0' width='100%'>"+
			"				<col width='60px'>								"+
			"				<col width='100%'>"+
			"				<tbody>"+
			"					<tr>"+
			"						<th>"+
			"							"+$("#directory-login-select").val()+
			"						</th>"+
			"						<td>"+
			"							"+select+
			"						</td>"+
			"					</tr>"+
			"				</tbody>"+
			"			</table>"+
			"		</div>"+
			"	</div>"+
			"	<!-- content start-->"+
			"	<div class='footcen'>"+
			"		<ul class='btns'>"+
			"			<li>"+
			"				<span><a href='#' id='directory-otheroffices-ok-button'>"+$("#directory-login-ok").val()+"</a></span>"+
			"			</li>"+
			"			<li>"+
			"				<span><a href='#' onclick='javascript:directory_divPopup.close()'>"+$("#directory-login-cancel").val()+"</a></span>"+
			"			</li>"+
			"		</ul>"+
			"	</div>"+
			"						                "+
			"</div>";
			//dummy.append(div);
			//directory_divPopup.open(div.html());
			directory_divPopup.open(div);
			$("#directory-otheroffices-ok-button").bind("click", directoryOtherOfficeLoginSettings.login);
		}
		
		return directoryOtherOfficeLoginSettings;
	}
})(jQuery);