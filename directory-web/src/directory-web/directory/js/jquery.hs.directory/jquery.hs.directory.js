(function($) {
	$.fn.directorytree = function(options) {
		this.dynatree({
			idPrefix: "ui-dynatree-id-" + options.idPrefix + "-",
			minExpandLevel: 2, // 1: root node is not collapsible
			clickFolderMode: 1, // 1:activate, 2:expand, 3:activate and expand
			checkbox: options.checkbox, // Show checkboxes.
			selectMode: options.selectMode, // 1:single, 2:multi, 3:multi-hier
			onClick: function(dtnode, event) {
				var type = dtnode.getEventTargetType(event);
				if (type == "prefix")
					return false;
				if (type != "expander" && !dtnode.data.key)
					return false;
				if (type == "icon" || type == "title") {
					if (dtnode.data.noLink) {
						return false;
					}
					if (options.selectMode == 1 && options.checkMode != "list"
							&& ((options.openerType == "A" && dtnode.data.rbox == "false") || dtnode.data.isNotUse)) {
						options.onActivate(dtnode);
						return false;
					}
					if (dtnode.isActive()) {
						options.onActivate(dtnode);
						return false;
					}
				}
				
				if (options.openerType == "A" && dtnode.data.rbox == "false" && type == "expander") {
					if (dtnode.bExpanded)
						dtnode.data.addClass = "ui-dynatree-statusnode-rbox";
					else
						dtnode.data.addClass = "ui-dynatree-statusnode-rbox-o";					
				}
				return true;
			},
			onDblClick: function(dtnode, event) { 
				var type = dtnode.getEventTargetType(event);
				if ((type == "icon" || type == "title") && dtnode.isSelected() && options.selectMode == 1) {
					options.onDblClick(dtnode, event);
				}
			},
			onActivate: options.onActivate || function(dtnode) {},
			onSelect: options.onSelect || function(select, dtnode) {},
			onLazyRead: options.onLazyRead || function(dtnode){},
			classNames: {
				//checkbox: (options.selectMode == 1 ? "ui-dynatree-radio" : "ui-dynatree-checkbox")
			}
		});
		options.init();
	}
	
	/**
	 * @param context		: required
	 * @param K				: optional (default: "")
	 * @param display		: optional (default: "") - "rootdept, subdept, group, contact, position, charger"
	 * @param dutiesUsed	: optional (default: "all") - "lieutenant, deptmanager, documentmanager, sendreceivemanager, addressbookmanager, schedulemanager"
	 * @param checkbox		: optional (default: "both") - "both", "tree", "list"
	 * @param selectMode	: optional (default: 2) - 1:single, 2:multi
	 * @param openerType	: optional (default: "") - "M":Mail, "T":T-Manager, "K":KMS
	 * @param notUseDept	: optional (default: "")
	 * @param notUseUser	: optional (default: "")
	 * @param startDept		: optional (default: "")
	 * @param groupType		: optional (default: "")
	 * @param activeSelect	: optional (default: "1")  - 1(selected on active in tree)
	 * @param useAbsent		: optional (default: "true")  - true(display in userList)
	 * @param useSelectAll	: optional (default: "false") - true(checkbox selectAll in deptList)
	 * @param FRAMEWORK_DIRECTORY_LOCALE : optional (default: "") - ko_KR, en_US, ja_JP
	 */
	$.fn.directorypopup = function(options) {
		var s = options.context;			
		if (typeof s == 'undefined') {
			s = "/directory-web";
		} 
		s = /^\//.test(s) ? s : "/" + s;
		s = /\/$/.test(s) ? s.substring(0, s.length - 1) : s;
		options.context = s;
		
		directorySettings = $.extend({
				context:		null,
				K:				"",
				display:		"",
				dutiesUsed:		"all",
				checkbox:		"both",
				selectMode:		2,
				openerType:		"",
				notUseDept:		"",
				notUseUser:		"",
				startDept:		"",
				groupType:		"",
				activeSelect:	"1",
				useAbsent:		"true",
				useSelectAll:	"false",
				FRAMEWORK_DIRECTORY_LOCALE: ""
		}, options);
		
		var that = this;
		that.hide();
		
		directorySettings.submit = function(todo, recInfo) {
			if (that.length == 0) {
				alert("ERROR : not exist \"div\" element");
				return;
			}
			
			var params = $.extend({
				acton:			"resolveItems",
				K:				this.K,
				display:		this.display,
				dutiesUsed:		this.dutiesUsed,
				checkbox:		this.checkbox,
				selectMode:		this.selectMode,
				openerType:		this.openerType,
				notUseDept:		this.notUseDept,
				notUseUser:		this.notUseUser,
				startDept:		this.startDept,
				groupType:		this.groupType,
				activeSelect:	this.activeSelect,
				useAbsent:		this.useAbsent,
				useSelectAll: 	this.useSelectAll,
				FRAMEWORK_DIRECTORY_LOCALE: this.FRAMEWORK_DIRECTORY_LOCALE,
				todo:			todo
			}, recInfo);
			
			var width = (params.checkbox == "tree") ? 380 : 680;
			var height = 553;
			var left = screen.width / 2 - width  / 2 - 10;
			var top = screen.height / 2 - height / 2 - 33;
			
			var features = "left="+left+",top="+top+",width="+width+",height="+height+",";
			features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
			var orgPopup = window.open("", "orgPopup", features);
			
			var str = "<form action='"+this.context+"/org.do' accept-charset='UTF-8' method='POST'>";
			$.each(params, function(i, n) {
				str += "<input type='hidden' name='" + i + "' value='" + n + "' />";
			});
			str += "</form>";
			
			orgPopup.document.charset = "utf-8";
			orgPopup.document.write(str);
			orgPopup.document.forms[0].submit();
		}
		
		var outerModule = {
			recInfo : {
				to:		"",	// resolved
				cc:		"",	// resolved
				bcc:	"",	// resolved
				hwto:	"",	// handwrite
				hwcc:	"",	// handwrite
				hwbcc:	"",	// handwrite
				recType: "to"
			},
			success : function(toList, ccList, bccList) {
				this.recInfo.to = toList.toString();
				this.recInfo.cc = ccList.toString();
				this.recInfo.bcc = bccList.toString();
				this.callback(toList, ccList, bccList); // callback
			},
			callback : function(toList, ccList, bccList) {
				// Don't remove, it is dummy function
			},
			
			/**
			 * @param to  : resolved
			 * @param cc  : resolved
			 * @param bcc : resolved
			 */
			init : function(to, cc, bcc) {
				this.recInfo.to = to || "";
				this.recInfo.cc = cc || "";
				this.recInfo.bcc = bcc || "";
			},
			/**
			 * @param hwto  : handwrite
			 * @param hwcc  : handwrite
			 * @param hwbcc : handwrite
			 * @param recType : "to", "cc", "bcc"
			 */
			set : function(hwto, hwcc, hwbcc, recType) {
				this.recInfo.hwto = hwto || "";
				this.recInfo.hwcc = hwcc || "";
				this.recInfo.hwbcc = hwbcc || "";
				this.recInfo.recType = recType || "to";
			},
			/**
			 * @param callback : callback function.
			 */
			open : function(callback) {
				if (callback) this.callback = callback;
				directorySettings.submit("open", this.recInfo);
			},
			/**
			 * @param callback : callback function.
			 */
			resolve : function(callback) {
				if (callback) this.callback = callback;
				directorySettings.submit("resolve", this.recInfo);
			}
		}
		return outerModule;
	}
})(jQuery);