/**
 * 名称:	 通用参数设置
 * 编写人:	 zjb
 * 编写日期: 2022-04-26
 * scripts/dhcbillconfig/dhcbill.conf.generalconfig.js
 */

var HosID = PUBLIC_CONSTANT.SESSION.HOSPID;
var CV = {
			CfgRelaID:"",
			RelaCode: "",
			SrcClassName: "",
			SrcQueryName: "",
			CollDataSrcDicType: ""
		};
var $tgtObj ="";
var searchListKey="";
var SaveRelaType='';//0修改，1新增


$(function () {
   /*  PHA_COM.ResizePanel({
        layoutId: 'layout-right',
        region: 'south',
        height: 0.4
    }); */
    $("#searchTree").searchbox({
		searcher: function(value) {
			searchListKey=value;
			QueryTreeApp();
		}
	});
    $("#searchList").searchbox({
		searcher: function(value) {
			searchListKey=value;
			QueryGridProp();
		}
	});
    //InitDict();
    InitTreeApp();
    InitGridProp();
    InitGridPref();
    InitEvents();
});

// 事件
function InitEvents() {
    $('#btnAddProp,#btnEditProp').on('click', function () {
        ShowDiagProp(this);
    });
    $('#btnDelProp').on('click', DeleteProp);
    
    $('#btnEditPref').on('click', function () {
        ShowDiagPref('0');
    });
    $('#btnAddPref').on('click', function () {
        ShowDiagPref('1');
    });
    $('#btnDelPref').on('click', DeletePref);

    $('#btnImport').on('click', Import);
    $('#btnExport').on('click', Export);
}

// 字典
function InitDict() {
    // 检索别名
/*     PHA.SearchBox('#searchTree', {
        searcher: QueryTreeApp,
        placeholder: '可输入模块或参数的简拼、代码、名称...'
    }); */

    // 医院
    PHA.ComboBox('prefHosp', {
        url: PHA_STORE.CTHospital().url,
        onHidePanel: function (data) {
            LoadTypePointer();
        },
        width: 300
    });

    
    $("#hospital").combobox({
			panelHeight: 150,
			width: 300,
			url: $URL + '?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryHospList&ResultSetType=array',
			method: 'GET',
			valueField: 'id',
			textField: 'text',
			editable: false,
			blurValidValue: true,
			onLoadSuccess: function(data) {
				$(this).combobox("select", PUBLIC_CONSTANT.SESSION.HOSPID);
			},
			onChange: function(newValue, oldValue) {
				HosID = newValue;
				$(this).combobox("select", newValue);
				QueryGridProp();
				//setBasicOValue();
		}
	});
	
}

// 树-产品模块
function InitTreeApp() {
    $HUI.tree('#treeApp', {
	    lines:true,
	    animate:true,
        onClick: function (node) {
	        // $('#conAppAlias').searchbox('setValue','');
            if ((node.children || '') != '') {
                //$('#gridProp').datagrid('clear');
                //$('#gridProp').datagrid('loadData',node.children);
               /*  var curAppDesc = node.text || '';
                var curAppCode = node.attributes.code || '';
                var showStr = curAppDesc + ' [' + curAppCode + ']';
                $('#curAppCode').html('<b>' + showStr + '</b>'); */
            } else {
//	            choosedicCode = node.attributes.PCDicCode;
//                choosemodCode = node.attributes.PCModCode;
               
               /*  var curAppDesc = node.text || '';
                var curAppCode = node.attributes.CPModCode || '';
                var showStr = curAppDesc + ' [' + curAppCode + ']';
                $('#curAppCode').html('<b>' + showStr + '</b>'); */
                QueryGridProp();
            }
            
        },
        onLoadSuccess: function (node, data) {
            /* if (data.length == 0) {
                return;
            }
            var childrenData = data[0].children || [];
            if (childrenData.length == 0) {
                return;
            }
            var domId = childrenData[0].domId;
            $('#treeApp').tree('select', $('#' + domId)); */
        },
        onDblClick: function (data) {
			$(this).tree("toggle", data.target);
		}
    });
    QueryTreeApp(null);
}
function QueryTreeApp(p) {
    // 查询
    var SerchTreeCode = $('#searchTree').searchbox('getValue');
    $.cm(
        {
            ClassName: 'BILL.CFG.COM.GeneralCfg',
            MethodName: 'BuildTreeToGeneralConfigByProLine',//'BuildTreeToGeneralConfig',
            InputStr: SerchTreeCode
        },
        function (data) {
            $('#treeApp').tree({
                data: data
            });
            $('#gridProp').datagrid('clear');
        }
    );
  

  
  
}

