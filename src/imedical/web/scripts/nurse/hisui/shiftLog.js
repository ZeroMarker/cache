/*
 * @Author: yaojining
 * @Discription: 护理病历引用
 * @Date: 2020-3-20
 */
(function() {
	var GV = {
	    ClassName: 'NurMp.Service.Refer.Handle',
	    CurrentID: '',
	    PageRowNum: screen.width > 1600 ? 14 : 7,
	    TABS: ['知识库']
	};
	function init() {
		initUI();
		listenEvents();
	}
	/**
	 * @description: 初始化界面
	 */
	function initUI() {
		//大框架
		$('#layout').layout('panel','west').panel('resize',{width:$(window).width() * 0.65});
		$('#layout').layout('resize');
		var contentHeight = $('#layout').layout('panel','center').panel('options').height;
		var firstTab=$('#tabs').tabs('getTab',0);
		initTab(firstTab[0].id);
		$('#tabs').tabs({
			onSelect: function (title,index) {
				var selectTab=$('#tabs').tabs('getTab',index);
				var tabID=selectTab[0].id;
				initTab(tabID)
			}
		});
	}
	function initTab(tabID)
	{
		switch (tabID) {
   			 case "Knowledge":
        		initTabKnowledge();  //知识库
        		break;
    		 case "Exec":
       			initExec();          //执行记录信息
        		break;
    		 case "Lis":
        		initLis();           //检验信息
        		break;
    		 case "Pacs":
        		initPacs();          //检查信息
        		break;
    		 case "Observation":
        		initObservation();   //生命体征
        		break;
    		 case "Epr":
        		initEpr();           //电子病历
       	 		break;
    		 case "Char":
        		initChar();          //特殊符号
        		break;
        	case "History":
        		initHistory();          //特殊符号
        		break;
    		 default:
        		break;
		};
		if (tabID.indexOf("NR") >= 0) {
    		var recordConfigID = tabID.substring(2);
    		initFormatRecords(recordConfigID);
		}
	}
	/**
	 * @description: 初始化知识库
	 */
	function initTabKnowledge() {
		var layoutWidth=$('#layout').layout('panel','west').panel('options').width;
		$('#layoutKnowTree').layout('panel','west').panel('resize',{width:layoutWidth * 0.35});
		$('#layoutKnowTree').layout('resize');
		//查询条件-科室
		var defaultLoc = $m({
			ClassName: 'NurMp.Service.Refer.Handle',
			MethodName: 'getDefaultLoc',
			LocID: session['LOGON.CTLOCID']
		},false);
		$HUI.combobox('#comboLoc', {
			valueField: 'id',
	        textField: 'text',
			url: $URL + '?ClassName=NurMp.Service.Refer.Handle&MethodName=GetKnowledgeLocs&HospitalID=' + session['LOGON.HOSPID'] + '&LocId=' + session['LOGON.CTLOCID'],
			value: defaultLoc,
			onSelect: function(record) {
				$HUI.tree('#knowledgeTree','reload');
			}
		});
		//8.5以前版本调用知识库树结构
		/*$HUI.tree('#knowledgeTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: GV.ClassName,
					MethodName: "getKnowledgeTree",
					LocId: $('#comboLoc').combobox('getValue'),
					HospitalID: ""
				}, function(treeData) {
					success(treeData);
				});
			},
			autoNodeHeight: true,
			onClick: loadKnowledgeItemData
		});*/
		//8.5以后版本调用
		$HUI.tree('#knowledgeTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.Service.Refer.Handle",
					MethodName: "getKnowledgeTree",
					LocId: $('#comboLoc').combobox('getValue'),
					HospitalID: session['LOGON.HOSPID']
				}, function(treeData) {
					success(treeData);
				});
			},
			autoNodeHeight: true,
			onClick: loadKnowledgeItemData
		});
	}
	
	var GLOBAL = {
		code: 'Know',
		hospitalID: session['LOGON.HOSPID'],
		className: 'NurMp.Service.Refer.Handle',
		currentDomID: '',
		multWrite: $cm({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'getDomValue',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			DomID: 'KnowMultWrite'
		}, false),
		knowWindow: $cm({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'getDomValue',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			DomID: 'KnowWindow'
		}, false),
		requestInfo: $cm({
			ClassName: 'NurMp.Service.Refer.Setting',
			MethodName: 'getReferTabConfig',
			HospitalID: session['LOGON.HOSPID'],
			Code: 'Know'
		}, false)
	};
	
	/**
	 * @description: 加载知识库具体内容
	 * @param {node} 节点
	 */
	function loadKnowledgeItemData(node) {
		$cm({
			ClassName: "NurMp.Service.Refer.Handle",
			MethodName: "getContent",
			KnowledgeID: node.id,
			EpisodeID:EpisodeID
		}, function(content) {
			// 包含动态元素的内容创建html，否则直接带入内容
			
			
			$('#panelPreview').empty();
			if (content.length > 0) {
				$.each(content, function (i, c) {
					var eleItem = loadHtmlDom(c);
					if (GLOBAL.knowWindow) {
						if (!!eleItem) {
							$('#panelPreview').append($(eleItem));
						}
						$('#' + c.id).bind('click', c, eleClickHandler);
					}
				});
			} else {
				if (GLOBAL.knowWindow) {
					$('#panelPreview').empty();
				}
			}
			
			return 
			/*if ((!!content) && (!!content.total)) {
				console.log(content)
				$('#panelPreview').empty();
				var eleCount = content.total;
				for (var i = 0; i < eleCount; i++) {
					var eleItem = '';
					var eleNo = 101 + i;
					var eleId = eval('content.Element' + eleNo)[0].id;
					var eleText = eval('content.Element' + eleNo)[0].title;
					var eleType = eval('content.Element' + eleNo)[0].type;
					var eleData = eval('content.Element' + eleNo)[0].data;
					var eleDefault = eval('content.Element' + eleNo)[0].default;
					var eleDateFlag = eval('content.Element' + eleNo)[0].dateFlag;
					var eleTimeFlag = eval('content.Element' + eleNo)[0].timeFlag;
					var defaultText = eleText;
					if (eleDefault!='') {
						defaultText = eleDefault;
					}
					if (eleType === 'O') {
						eleItem = "<span style='background-color:#509de1;border:1px dotted black'><a href='javascript:void(0);' id=" + eleId + " style='color:white;'>" + defaultText + "</a></span>";
					} else if (eleType === 'M') {
						eleItem = "<span style='background-color:#EE7942;border:1px dotted black'><a href='javascript:void(0);' id=" + eleId + " style='color:white;'>" + defaultText + "</a></span>";
					} else if (eleType === 'D') {
						var date = eval('content.Element' + eleNo)[0].date;
						var time = eval('content.Element' + eleNo)[0].time;
						defaultText = $.trim(date + ' ' + time);
						if (!defaultText) defaultText = eleText;
						eleItem = "<span style='background-color:#4EEE94;border:1px dotted black'><a href='javascript:void(0);' id=" + eleId + " style='color:white;'>" + defaultText + "</a></span>";
					} else if (eleType === 'N') {
						eleItem = "<span style='background-color:#F3F781;border:1px dotted black'><a href='javascript:void(0);' id=" + eleId + " style='color:white;'>" + defaultText + "</a></span>";
					} else {
						eleText = eleText.toString().replace("&KeyEnter;","<br>");
						eleItem = "<span>" + eleText + "</span>";
					}

					$('#panelPreview').append($(eleItem));
					$('#' + eleId).bind('click', {
						index: eleNo,
						id: eleId,
						type: eleType,
						text: eleText,
						data: eleData,
						default: eleDefault,
						dateFlag: eleDateFlag,
						timeFlag: eleTimeFlag
					}, eleClickHandler);
				}
			} else {
				//$('#panelPreview').empty();
		        //$('#panelPreview').append("<span>" + node.text + "</span>");
			}*/
		});
	}
	
	function loadHtmlDom(c) {
		var eleHtml = '';
		var desc = '';
		if (!!c.sourceData) {
			if ($.isPlainObject(c.sourceData)) {
				if (Array.isArray(c.sourceData.values)) {
					$.each(c.sourceData.values, function (i, v) {
						desc = !!desc ? desc + ',' + v.Text : v.Text;
					});
				} else if (!!c.sourceData.values) {
					desc = c.sourceData.values;
				} else {
					desc = c.title;
				}
			} else {
				desc = c.sourceData;
			}
		} else {
			desc = c.title;
		}
		if (GLOBAL.knowWindow) {
			if (c.type == 'O') {
				eleHtml = "<span style='background-color:#509de1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
			} else if (c.type == 'M') {
				eleHtml = "<span style='background-color:#EE7942;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
			} else if (c.type == 'D') {
				eleHtml = "<span style='background-color:#4EEE94;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
			} else if (c.type == 'N') {
				eleHtml = "<span style='background-color:#8552a1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
			} else if (c.type == 'I') {
				//分隔符
			} else {
				var reg = new RegExp('\r\n', 'g');
				desc = String(c.title).replace(reg, '<br>');
				eleHtml = "<span id='" + c.id + "'>" + desc + "</span>";
			}
		} else {
			var strRefTo = '';
			if ((typeof c.refTo != "undefined") && (c.refTo.length > 0)) {
				$.each(c.refTo, function (index, ref) {
					strRefTo = !!strRefTo ? strRefTo + "," + ref.Text : ref.Text;
				});
			}

			var prop = new Object();
			//个性化属性
			switch (c.type) {
				case 'O': {
					prop = {
						type: 'select',
						className: 'hisui-combobox',
						style: {
							width: '100px',
							margin: '4px'
						}
					}
					break;
				}
				case 'M': {
					prop = {
						type: 'select',
						className: 'hisui-combobox',
						style: {
							width: '150px',
							margin: '4px'
						}
					}
					break;
				}
				case 'D': {
					var className = 'hisui-datetimebox textbox combo-f datetimebox-f';
					var width = '180px';
					var borderRadius = '';
					if ((c.dateFlag == "Y") && (c.timeFlag == "N")) {
						className = 'hisui-datebox textbox datebox-f combo-f';
						width = '120px';
					} else if ((c.dateFlag == "N") && (c.timeFlag == "Y")) {
						className = 'hisui-timespinner';
						width = '80px';
						borderRadius: '2px';
					}
					prop = {
						type: 'input',
						className: className,
						style: {
							width: width,
							borderRadius: borderRadius
						}
					}
					break;
				}
				case 'N': {
					prop = {
						type: 'input',
						className: 'hisui-validatebox textbox',
						style: {
							width: '70px',
							margin: '4px'
						},
						validateRule: {
							validType: 'number'
						}

					}
					break;
				}
				default: {
					var reg = new RegExp('\r\n', 'g');
					prop = {
						type: 'span',
						innerHTML: String(c.title).replace(reg, "<br>"),
						style: {
							fontSize: '16px',
							margin: '4px'
						}
					}
					break;
				}
			}
			//公共属性
			prop.id = c.id;
			prop.value = desc;
			prop.options = {
				placeholder: c.title,
				refFrom: c.refFrom,
				refTo: strRefTo
			};
			elFactory(prop);

			if ((c.type == 'O') || (c.type == 'M')) {
				$('#' + c.id).combobox('clear');
				var checkedId = [];
				var checkedArr = String(desc).split(',');
				$.each(c.sourceData.source, function (index, data) {
					if ($.inArray(String(data.Text), checkedArr) > -1) {
						checkedId.push(data.Value);
						if (c.type == 'O') {
							return false;
						}
					}
				});
				var multiple = c.type == 'O' ? false : true;
				var rowStyle = c.type == 'O' ? '' : 'checkbox';
				$('#' + c.id).combobox({
					valueField: 'Value',
					textField: 'Text',
					data: c.sourceData.source,
					value: checkedId,
					multiple: multiple,
					rowStyle: rowStyle,
					defaultFilter: 4
				});
			}
		}
		return eleHtml;
	}
	
	/**
	 * @description: 组装元素
	 */
	function elFactory(prop) {
		var el = document.createElement(prop.type);
		$.each(prop, function (key, value) {
			if ((key != 'type') && (!!value)) {
				if (key == 'style') {
					$.each(value, function (i, v) {
						if (!!v) {
							el.style[i] = v;
						}
					});
				} else if (key == 'options') {
					$.each(value, function (i, v) {
						el.setAttribute(i, v);
					});
				} else if (key == 'validateRule') {
					$(el).validatebox(value);
				} else {
					el[key] = value;
				}
			}
		});
		$('#panelPreview').append(el);
		$.parser.parse('#panelPreview');
	}
	
	/**
	 * @description: 选中知识库内容
	 */
	function eleClickHandler(e) {
		var id = e.data.id;
	    GV.CurrentID = id;
	    var typ = e.data.type;
	    var text = e.data.text;
	    var data = e.data.data;
	    var defValue = e.data.default;
	    var dateFlag = e.data.dateFlag;
	    var timeFlag = e.data.timeFlag;
	    var currentText = $('#' + e.data.id)[0].innerText.replace(' ', '');
	    var dialogWidth = 400;
		var dialogHeight = 200;
	    if (!e.data.type) {
	    	$.message.popover({msg: 'DOM元素类型为空！', type:'error', timeout: 500});
	    	return;
	    }
	    if (e.data.type == 'O') {
	    	$('#comboDom').empty();
	    	dialogWidth = 350;
	    	dialogHeight = 140;
	    	$('#comboDom').combobox({
	            valueField: 'id',
	            textField: 'text',
	            data: e.data.data,
	            defaultFilter: 4
	        });
	        $('#comboDom').combobox('setText', currentText);
	    } else if (e.data.type == 'M') {
	    	$('#ulDom').empty();
	    	dialogWidth = 350;
	    	dialogHeight = 200;
	    	$('#panelDomM').panel('resize', {height:120});
	    	var checkedArr = currentText.split(',');
	    	$.each(e.data.data, function(index, data) {
	    		var ifChecked = $.inArray(data.text, checkedArr) >= 0 ? 'checked' : '';
	    		$('#ulDom').append("<li><input class='hisui-checkbox' type='checkbox' " + ifChecked + " label='" + data.text + "'></li>");
	    	});

	    } else if (e.data.type == 'D') {
	    	dialogWidth = 350;
	    	dialogHeight = 200;
	    	var currDate = defValue.split(' ')[0];
	        var currTime = defValue.split(' ')[1];
	        console.log(defValue)
	        if($("#"+id).text())
	        {
		    	currDate = $("#"+id).text().split(' ')[0];
	        	currTime = $("#"+id).text().split(' ')[1];
		    }
	        //currDate = currDate.replace('/', '-');
	        $('#dateDomD').datebox('setValue', currDate);
	        $('#timeDomD').timespinner('setValue', currTime);
	    	if (e.data.dateFlag == 'Y') {
	    		$('#row1').css('display','block');
	    	}else{
		    	$('#row1').css('display','none');
		    }
	    	if (e.data.timeFlag == 'Y') {
	    		$('#row2').css('display','block');
	    	}else{
		    	$('#row2').css('display','none');
		    }    	
	    } else if (e.data.type == 'N') {
	    	$('#txtNumber').numberbox('setValue',currentText);
	    }
	    $.parser.parse('#panelDom' + e.data.type);
		$('#dialogDom' + e.data.type).dialog({  
		    title: text,  
		    width: dialogWidth,  
		    height: dialogHeight,   
		    cache: false,
		    modal: true
		});
		$('#dialogDom' + e.data.type).dialog('open');

		//监听确定取消事件
		$('#btnOkDom' + typ).bind('click', {
	        appendId: id,
	        typ: typ,
	        data: data,
	    }, btnClickHandler);
	    $('#btnNoDom' + typ).bind('click', function() {
	    	$('#dialogDom' + e.data.type).dialog('close');
	    });
	}
	/**
	* @description: 确定按钮的点击事件
	* @param {event} 
	*/
	function btnClickHandler(e) {
	    var id = e.data.appendId;
	    if (id == GV.CurrentID) {
	        var typ = e.data.typ;
	        var data = e.data.data;
	        if (typ == 'O') {
	            var comboText = $('#comboDom').combobox('getText');
	            $('#' + id)[0].innerText = comboText ;
	        } else if (typ == 'M') {
	            var checkboxText = '';
	            $('#ulDom li input').each(function (index, element) {
	                if (element.checked == true) {
	                    checkboxText = checkboxText == '' ? element.id : checkboxText + ',' + element.id;
	                }
	            });
	            $('#' + id)[0].innerText = checkboxText ;
	        } else if (typ == 'D') {
	            var datetimeText = '';
	            var dateText = '';
	            var timeText = '';
	            var dateText = $('#dateDomD').datebox('getValue');
	            var timeText = $('#timeDomD').spinner('getValue');
	            datetimeText = dateText + ' ' + timeText;
	            $('#' + id)[0].innerText = datetimeText ;
	        }else if (typ == 'N') {
		        var numberValue = $('#txtNumber').numberbox('getValue');
	            $('#' + e.data.appendId)[0].innerText = numberValue ;
	    	} 
	    }
	    $('#dialogDom' + e.data.typ).dialog('close');
	}
	/**
	 * @description: 选中知识库内容
	 */
	function sureKnowHandlerA() {
		var result = '';
		var childs = $('#panelPreview').children();
		$.each(childs, function(index, child){
			var text = child.innerText.replace('{', '').replace('}', '');
			result = result == '' ? text : result + text;
		});
		var oriText = $('#textEdit').val();
		var resultTxt = !!oriText ? oriText + ' ' + result : result;
		$('#textEdit').val(resultTxt);
	}
	
	
	function sureKnowHandler() {
		var result = '';
		var childs = $('#panelPreview').children();
		if (GLOBAL.knowWindow) {
			$.each(childs, function (index, child) {
				var text = child.innerText.replace('{', '').replace('}', '');
				result = result == '' ? text : result + text;
			});
		} else {
			for (var i = 0; i < childs.length; i++) {
				var text = childs[i].innerText.replace('{', '').replace('}', '');
				var type = childs[i].id.substring(0, 1);
				if (type == "D") {
					text = $("#" + childs[i].id).datebox('getValue');
				} else if ((type == "O") || (type == "M")) {
					text = $("#" + childs[i].id).combobox('getText');
				} else if (type == "N") {
					text = $("#" + childs[i].id).val();
				}
				if ((childs[i].firstChild) && (childs[i].firstChild.id) && (childs[i].firstChild.id.substring(0, 1) == "D")) {
					text = $("#" + childs[i].firstChild.id).spinner('getValue');
				}
				var isHideFlag = false;
				if (type == "F") {
					var refFrom = childs[i].getAttribute("refFrom");
					for (var j = 0; j < childs.length; j++) {
						if (j == i) continue;
						var stype = childs[j].id.substring(0, 1);
						if (stype == type) continue;
						var refTo = childs[j].getAttribute("refTo");
						if ((childs[j].firstChild) && (childs[j].firstChild.id) && (childs[j].firstChild.id.substring(0, 1) == "D")) {
							refTo = childs[j].firstChild.getAttribute("refTo");
						}
						if (!refTo) continue;
						var arrRefTo = String(refTo).split(',');
						if ($.inArray(refFrom, arrRefTo) < 0) continue;
						var stext = childs[j].innerText.replace('{', '').replace('}', '');
						if (stype == "D") {
							stext = $("#" + childs[j].id).datebox('getValue');
						} else if ((stype == "O") || (stype == "M")) {
							stext = $("#" + childs[j].id).combobox('getText');
						}
						if ((childs[j].firstChild) && (childs[j].firstChild.id) && (childs[j].firstChild.id.substring(0, 1) == "D")) {
							stext = $("#" + childs[j].firstChild.id).spinner('getValue');
						}
						if (!stext) {
							isHideFlag = true;
						}
					}
				}
				if (!isHideFlag) {
					result = result == '' ? text : result + text;
				}
			}
		}
		var oriText = $('#textEdit').val();
		if ((!oriText) && (result.substring(0, 2) == "\r\n")) {
			result = result.substring(2);
		}
		
		var resultTxt = !!oriText ? oriText + ' ' + result : result;
		$('#textEdit').val(resultTxt);
		//var resultTxt = !!oriText ? oriText + ' ' + result : result;
		//$('#textEdit',parent.document).val(resultTxt);
		//updatePreview($("#textEdit", parent.document)[0], result, getCursortPosition($("#textEdit", parent.document)[0]));
	}
	
	
	
	
	

	
	/**
	 * @description: 初始化执行记录信息
	 */
	function initExec() {
		var inHospDate = getInHospDateTime(EpisodeID);
	    $('#execStartDate').datebox('setValue', inHospDate);
	    $('#execEndDate').datebox('setValue', 'Today');
	    var configID=$("#Exec").attr("config")
		$cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetNursingRecordConfig",
	        ConfigID:configID
	    }, function (jsonData) {
	    	//organizeColumns('groupExec',jsonData);
	        $HUI.datagrid('#execGrid', {
	            url: $URL,
	            queryParams:{
		        	ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					StartDate:$('#execStartDate').datebox("getValue"),
					EndDate:$('#execEndDate').datebox("getValue")
		        },
	            rownumbers: true,
	            //singleSelect: true,
	            fitColumns:true,
	            columns: jsonData.columns
	        });
	        $('#btnOkExec').unbind("click").bind('click', {gridID: 'execGrid', template: jsonData.template},sureFormatRecordHandler);
	        $('#btnSearchExec').bind('click',function(e) {
	        	$('#execGrid').datagrid('reload', {
		        		ClassName: "Nur.SHIFT.Service.ShiftBizV2",
						MethodName: "GetNursingRecordData",
						EpisodeID: EpisodeID,
						ConfigID: configID,
						StartDate:$('#execStartDate').datebox("getValue"),
						EndDate:$('#execEndDate').datebox("getValue")
		        });
	        });       
	    });
	}
	/**
	 * @description: 初始化检验信息
	 */
	function initLis() {
		var layoutHeight=$('#layoutLis').layout('panel','center').panel('options').height;
		$('#layoutLisGrid').layout('panel','north').panel('resize',{height:layoutHeight - 40});
		$('#layoutLisGrid').layout('resize');
		var inHospDate = getInHospDateTime(EpisodeID);
	    $('#lisStartDate').datebox('setValue', inHospDate);
	    $('#lisEndDate').datebox('setValue', 'Today');
	    $HUI.datagrid('#lisGrid', {
	        url: $URL,
	        queryParams: {
		    	ClassName: "Nur.SHIFT.Service.ShiftDataBridge",
				QueryName: "GetLabOrdList",
				EpisodeID: EpisodeID,
				QDate:$('#lisStartDate').datebox("getValue"),
				EndDate:$('#lisEndDate').datebox("getValue"),
				rows:1000
		    },
		    columns:[[
				{field:'ID',title:'ID',hidden:true},
				{field:'OrdDateTime',title:'开立时间',width:200},
				{field:'ARCIMDesc',title:'检验名称',width:150},
			]],
	        rownumbers: true,
	        singleSelect: true,
	        fitColumns: true,
			loadMsg: '正在加载信息...',
	        onClickRow: function (rowIndex, rowData) {
	            initLisSub(rowData.ID);
	        }
	     });
	     $('#btnSearchLis').bind('click', function (e) {
	         $('#lisGrid').datagrid('reload',{
		     	ClassName: "Nur.SHIFT.Service.ShiftDataBridge",
				QueryName: "GetLabOrdList",
				EpisodeID: EpisodeID,
				QDate:$('#lisStartDate').datebox("getValue"),
				EndDate:$('#lisEndDate').datebox("getValue")
		     });
	     });
	}
	/**
	 * @description: 初始化检验结果信息
	 */
	function initLisSub(ID) {
		var layoutHeight=$('#layoutLis').layout('panel','center').panel('options').height;
		$('#layoutLisGrid').layout('panel','north').panel('resize',{height:layoutHeight * 0.5});
		$('#layoutLisGrid').layout('resize');
		var configID=$("#Lis").attr("config")
	    $cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetNursingRecordConfig",
	        ConfigID:configID
	    }, function (jsonData) {
	        $HUI.datagrid('#lisSubGrid', {
	            url: $URL,
	            queryParams: {
		        	ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					RecordID:ID
		        },
	            rownumbers: true,
	            fitColumns: true,
	            columns: jsonData.columns
	        });
	        $('#btnOkLis').unbind("click").bind('click', {gridID: 'lisSubGrid', template: jsonData.template},sureFormatRecordHandler);
	    });
	}
	/**
	 * @description: 初始化检查信息
	 */
	function initPacs() {
		var layoutHeight=$('#layoutPacs').layout('panel','center').panel('options').height;
		$('#layoutPacsGrid').layout('panel','north').panel('resize',{height:layoutHeight});
		$('#layoutPacsGrid').layout('resize');
		var inHospDate = getInHospDateTime(EpisodeID);
	    $('#pacsStartDate').datebox('setValue', inHospDate);
	    $('#pacsEndDate').datebox('setValue', 'Today');
	        $('#pacsGrid').datagrid({
	            url: $URL,
	            queryParams: {
		    		ClassName: "web.DHCAPPSeePatPacs",
					MethodName: "GetLisInspectOrdNew",
					page:1,
					rows:1000,
					Params:EpisodeID+"^^"+$('#pacsStartDate').datebox("getValue")+"^"+$('#pacsEndDate').datebox("getValue")+"^"
		    	},
	            rownumbers: true,
	            singleSelect: true,
	            fitColumns: true,
				loadMsg: '正在加载信息...',
	            columns:[[
					{field:'OEORIId',title:'ID',hidden:true},
					{field:'strOrderDate',title:'开立时间',width:200},
					{field:'strOrderName',title:'检查名称',width:150},
					{field:'ItemStatus',title:'状态',width:100},
				]],
	            onClickRow: function (rowIndex, rowData) {
					initPacsSub(rowData.OEORIId);
	            }
	        });
	        $('#btnSearchPacs').bind('click', function (e) {
	            	$('#pacsGrid').datagrid('reload', {
		        		ClassName: "web.DHCAPPSeePatPacs",
						MethodName: "GetLisInspectOrdNew",
						page:1,
						rows:1000,
						Params:EpisodeID+"^^"+$('#pacsStartDate').datebox("getValue")+"^"+$('#pacsEndDate').datebox("getValue")+"^"
		        });
	            
	        });
	}
	/**
	 * @description: 初始化检查具体结果
	 * @param {className,methodName,oeoreId} 
	 */
	function initPacsSub(oeoreId) {
		var layoutHeight=$('#layoutPacs').layout('panel','center').panel('options').height;
		$('#layoutPacsGrid').layout('panel','north').panel('resize',{height:layoutHeight * 0.5});
		$('#layoutPacsGrid').layout('resize');
	    var configID=$("#Pacs").attr("config")
	    $cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetNursingRecordConfig",
	        ConfigID:configID
	    }, function (jsonData) {
	        $HUI.datagrid('#pacsSubGrid', {
	            url: $URL,
	            queryParams: {
		        	ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					RecordID:oeoreId
		        },
		        nowrap:false,
	            rownumbers: true,
	            fitColumns: true,
	            columns: jsonData.columns
	        });
	        $('#btnOkPacs').unbind("click").bind('click',{gridID: 'pacsSubGrid', template: jsonData.template}, sureFormatRecordHandler);
	    });
	}
	/**
	 * @description: 初始化生命体征
	 */
	function initObservation() {
		var inHospDate = getInHospDateTime(EpisodeID);
	    $('#obsStartDate').datebox('setValue', inHospDate);
	    $('#obsEndDate').datebox('setValue', 'Today');
	    var configID=$("#Observation").attr("config")
	    $cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetNursingRecordConfig",
	        ConfigID:configID
	    }, function (jsonData) {
	        $HUI.datagrid('#obsGrid', {
	            url: $URL,
	            queryParams: {
		        	ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					StartDate:$('#obsStartDate').datebox("getValue"),
					EndDate:$('#obsEndDate').datebox("getValue"),
		        },
	            rownumbers: true,
	            singleSelect: true,
	            fitColumns: true,
	            columns: jsonData.columns
	        });
	        $('#btnOkObs').unbind("click").bind('click', {gridID: 'obsGrid', template: jsonData.template},sureFormatRecordHandler);
	        $('#btnSearchObs').bind('click',function(e) {
	        	$('#obsGrid').datagrid('reload', {
		        	ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					StartDate:$('#obsStartDate').datebox("getValue"),
					EndDate:$('#obsEndDate').datebox("getValue")
		        });
	        }); 
	    });
	}
	/**
	 * @description: 初始化历史交班
	 */
	function initHistory() {
	    $('#hisDate').datebox('setValue', 'Today');
	    $HUI.datagrid('#hisGrid', {
	            url: $URL,
	            queryParams: {
		        	ClassName: "Nur.SHIFT.Service.ShiftDataBridge",
					QueryName: "QueryShiftRecord",
					WardID: WardID,
					EpisodeID: EpisodeID,
					QDate:$('#hisDate').datebox("getValue")
		        },
	            rownumbers: true,
	            singleSelect: true,
	            fitColumns: true,
	            columns:[[  
        			{field:'name',title:'班次',width:100},  
        			{field:'record',title:'交班记录',width:400}
    			]] 
	        });
	        $('#btnOkHis').unbind("click").bind('click', {gridID: 'hisGrid', template: ""},sureFormatRecordHandler);
	        $('#btnSearchHis').bind('click',function(e) {
	        	$('#hisGrid').datagrid('reload', {
		        	ClassName: "Nur.SHIFT.Service.ShiftDataBridge",
					QueryName: "QueryShiftRecord",
					WardID: WardID,
					EpisodeID: EpisodeID,
					QDate:$('#hisDate').datebox("getValue")
		        });
	        }); 
	}
	/**
	 * @description: 初始化电子病历
	 */
	function initEpr() {
		$cm({
	        ClassName: GV.ClassName,
	        MethodName: "getEmrSettings"
	    }, function (jsonData) {
	    	organizeColumns('groupEpr',jsonData);
	        $HUI.datagrid('#eprGrid', {
	            url: $URL,
	            queryParams: initConditions(jsonData),
	            rownumbers: true,
	            singleSelect: false,
	            pagination: true,
	            pageSize: GV.PageRowNum,
	            pageList: [GV.PageRowNum, 20, 30],
	            frozenColumns: jsonData.frozenColumns,
	            columns: jsonData.columns
	        });        
	    });
	}
	/**
	 * @description: 初始化特殊符号
	 */
	function initChar() {
		$cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetSpecialSymbol",
	        HospitalID: session['LOGON.HOSPID']
	    }, function (jsonData) {
	        $("#kw").keywords({
			    singleSelect:true,
			    items:jsonData,
			    onClick:function(v){
					var oriText = $('#textEdit').val();
					$('#textEdit').val(oriText + ' ' + v.text);
			    }
			});
	    });
	}
	/**
	 * @description: 初始化固定格式护理记录
	 */
	function initFormatRecords(configID) {
		//initTemplateTree();
		initFormatRecordsGrid(configID);
	}
	/**
	 * @description: 初始化模板树
	 */
	function initTemplateTree() {
		$HUI.tree('#effictTemplateTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.NursingRecords",
					MethodName: "getTemplates",
					HospitalID: "",
					LocID: session['LOGON.CTLOCID'],
					EpisodeID: EpisodeID,
					RangeFlag: 'S',
					SearchInfo: $HUI.searchbox('#searchTemplate').getValue()
				}, function(data) {
					success(data);
				});
			},
			// lines: true,
			autoNodeHeight: true,
			onClick: function (node) {
				if (!!node.id) {
					initFormatRecordsGrid(node.id);
				}else{
					$.messager.prompt({msg:'节点错误！', type: 'error', timeout: 1000});
				}
			}
		});
	}
	/**
	 * @description: 初始化护理记录(固定格式)
	 */
	function initFormatRecordsGrid(configID) {
		var inHospDate = getInHospDateTime(EpisodeID);
	    $('#nrStartDate'+configID).datebox('setValue', inHospDate);
	    $('#nrEndDate'+configID).datebox('setValue', 'Today');
		$cm({
	        ClassName: "Nur.SHIFT.Service.ShiftBizV2",
	        MethodName: "GetNursingRecordConfig",
			ConfigID: configID
	    }, function (rs) {
		    var columns=rs.columns;
			$HUI.datagrid('#nr'+configID+"Grid",{
				url: $URL,
				queryParams: {
					ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					StartDate:$('#nrStartDate'+configID).datebox("getValue"),
					EndDate:$('#nrEndDate'+configID).datebox("getValue")
				},
				columns: columns,
				rownumbers:true,
				singleSelect:true,
				width:500
			});
			$('#btnOkNr'+configID).unbind("click").bind('click', {gridID: 'nr'+configID+'Grid',template:rs.template}, sureFormatRecordHandler);
		});
		$('#btnSearchNr'+configID).bind('click',function(e) {
			$('#nr'+configID+'Grid').datagrid({
    			queryParams: {
        			ClassName: "Nur.SHIFT.Service.ShiftBizV2",
					MethodName: "GetNursingRecordData",
					EpisodeID: EpisodeID,
					ConfigID: configID,
					StartDate:$('#nrStartDate'+configID).datebox("getValue"),
					EndDate:$('#nrEndDate'+configID).datebox("getValue")
    			}
			});
	    });
	}

	/**
	 * @description: 初始化模板下拉
	 */
	function initComboTemplates() {
		$("#templates").lookup({
			width:200,
			panelWidth:500,
			panelHeight:420,
//			url: $URL + "?ClassName=NurMp.KnowledgeDataBase&MethodName=GetTemplatesJson&HospitalID=" + session['LOGON.HOSPID'] + "&LocID=" + session['LOGON.CTLOCID'] + "&EpisodeID=" + EpisodeID,
			url: $URL + "?ClassName=NurMp.Service.Refer.Handle&MethodName=GetTemplatesJson&HospitalID=&LocID=" + session['LOGON.CTLOCID'] + "&EpisodeID=" + EpisodeID,
			mode:'remote',
			idField:'Guid',
			textField:'Text',
			columns:[[  
				{field:'Text',title:'名称',width:200},
				{field:'Guid',title:'GUID',width:200},    
				{field:'Id',title:'ID',width:50}  
			]],
			pagination:true,
			pageSize: 10,
			pageList: [10],
			onSelect:function(index,rowData){
				initTemplateElementGrid(rowData.Guid);
			},
			onBeforeLoad: function(param){
				param.SearchInfo=param.q;
				return true;
			},
			isCombo:true,
			enableNumberEvent:true,
			minQueryLen:3,
		});
	};
	/**
	 * @description: 获取入院时间
	 * @param {episodeID} 
	 * @return: inDate
	 */
	function getInHospDateTime(episodeID) {
	    var inDate = 'Today';
	    var inDate = $m({
	        ClassName: 'Nur.CommonInterface.Patient',
	        MethodName: 'getInHospDateTime',
	        episodeID: episodeID
	    }, false);
	    return inDate == '' ? 'Today' : inDate;
	}
	
	/**
	 * @description: 组织列
	 */
	function organizeColumns(domID, jsonData) {
		var columnData = [];
		var colNo = 0;
		$('#' + domID).empty();
		if (!!jsonData.frozenColumns) {
			var frozenColumns = jsonData.frozenColumns[0];
		    $.each(frozenColumns, function(index, column) {
		    	if (typeof column.title != 'undefined') {
		    		//判断是否包含有中文
					var ifHasCN=/[\u4E00-\u9FA5]+/.test(column.title);
					var ifIdCol = column.title.toString().indexOf("ID");
			    	if ((ifHasCN)&&(ifIdCol<0)&&(column.field != 'checkbox')) {
			    		if (colNo < 3) {
				    		columnData.push({id:domID + column.field,text:column.title,selected:true});
				    	}else{
					    	columnData.push({id:domID + column.field,text:column.title});
					    }
					    colNo += 1;
			    	}
		    	}
		    });
		} 
		if (!!jsonData.columns) {  
		    var customColumns = jsonData.columns[0];
		    $.each(customColumns, function(index, column) {
		    	if (typeof column.title != 'undefined') {
		    		//判断是否包含有中文
					var ifHasCN=/[\u4E00-\u9FA5]+/.test(column.title);
					var ifIdCol = column.title.toString().indexOf("ID");
			    	if ((ifHasCN)&&(ifIdCol<0)&&(column.field != 'checkbox')) {
			    		if (colNo < 3) {
				    		columnData.push({id:domID + column.field,text:column.title,selected:true});
				    	}else{
					    	columnData.push({id:domID + column.field,text:column.title});
					    }
					    colNo += 1;
			    	}
		    	}
		    });
		}
		$('#' + domID).keywords({
		    singleSelect: false,
		    items: columnData
		});
	    $.parser.parse('#' + domID);
	}
	/**
	 * @description: 初始化查询条件
	 */
	function initConditions() {
	    var jsonData = arguments[0] || '';
	    var idStDate = arguments[1] || '';
	    var idEndDate = arguments[2] || '';
	    var oeoreId = arguments[3] || '';
	    var labNo = arguments[4] || '';
	    var nodeId = arguments[5] || '';
	    var idOrderType =  arguments[6] || '';
		var reportId =  arguments[7] || '';
		var orderMeth =  arguments[8] || '';
		var medicineFlag =  arguments[9] || '';
		var allVisitFlag =  arguments[10] || '';
	    var startDate = idStDate !='' ? $('#' + idStDate).datebox('getValue') : '';
	    var endDate = idEndDate !='' ? $('#' + idEndDate).datebox('getValue') : '';
	    var orderType = !!idOrderType ? $('#' + idOrderType).combobox('getValue') : 'A';
		var orderMeth = !!orderMeth ? $('#' + orderMeth).combobox('getValue') : '';
		var allVisitFlag = !!allVisitFlag ? $('#' + allVisitFlag).radio('getValue') : '';
		var HospitalID = session['LOGON.HOSPID'];
		if (!!medicineFlag) {
			var isMedicine = $("#ckIsMedicine").radio('getValue');
		    var notMedicine = $("#ckNotMedicine").radio('getValue');
		    if (isMedicine && notMedicine) {
				medicineFlag = 'A';
			}else if (isMedicine && !notMedicine) {
				medicineFlag = 'R';
			}else if (!isMedicine && notMedicine) {
				medicineFlag = 'N';
			}else if (!isMedicine && !notMedicine) {
				medicineFlag = '';
			}
		}
	    eval(jsonData.paramsCommand);
	    return jsonData.queryParams;
	}
	/**
	 * @description: 选中内容,带入右侧内容Pannel
	 */
	function sureIntoHandler(e) {
		var result = '';
		var rows = $('#' + e.data.gridID).datagrid('getSelections');
		if (rows.length == 0) {
			$.messager.popover({msg: '请选择需要引入的内容！', type: 'error'});
			return;
		}
		//var isBoxs = $("input:checkbox[name=" + e.data.ulID + "]:checked");
		var wordsArr = $('#' + e.data.ulID).keywords('getSelected');
		if (wordsArr.length == 0) {
			$.messager.popover({msg: '请选择需要引入的列！', type: 'error'});
			return;
		}
		$.each(rows, function(index, row){
			var subResult = '';
			$.each(wordsArr, function(i,word){
				var checkName = word.id.substr(e.data.ulID.length);
				var itemData = eval("row." + checkName);
				if (e.data.gridID == 'obsGrid') {
					itemData = word.text + itemData;
				}
				subResult = !subResult ? itemData : subResult + ' ' + itemData;
			});
			result = !!result ? result + '，' + subResult : subResult;
		});
		transferToContent(result);
	}
	/**
	 * @description: 带入护理记录内容
	 */
	function sureFormatRecordHandler(e) {
		var gridID=e.data.gridID
		var template=""
		var result = '';
 		var rows = $('#'+gridID).datagrid('getSelections');
		if (rows.length == 0) {
			$.messager.popover({msg: '请选中记录！', type: 'error'});
			return;
		}
		var tempTPL=e.data.template
		var templateArr = tempTPL.split("@")
		var newTempArr = []
		for(j=0;j<templateArr.length;j++){
			var curTemplate = templateArr[j]
			for(i=0;i<rows.length;i++)
			{
				$.each(rows[i], function(field, value){
					if(tempTPL=="")
					{
						result = !!result ? result + ' ' + value : value;
					}else{
						if(templateArr[j].indexOf("{"+field+"}") > -1 && value.trim() != ""){
							curTemplate = curTemplate.replace("{"+field+"}",value);
						}
					}
				});
			}
			if(curTemplate != templateArr[j]) newTempArr.push(curTemplate.replace(/\{[^\}]*\}/g, "")) //Gzh 修改正则表达式)
		}
		template=template+" "+newTempArr.join(';')
		if(template!="")
		{
			result=template
		}
		transferToContent(result);
	}
	/**
	 * @description: 带入护理记录内容
	 */
	function sureFormatRecordHandler_old(e) {
		var gridID=e.data.gridID
		var template=""
		var result = '';
 		var rows = $('#'+gridID).datagrid('getSelections');
 		console.log(rows);
		if (rows.length == 0) {
			$.messager.popover({msg: '请选中记录！', type: 'error'});
			return;
		}
		for(i=0;i<rows.length;i++)
		{
			var tempTPL=e.data.template
			$.each(rows[i], function(field, value){
				if(tempTPL=="")
				{
					result = !!result ? result + ' ' + value : value;
				}else{
					tempTPL=tempTPL.replace("{"+field+"}",value);
					if(field.indexOf("Field")==0)
					{
						tempTPL=tempTPL.replace("{"+field.substring(5)+"}",value);
					}
				}
			});
			if(tempTPL!="")
			{
				tempTPL=tempTPL.replace(/\{[\s\S]+\}/g, "")
				template=template+" "+tempTPL
			}
		}
		if(template!="")
		{
			result=template
		}
		transferToContent(result);
	}

	/**
	 * @description: 转入内容
	 */
	function transferToContent(content) {
	    var editContent = $('#textEdit').val();
	    var contentTxt = !editContent ? content : editContent + '，' + content;
	   	$('#textEdit').val(contentTxt);
	}
	/**
	 * @description: 监听事件
	 */
	function listenEvents() {
		$('#btnOkKnow').bind('click',sureKnowHandler);
		$('#btnOkEpr').bind('click', {gridID: 'eprGrid', ulID: 'groupEpr'},sureIntoHandler);
		$('#searchTemplate').searchbox({
			searcher: function(value) {
				$HUI.tree('#effictTemplateTree','reload');
			}
		});
		$('#btnSearchFormatRecord').bind('click',function() {
			$HUI.tree('#effictTemplateTree','reload');
		});
		$('#btnSearchCustomRecord').bind('click',function() {
			$('#templateElementGrid').datagrid('reload');
		});
		$('#btnOkFormatRecord').bind('click', sureFormatRecordHandler);
	}

	$(init);

})();