// 右上表-参数
function InitGridProp() {
    var columns = [
        [
            {
                field: 'id',
                title: '参数Id',
                hidden: true,
                width: 100
            },
            {
                field: 'code',
                title: '代码',
                width: 180
            },
            {
                field: 'text',
                title: '配置点描述',
                width: 200,
                showTip: true,
                tipWidth: 150
            },
            {
                field: 'CRDTgtData',
                title: '默认值',
                width: 120,
                align: 'center'
                /* formatter: function (value, rowData, index) {
                    if (PHA_COM.Temp.PwdPropCode.indexOf(rowData.propCode) >= 0) {
                        return GetPassword(value);
                    }
                    return value;
                } */
            },
            {
                field: 'CPRemark',
                title: '备注',
                width: 450,
                showTip: true,
                tipWidth: 300
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        
        queryParams: {
            ClassName: 'BILL.CFG.COM.GeneralCfg',
            QueryName: 'QryCfgPointAndCfgRelaData'
        },
        pagination: false,
        columns: columns,
        fitColumns: true,
        nowrap: true,
        singleSelect:true,
        toolbar: '#gridPropBar',
        enableDnd: false,
        border:false,
        onSelect: function (rowIndex, rowData) {
	       /*  if(rowData.Parent!=undefined) 
	        {return} */
            $('#gridPref').datagrid('query', {
                RalaCode: rowData.CRDRelaCode
            });
            $(this).datagrid('options').selectedRowIndex = rowIndex;
        },
        onDblClickRow: function (rowIndex, rowData) {
            ShowDiagProp({ id: 'btnEditProp', text: '修改' });
        },
        onLoadSuccess: function (data) {
            $('#gridPref').datagrid('clear');
            if (data.total > 0) {
                var selRowIdx = $(this).datagrid('options').selectedRowIndex;
                if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
                    $(this).datagrid('selectRow', selRowIdx);
                } else {
                    $(this).datagrid('selectRow', 0);
                }
            }
        }
    };
	$HUI.datagrid("#gridProp",dataGridOption);
    //PHA.Grid('gridProp', dataGridOption);
}

// 右下表-参数值
function InitGridPref() {
    var columns = [
        [
            {
                field: 'RalaRowid',
                title: '参数值Id',
                hidden: true,
                width: 100
            },
            {
                field: 'HOSPDesc',
                title: '医院',
                width: 150
            },
            {
                field: 'CRDTgtData',
                title: '配置值',
                width: 80,
             	formatter: function(value,row,index){
	            	var gridPropSelect = $('#gridProp').datagrid('getSelected') || '';
				    if (gridPropSelect == '') {
				        return value;
				    }
				    else if (gridPropSelect.CPDataViewType=="combobox")
				    {
					    return row.CRDTgtDataDesc;
					}
					else
					{
						return value;
					}
	            } 
            },
            {
                field: 'EffectiveDate',
                title: '生效日期',
                width: 100
            },
            {
                field: 'ExpirationDate',
                title: '失效日期',
                width: 100
                /* formatter: function (value, rowData, index) {
                    var propCode = ($('#gridProp').datagrid('getSelected') || {}).propCode;
                    if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
                        return GetPassword(value);
                    }
                    return value; 
                }*/
            }
           /*  {
                field: 'prefStDate',
                title: '生效日期',
                width: 80
            } */
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'BILL.CFG.COM.GeneralCfg',
            QueryName: 'QryCfgRalaHosByRalaCode'
        },
        pagination: false,
        columns: columns,
        fitColumns: true,
        border:false,
        toolbar: '#gridPrefBar',
        enableDnd: false,
        singleSelect:true,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {
            //ShowDiagPref({ id: 'btnEditPref', text: '修改' });
        }
    };
	
	$HUI.datagrid("#gridPref",dataGridOption);
}

function QueryGridProp() {
    var treeSelect = $('#treeApp').tree('getSelected') || '';
    if (treeSelect == '') {
        return;
    }
    var appId = treeSelect.id;
    var choosedicCode = treeSelect.attributes.CPDicCode;
    var choosemodCode = treeSelect.attributes.CPModCode;
    var SerchType=treeSelect.Parent;
    if (SerchType=="0")
    {
	     var choosedicCode = treeSelect.attributes.code;
	     var choosemodCode ="";
	}
    var conAppAlias = $('#searchList').searchbox('getValue');
   /*  var chkQText = $('#chk-QText').checkbox('getValue');
    if (chkQText == false) {
        conAppAlias = '';
    } */
    $('#gridProp').datagrid('query', {
         dicCode: choosedicCode,
         modCode: choosemodCode,
         HosID: "",//HosID,
         cfgDesc:"",
         SerchType:SerchType,
         KeyCode:conAppAlias
    });
}

function ShowDiagProp(btnOpt) {
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var propId = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridProp').datagrid('getSelected') || '';
        if (gridSelect == '') {
            $.messager.popover({
                msg: '请先选中需要修改的参数',
                type: 'alert'
            });
            return;
        }
        propId = gridSelect.id;
    }
    var treeSelect = $('#treeApp').tree('getSelected') || '';
    if (treeSelect == '') {
        $.messager.popover({
            msg: '请先选中产品模块',
            type: 'alert'
        });
        return;
    }
    if (treeSelect.children) {
        PHA.Popover({
            msg: '请先选中该产品线下的产品模块',
            type: 'alert'
        });
        return;
    }

    
    if (ifAdd == false) {
        $('#diagProp_btnAdd').hide();
        $.cm(
            {
                ClassName: 'BILL.CFG.COM.GeneralCfg',
                QueryName: 'QryCfgPointByRowid',
                Rowid: propId,
            },
            function (arrData) {
                //PropPassword(arrData);
                $(".PropValHtml").children().remove();
                var DiagProphtml = "";
                var ptCode = arrData.rows[0].ptCode;
                var dataSrcViewType= arrData.rows[0].CPCollDataSrcViewType;
                var CRDRelaCode = arrData.rows[0].CRDRelaCode;
                var srcClassName = arrData.rows[0].srcClassName;
                var srcQueryName = arrData.rows[0].srcQueryName;
                var CPCollDataSrcDicType = arrData.rows[0].CPCollDataSrcDicType;
                var cftptCode = "cfg-" + ptCode;
                CV.CfgRelaID=arrData.rows[0].CfgRelaID;
                CV.RelaCode = arrData.rows[0].CRDRelaCode;
                CV.SrcClassName = arrData.rows[0].srcClassName;
                CV.SrcQueryName = arrData.rows[0].srcQueryName;
                CV.CollDataSrcDicType = arrData.rows[0].CPCollDataSrcDicType;
                document.getElementById("propCode").value = arrData.rows[0].ptCode;
                document.getElementById("propDesc").value = arrData.rows[0].ptDesc;
                document.getElementById("propMemo").value = arrData.rows[0].CPRemark;
                if (dataSrcViewType=="combobox") {
					DiagProphtml = "	<input id= 'cfg-" + ptCode +"' class='hisui-"+dataSrcViewType+ " textbox combobox-f combo-f'/>";
					/* DiagProphtml = DiagProphtml+ " data-options=\"panelHeight: 150, valueField:\'id\'," + "textField:"+"'text'," +"defaultFilter: 5,multiple: 0\"/>"; */
				}else if (dataSrcViewType=="numberbox") {
					DiagProphtml =  "<input id='cfg-" + ptCode + "' class='hisui-"+dataSrcViewType+" numberbox textbox'/>";
				}else if (dataSrcViewType=="datebox" || dataSrcViewType=="timespinner" || dataSrcViewType=="numberbox" || dataSrcViewType=="checkbox") {
					DiagProphtml =  "<input id='cfg-" + ptCode + "' class='hisui-"+dataSrcViewType+" textbox'/>";
						
				}else {
					DiagProphtml =  "<input id='cfg-"+ ptCode+"' class='textbox'/>";
				}
                ///
                $(".PropValHtml").prepend(DiagProphtml);
                
                $tgtObj = $("#cfg-" + ptCode); 
                
                var getHospId = getValueById("hospital");
                
                var relaId = $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetRelaDataId", relaCode: CRDRelaCode, sourceData: "", hospId: getHospId}, false);
                
                var getTgtData = getPropValById("CF_BILL_COM.CfgRelaData", relaId, "CRDTgtData");
                
				switch($tgtObj.prop("type")) {
				case "checkbox":
					setValueById($tgtObj[0].id, (getTgtData == 1));
					break;
				case "text":						
					if ($tgtObj.hasClass("combobox-f")) {
						
						var url = $URL + "?ClassName=" + srcClassName + "&QueryName=" + srcQueryName
						+ "&ResultSetType=array" + "&dicType=" + CPCollDataSrcDicType + "&hospId=" + getHospId;
					
					    $tgtObj.combobox({
							panelHeight: 150,
							width: 308,
							url: url,
							method: 'GET',
							valueField: 'id',
							textField: 'text',
							editable: false,
							blurValidValue: true,
							onLoadSuccess: function(data) {
								$(this).combobox("select", getTgtData);
							},
						});
						break;
					}
					if ($tgtObj.hasClass("numberbox")){
						$tgtObj.numberbox({
							min:0,
							width: 308,
							value:getTgtData
						});
					}
					setValueById($tgtObj[0].id, getTgtData);
					break;
				default:
					setValueById($tgtObj[0].id, getTgtData);
				}
                
                /* PHA.SetVals(arrData); */
            }
        );
    } else {
        var clearValueArr = ['propCode', 'propDesc', 'propVal'];
        PHA.ClearVals(clearValueArr);
    }
    $('#diagProp')
        .dialog({
            title: '参数' + btnOpt.text,
            iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
            modal: true
        })
        .dialog('open');
    $('#propCode').focus();
}
function getTgtValue() 
{
	var _tgtData = getValueById($tgtObj[0].id);
	switch($tgtObj.prop("type")) {
		case "checkbox":
			_tgtData = $tgtObj.checkbox("getValue") ? 1 : 0;
			break;
		case "text":
			if ($tgtObj.hasClass("combobox-f")) {
				if ($tgtObj.combobox("options").multiple) {
					_tgtData = String($tgtObj.combobox("getValues").join("^"));
				}
			}
			break;
		default:
	}
	return _tgtData;
}
function getHospId()
{
	return getValueById("hospital");
};
/**
 * @param {String} type 1(继续新增)
 */
function SaveProp(type) {
	$.messager.confirm("确定", "是否确认保存？", function(r) {
		if (!r) {
			return;
		}
		var relaAry = [];
		var _tgtData = getTgtValue();
		var rela = {
			CRDRelaCode: CV.RelaCode,
			CRDSourceData: "",
			CRDTgtData: _tgtData,
			CRDHospDR: ""
		};
		relaAry.push(JSON.stringify(rela));
				
		$.m({
			ClassName: "BILL.CFG.COM.GeneralCfg",
			MethodName: "SaveRelaData",
			relaCode: CV.RelaCode,
			sourceData: "",
			relaList: relaAry,
			hospId: "2"
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				$('#diagProp').dialog('close');
				QueryGridProp();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
			
		});
	});
	
    /* var title = $('#diagProp').panel('options').title;
    var ifAdd = title.indexOf('新增') >= 0 ? true : false;
    var propId = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridProp').datagrid('getSelected');
        propId = gridSelect.propId || '';
    }
    var getValueArr = ['propCode', 'propDesc', 'propVal'];
    var valsArr = PHA.GetVals(getValueArr);
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }
    var treeSelect = $('#treeApp').tree('getSelected');
    var appId = treeSelect.id;
    var saveRet = $.cm(
        {
            ClassName: 'PHA.SYS.AppProp.Save',
            MethodName: 'SaveProp',
            PropId: propId,
            DataStr: appId + '^' + valsStr,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('提示', saveInfo, saveVal);
        return;
    } else {
        PHA.Popover({
            msg: '保存成功',
            type: 'success',
            timeout: 500
        });
    }
    if (type == 1) {
        PHA.ClearVals(['propCode', 'propDesc', 'propVal']);
        $('#propCode').focus();
    } else {
        $('#diagProp').dialog('close');
    }
    QueryGridProp(); */
}
// 删除页面
function DeleteProp() {
    var gridSelect = $('#gridProp').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的参数',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var propId = gridSelect.propId || '';
    PHA.Confirm('删除提示', '您确认删除吗?', function () {
        var saveRet = $.cm(
            {
                ClassName: 'PHA.SYS.AppProp.Save',
                MethodName: 'DeleteProp',
                PropId: propId,
                dataType: 'text'
            },
            false
        );
        var saveArr = saveRet.split('^');
        var saveVal = saveArr[0];
        var saveInfo = saveArr[1];
        if (saveVal < 0) {
            PHA.Alert('提示', saveInfo, 'warning');
            return;
        } else {
            $.messager.popover({
                msg: '删除成功',
                type: 'success'
            });
            QueryGridProp();
        }
    });
}

//打开右下表编辑框，0修改，1增加
function ShowDiagPref(EditType) {
	
	SaveRelaType=EditType;
	
	var gridPropSelect = $('#gridProp').datagrid('getSelected') || '';
    if (gridPropSelect == '') {
        $.messager.popover({
            msg: '请先选中参数',
            type: 'alert'
        });
        return;
    }
    //修改
    var gridSelect='';
   	if(EditType=='0')
   	{
   		gridSelect = $('#gridPref').datagrid('getSelected') || '';
        if (gridSelect == '') {
            $.messager.popover({
                msg: '请先选中需要编辑的参数值',
                type: 'alert'
            });
            return;
        }
    }
    var publicFlag='0';//gridPropSelect.CPPublicFlag;
	    
    $("#HOSID").combobox({
		panelHeight: 150,
		//width: 300,
		url: $URL + '?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryHospList&PublicFlag='+publicFlag+'&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			
		},
		onSelect: function(newValue, oldValue) {9
			var RelaId=$.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetRelaDataId", relaCode: gridPropSelect.CRDRelaCode, sourceData: "", hospId: newValue.id}, false);
			var CRDTgtData=getPropValById("CF_BILL_COM.CfgRelaData", RelaId, "CRDTgtData");
			if(CRDTgtData != "" && EditType=='1')
			{
				$.messager.popover({
           			msg: '此院区已有配置值，保存将做修改操作。',
            		type: 'alert'
        		});
        		setValueById('CRDTgtDataDesc',CRDTgtData);
        		SaveRelaType='0';
			}
			else if(EditType=='1')
			{
				SaveRelaType='1';
			}
			$('#CRDTgtDataDesc').focus();
		}
	});
    //$("#CRDTgtDataDesc").removeClass();
    $("#InputType").children().remove();
    var htmlstr='';
    htmlstr="<td class=\"r-label\"><label>"+ gridPropSelect.text +"</label></td>";
    if(gridPropSelect.CPDataViewType=="combobox"){
   		htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"hisui-combobox textbox\"  autocomplete=\"off\" style=\"width:230px\" /></td>";
    }
    else if(gridPropSelect.CPDataViewType=="checkbox")
    {
	    htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"hisui-checkbox\" type=\"checkbox\"/></td>";
    }
    else if(gridPropSelect.CPDataViewType=="numberbox")
    {
	    htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"hisui-numberbox textbox\"  autocomplete=\"off\" style=\"width:230px\" /></td>";
	}
	else if(gridPropSelect.CPDataViewType=="datebox")
    {
	    htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"hisui-datebox textbox\"  autocomplete=\"off\" style=\"width:230px\" /></td>";
	}
	else if(gridPropSelect.CPDataViewType=="timespinner")
    {
	    htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"hisui-timespinner textbox\"  autocomplete=\"off\" style=\"width:230px\" /></td>";
	}
    else
    {
	    htmlstr+="<td><input id=\"CRDTgtDataDesc\" class=\"textbox\"  autocomplete=\"off\" style=\"width:230px\" /></td>";
	}
    $("#InputType").prepend(htmlstr);
    
    if(gridPropSelect.CPDataViewType=="combobox"&&gridPropSelect.CPTgtDataSrc=="Dictionary")
    {
	    var srcClassName="BILL.CFG.COM.DictionaryCtl";
		var srcQueryName="QryDicListByType";
		var dicType=gridPropSelect.CPTgtDataSrcDicType;
		
		$("#CRDTgtDataDesc").combobox({
			panelHeight: 150,
			//width: 200,
			url: $URL + '?ClassName=BILL.CFG.COM.DictionaryCtl&QueryName=QryDicListByType&dicType='+dicType+'&ResultSetType=array',
			method: 'GET',
			valueField: 'id',
			textField: 'text',
			editable: false,
			blurValidValue: true,
			onLoadSuccess: function(data) {
				if(EditType=='0')
				{
					setValueById('CRDTgtDataDesc',gridSelect.CRDTgtData);
				}
			},
			onChange: function(newValue, oldValue) {
				
			}
		});
		
	}
	else if(gridPropSelect.CPDataViewType=="numberbox")
	{
		$('#CRDTgtDataDesc').numberbox({
			min:0,
			precision:0
		});
	}
	else if(gridPropSelect.CPDataViewType=="datebox")
    {
	    $('#CRDTgtDataDesc').datebox({
			required:true
		});
	}
	else
	{
		setValueById('CRDTgtDataDesc','');
		/* $('#CRDTgtDataDesc').textbox({
			type:'text',
             //buttonText:'Search',
             //iconCls:'icon-man',
            conAlign:'left'
        }); */
	}
	setValueById('CPDesc',gridPropSelect.text);
	//修改
   	if(EditType=='0')
   	{
	    setValueById('HOSID',gridSelect.CRDHospDR);
	  /*   if(gridPropSelect.CPDataViewType=="combobox")
	    {
		    var RelaId=$.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetRelaDataId", relaCode: gridPropSelect.CRDRelaCode, sourceData: "", hospId: gridSelect.CRDHospDR}, false);
			var CRDTgtData=getPropValById("CF_BILL_COM.CfgRelaData", RelaId, "CRDTgtData");
			$("#CRDTgtDataDesc").combobox("setValue",CRDTgtData);
		}
		else
		{ */
	    	//setValueById('CRDTgtDataDesc',gridSelect.CRDTgtData);  
		//}
		//放在下拉框初始化成功后赋值，解决先赋值而延后显示描述的问题。
		if(gridPropSelect.CPDataViewType == "checkbox")
		{
			if(gridSelect.CRDTgtData=='1')
			{
				$('#CRDTgtDataDesc').prop('checked',true);
			}
			else
			{
				$('#CRDTgtDataDesc').prop('checked',false);
			}
		}
		else if(gridPropSelect.CPDataViewType != "combobox")
		{
			setValueById('CRDTgtDataDesc',gridSelect.CRDTgtData);  
		}
	    setValueById('CPActiveDateFrom',gridSelect.EffectiveDate);
	    setValueById('CPActiveDateTo',gridSelect.ExpirationDate);

	    $('#EditCfgRelaData')
	        .dialog({
	            title: '修改',
	            iconCls: 'icon-w-edit',
	            modal: true
	        })
	        .dialog('open');
   	}
   	else  //新增
   	{
	   	ClearPrefEdit();
	    $('#EditCfgRelaData')
	        .dialog({
	            title: '新增',
	            iconCls: 'icon-w-add',
	            modal: true
	        })
	        .dialog('open');
    }
}

//清空右下弹框内容
function ClearPrefEdit(){
	setValueById('HOSID','');
	setValueById('CRDTgtDataDesc','');
	setValueById('CRDTgtDataDesc','');
	setValueById('CRDTgtDataDesc','');
}

//0修改，1增加
function SaveRelaData() {
	
	var RelaCode='';
	var gridPropSelect = $('#gridProp').datagrid('getSelected') || '';
    if (gridPropSelect == '') {
        $.messager.popover({
            msg: '请先选中参数',
            type: 'alert'
        });
        return;
    }
    RelaCode=gridPropSelect.CRDRelaCode;
	if(getValueById('CRDTgtDataDesc') == "")
	{
		$.messager.popover({
            msg: '配置值不可为空',
            type: 'alert'
        });
        return;
	}
	
	//验证,原数据和当前数据不一致，先将原数据置失效
	var RelaId=$.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetRelaDataId", relaCode: RelaCode, sourceData: "", hospId: getValueById('HOSID')}, false);
	var CRDTgtData=getPropValById("CF_BILL_COM.CfgRelaData", RelaId, "CRDTgtData");
	if(CRDTgtData !== '' && CRDTgtData !== getValueById('CRDTgtDataDesc')&&SaveRelaType=='0')//与原配置值不同，修改操作
	{
		$.m({
			ClassName: "BILL.CFG.COM.GeneralCfg",
			MethodName: "DeleteRelaData",
			RelaCode: RelaCode,
			SrcData: "",
			TgtData: CRDTgtData,
			HospId: getValueById('HOSID')
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.popover({msg: "保存失败，原数据删除失败：" + (myAry[1] || myAry[0]), type: "error"});
				return;
			}
		});
	}
	else if(CRDTgtData !== '' && CRDTgtData === getValueById('CRDTgtDataDesc')&&SaveRelaType=='0')//与原配置值相同，修改操作
	{
		//0修改，1增加
		/* var msgstr='';
		if(SaveRelaType=='0')
		{msgstr='与原配置值相同，无需修改';}
		else
		{msgstr='与原配置值相同，无需增加';} */
		$.messager.popover({
            msg: '与原配置值相同，无需修改',
            type: 'alert'
        });
        return;
	}
	else if(CRDTgtData !== '' && SaveRelaType=='1')//与原配置值相同，新增操作
	{
		$.messager.popover({
            msg: '此院区已存在配置值，不可重复配置',
            type: 'alert'
        });
        return;
	}
	
	//组织入参
	var relaAry = [];
	var rela = {
		CRDTgtData: getValueById('CRDTgtDataDesc'),
		CRDActiveDateFrom: getValueById("activeDateFrom"),
		CRDActiveDateTo: getValueById("activeDateTo")
	};
	relaAry.push(JSON.stringify(rela));
	
	$.m({
		ClassName: "BILL.CFG.COM.GeneralCfg",
		MethodName: "SaveRelaData",
		RelaCode: RelaCode,
		SourceData: "",
		RelaList: relaAry,
		HospId: getValueById('HOSID')
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			$.messager.popover({msg: "保存成功", type: "success"});
			$('#gridPref').datagrid('reload');
			$('#EditCfgRelaData').dialog('close');
			return;
		}
		$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
	});
	
    //$('#gridPref').datagrid('reload');
}


function GetPassword(val) {
    val = val || '';
    var vl = val.toString().length;
    var pwdStr = '';
    for (var i = 0; i < vl; i++) {
        if (pwdStr == '') {
            pwdStr = '·';
        } else {
            pwdStr = pwdStr + '·';
        }
    }
    return '<b>' + pwdStr + '</b>';
}

function PropPassword(arrData) {
    if (arrData.length == 0) {
        return;
    }
    var firstRowData = arrData.rows[0];
    var propCode = firstRowData.propCode || '';
    if (propCode == '') {
        return;
    }
    if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
        $('#propVal').attr('type', 'password');
    } else {
        if ($('#propVal').attr('type') == 'password') {
            $('#propVal').removeAttr('type');
        }
    }
}

function PropPrefPassword(arrData) {
    if (arrData.length == 0) {
        return;
    }
    var selRowData = $('#gridProp').datagrid('getSelected') || {};
    var propCode = selRowData.propCode || '';
    if (propCode == '') {
        return;
    }
    if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
        $('#prefVal').attr('type', 'password');
    } else {
        if ($('#prefVal').attr('type') == 'password') {
            $('#prefVal').removeAttr('type');
        }
    }
}
