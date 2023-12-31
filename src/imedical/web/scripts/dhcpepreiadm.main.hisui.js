 //名称    dhcpepreiadm.main.hisui.js
 //功能    个人预约
 //日期  
 //创建人  yp

 var gUserId = session['LOGON.USERID'];
 var myCombAry = new Array();

 var editIndex = undefined;
 var NowRow = "";
 /*
 $.extend($.fn.datagrid.methods, {
             editCell: function(jq,param){
                 return jq.each(function(){
                     var opts = $(this).datagrid('options');
                     var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
                     for(var i=0; i<fields.length; i++){
                         var col = $(this).datagrid('getColumnOption', fields[i]);
                         col.editor1 = col.editor;
                         if (fields[i] != param.field){
                             col.editor = null;
                         }
                     }
                     $(this).datagrid('beginEdit', param.index);
                     for(var i=0; i<fields.length; i++){
                         var col = $(this).datagrid('getColumnOption', fields[i]);
                         col.editor = col.editor1;
                     }
                 });
             }
 });
 */

 $.extend($.fn.validatebox.defaults.rules, {
     mobile: { // 验证手机号码
         validator: function(value) {
             return /^(13|15|17|18)\d{9}$/i.test(value);
         },
         message: '手机号码格式不正确'
     }
 })

 var openSetWin = function(SetId) {

     $HUI.window("#SetWin", {
         title: "项目信息列表",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 600,
         height: 400
     });

     var QrySetWinObj = $HUI.datagrid("#QrySetWin", {
         url: $URL,
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true,
         queryParams: {
             ClassName: "web.DHCPE.Query.PreItemList",
             QueryName: "QueryPreItemList",
             AdmId: SetId,
             AdmType: "Ord",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']


         },
         columns: [
             [
                 { field: 'ItemDesc', width: '220', title: '项目名称' },
                 { field: 'ItemSetDesc', width: '240', title: '套餐' },
                 { field: 'TAccountAmount', width: '100', title: '应收金额', align: 'right' }
             ]
         ]

     })


 };

 function DeleteItemFromSet(value) {
     var OrdItemID = value.split("^")[0];
     var ItemStat = value.split("^")[1];
     var AdmID = OrdItemID.split("||");
     var ordEntId = value.split("^")[2];

     AdmID = AdmID[0];
     OrdSetID = ""
     if (ItemStat != 1) {
         $.messager.alert("提示", "项目状态错误不能删除!", "info");
         return false;

     }

     var flag = tkMakeServerCall("web.DHCPE.PreItemList", "IDeleteItem", AdmID, AdmType, OrdItemID, OrdSetID, "0");
     flag = flag.split("^")[0];
     if (flag == 1) {
         $.messager.alert("提示", "已经收费不能删除!", "info");
         return false;
     }
     if (flag == 2) {
         $.messager.alert("提示", "已经总检审核不能删除!", "info");
         return false;
     }
     if (flag == 3) {
         $.messager.alert("提示", "项目已执行不能删除!", "info");
         return false;
     }
     if (flag == 6) {
         $.messager.alert("提示", "已发药不能删除!", "info");
         return false;
     }
     if (flag == 7) {
         $.messager.alert("提示", "删除套餐内项目剩余套餐总价需要大于零!", "info");
         return false;
     }
     if (flag == 8) {
         $.messager.alert("提示", "不能在分组上删除定价套餐内项目,请选择人员操作!", "info");
         return false;
     }
     $("#QrySetWin").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: ordEntId, AdmType: AdmType + "Ord" });



     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", $("#PIADM_RowId").val(), AdmType);
     var myDiv = document.getElementById("TotalFee");
     myDiv.innerText = TotalAmount;


 }

 var UpdateSetWin = function(value) {

     var ordItemId = value.split("^")[0];

     var ordEntId = value.split("^")[1];

     $HUI.window("#SetWin", {
         title: "套餐项目信息列表",
         minimizable: false,
         collapsible: false,
         modal: true,
         width: 980,
         height: 600
     });

     var QrySetObj = $HUI.datagrid("#QrySetWin", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.Query.PreItemList",
             QueryName: "QueryPreItemList",
             AdmId: ordEntId,
             AdmType: AdmType + "Ord"

         },
         columns: [
             [

                 {
                     field: 'TItemId',
                     title: '操作',
					 align: 'center',
                     formatter: function(value, row, index) {
	                     return "<span style='cursor:pointer;padding-left:7px' class='icon-cancel' title='删除项目' onclick='DeleteItemFromSet(\"" + row.RowId + "^" + row.TItemStat + "^" + ordEntId + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='DeleteItemFromSet(\"" + row.RowId + "^" + row.TItemStat + "^" + ordEntId + "\")'>\
                    <img style='padding-left:7px;' title='删除项目' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    </a>";
                     }
                 },

                 { field: 'ItemDesc', width: '200', title: '项目名称' },
                 { field: 'ItemSetDesc', width: '200', title: '套餐' },
                 { field: 'TAccountAmount', width: '100', title: '应收金额', align: 'right' },
                 { field: 'TSpecName', width: '140', title: '样本' },
                 { field: 'TAddUser', width: '140', title: '操作员' },
                 { field: 'TPreOrAdd', width: '140', title: '项目类别' },
                 { field: 'TRecLocDesc', width: '140', title: '接收科室' }
             ]
         ],
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true

     })


 };




var openOccuWin = function(PreIADM) {
    $HUI.window("#OccuWin", {
		title: "危害因素",
		collapsible: false,
		minimizable: false,
		maximizable: false,
		modal: true,
		width: 600,
		height: 400
    });

    var QryOccuWinObj = $HUI.datagrid("#QryOccuWin", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCPE.OccupationalDisease",
            QueryName: "SerchEndangerItem",
            PreIADM: PreIADM,
            hospId: session['LOGON.HOSPID']
		},
        fitColumns: true,
        toolbar: [{
            iconCls: 'icon-save',
            text: $g('保存'),
            handler: function() {
                var selectrow = $("#QryOccuWin").datagrid("getChecked"); //获取的是数组，多行数据
				
                for (var i = 0; i < selectrow.length; i++) {
                    if (selectrow[i].SetsFlag == "Y") {
                        var ItemID = "";
                        var SetsID = selectrow[i].ArcimID;
                    } else {
                        var ItemID = selectrow[i].ArcimID
                        var SetsID = ""
					}

                    var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", PreIADM, AdmType, ItemID, PreOrAdd, SetsID);
                    if (IsAddPhc == "1") {
                        $.messager.alert("提示", "套餐中包含药品，" + ("PERSON" == AdmType ? "个人" : "分组") + "不允许加药", "info");
                        return false;
                    }
					
                    var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", PreIADM, "PERSON", ItemID, SetsID, session['LOGON.CTLOCID']);
                    var flagArr = flagret.split("^");
                    var flag = flagArr[0];
                    if ("1" == flag) {
                        if (flagArr[1] == "1") {
                            $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                                if (data) {
                                    var UserID = session['LOGON.USERID'];
                                    var ret = tkMakeServerCall("web.DHCPE.PreItemList", "IInsertItem", PreIADM, "PERSON", PreOrAdd, ItemID, SetsID, UserID);

                                    if (ret == "Notice") {
                                        $.messager.alert("提示", "已审核,加人加项需取消审核!" + (i + 1), "info");
                                        return false;
                                    }
                                    if (ret != "") {
                                        $.messager.alert("提示", "保存错误:" + flag, "info");
                                        return false;
                                    }
                                    $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: PreIADM, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                    $('#OccuWin').window('close');

                                    var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", PreIADM, AdmType);
                                    var myDiv = document.getElementById("TotalFee");
                                    myDiv.innerText = TotalAmount;
                                } else {
                                    return false;
                                }
                            });
                        } else {
                            $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                            return false;
                        }
                    }

                    if (flagArr[1] == "1") {
                        return false;
                    }

                    var UserID = session['LOGON.USERID'];
                    var flag = tkMakeServerCall("web.DHCPE.PreItemList", "IInsertItem", PreIADM, "PERSON", PreOrAdd, ItemID, SetsID, UserID);


                    if (flag == "Notice") {
                        $.messager.alert("提示", "已审核,加人加项需取消审核!" + (i + 1), "info");
                        return false;
                    }
                    if (flag != "") {
                        $.messager.alert("提示", "保存错误:" + flag, "info");
                        return false;
                    }
                    $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: PreIADM, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                    $('#OccuWin').window('close');

                    var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", PreIADM, AdmType);
                    var myDiv = document.getElementById("TotalFee");
                    myDiv.innerText = TotalAmount;
                }

            }
        }],
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [[
			{ field: 'NeedFlag', checkbox: true },
			{ field: 'ItemFlag', hidden: true },
			{ field: 'SetsFlag', hidden: true },
			{ field: 'ArcimID', hidden: true },
			{ field: 'ArcimCode', title: '项目代码' },
			{ field: 'ArcimDesc', title: '项目描述', width: 200},
			{ field: 'EndangerDesc', title: '对应危害因素', width: 200}
		]],
        pagination: true,
        displayMsg: "",
        pageSize: 20,
        fit: true,
        onLoadSuccess: function(data) {
            $('#QryOccuWin').datagrid('unselectAll');
            $("#QryOccuWin").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
            if (data) {
                $.each(data.rows, function(index, rowdata) {
                    if (rowdata.NeedFlag == "Y") {
                        $('#QryOccuWin').datagrid('checkRow', index);
                        $(".datagrid-row[datagrid-row-index=" + index + "] input[type='checkbox']").attr('disabled', 'disabled');
                        //$("input[type='checkbox']")[i + 2].disabled = true;
                    } else {
                        $('#QryOccuWin').datagrid('uncheckRow', index);
                    }
                });
            }
        }
    });
};


 var openNameWin = function(desc) {

     var NameWinObj = $HUI.window("#NameWin", {
         title: "信息列表",
         collapsible: false,
         modal: true,
         minimizable: false,
         maximizable: false,
         width: 800,
         height: 400
     });

     var QryNameLisObj = $HUI.datagrid("#QryNameWin", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.PreIBaseInfo",
             QueryName: "SearchPreIBaseInfoNew",
             PatName: desc,
             HospID: session['LOGON.HOSPID'],
             CTLocID: session['LOGON.CTLOCID']

         },
         columns: [
             [
                 { field: 'PIBI_RowId', hidden: true },
                 { field: 'PIBI_PAPMINo', width: '100', title: '登记号' },
                 { field: 'PIBI_Name', width: '80', title: '姓名' },
                 { field: 'PIBI_Sex_DR_Name', width: '60', title: '性别' },
                 { field: 'PIBI_DOB', width: '100', title: '出生日期' },
                 { field: 'PIBI_Married_DR_Name', width: '70', title: '婚姻状况' },
                 { field: 'PIBI_MobilePhone', width: '110', title: '电话号码' },
                 { field: 'PIBI_IDCard', width: '150', title: '身份证号' }

             ]
         ],
         onDblClickRow: function(rowIndex, rowData) {
             var pibi = rowData.PIBI_PAPMINo;
             $('#PAPMINo').val(pibi);
             RegNoOnChange();
             NameWinObj.close();
         },
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true

     })


 };

 function InitDisable() {

     $('#BEndanger').linkbutton('disable'); //危害因素

     //收费
     var GADM = tkMakeServerCall("web.DHCPE.HISUICommon", "GetGADMByIADM", PreAdmId);
     if ((AdmType == "TEAM") || ((AdmType == "PERSON") && (GADM != "") && (PreOrAdd == "PRE"))) {
         $("#OpenCharge").checkbox("disable");
         $("#OpenCharge").checkbox('setValue', false);
     } else if ((AdmType == "PERSON") && ((((GADM != "") && (PreOrAdd = "ADD")) || (GADM == "")))) {
         $("#OpenCharge").checkbox("enable");
     }

 }


 function InitCombobox() {

     //性别
     var SexObj = $HUI.combobox("#Sex_DR_Name", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
         valueField: 'id',
         textField: 'sex'
     })

     //证件类型
     var CardTypeObj = $HUI.combobox("#PAPMICardType_DR_Name", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
         valueField: 'id',
         textField: 'type'
     })

     //VIP等级
     var VIPObj = $HUI.combobox("#VIPLevel", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
         valueField: 'id',
         textField: 'desc',
         onSelect: function(record) {

             VIPLevelOnChange(record.id);
         }
     })

     //婚姻
     var MarriedObj = $HUI.combobox("#Married_DR_Name", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
         valueField: 'id',
         textField: 'married'
     })

     //站点
     var StationObj = $HUI.combobox("#StationID", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationBase&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'] + "&Type=" + "JC",
         valueField: 'id',
         textField: 'desc',
         onSelect: function(record) {

             $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), PreIADMID: $("#PIADM_RowId").val(), StationID: record.id, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         }
     });

     //体检类别
     var PatFeeObj = $HUI.combobox("#PatFeeType_DR_Name", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
         valueField: 'id',
         textField: 'desc'
     })

     //诊室位置
     var RoomPlaceObj = $HUI.combobox("#RoomPlace", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
         valueField: 'id',
         textField: 'desc',
         //mode:'remote',
         onBeforeLoad: function(param) {
             var VIP = $("#VIPLevel").combobox("getValue");
             param.VIPLevel = VIP;
             param.GIType = "I";
             param.LocID = session['LOGON.CTLOCID']
         }
     })

     //团体
     var PGADM_DR_NameObj = $HUI.combogrid("#PGADM_DR_Name", {
         panelWidth: 490,
         url: $URL + "?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
         mode: 'remote',
         delay: 200,
         pagination: true,
         pageSize: 20,
         pageList: [20, 50, 100],
         idField: 'Hidden',
         textField: 'Name',
         onBeforeLoad: function(param) {
             param.Code = param.q;
         },
         onChange: function() {
             PGTeam_DR_NameObj.clear();
             if ($("#PIADM_RowId").val() != "") {
                 $.messager.alert("提示", "预约后改变团体信息需要清屏之后重新预约！", "info");
                 Clear_click();
             }
         },
         columns: [
             [
                 { field: 'Hidden', hidden: true },
                 { field: 'Name', title: '团体名称', width: 110 },
                 { field: 'Code', title: '编码', width: 80 },
                 { field: 'Begin', title: '开始日期', width: 100 },
                 { field: 'End', title: '截止日期', width: 100 },
                 { field: 'DelayDate', title: '状态', width: 50 }


             ]
         ]
     });


     //分组
     var PGTeam_DR_NameObj = $HUI.combogrid("#PGTeam_DR_Name", {
         panelWidth: 400,
         url: $URL + "?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam",
         mode: 'remote',
         delay: 200,
         pagination: true,
         pageSize: 50,
         pageList: [20, 50, 100],
         idField: 'PGT_RowId',
         textField: 'PGT_Desc',
         onBeforeLoad: function(param) {

             var PreGId = $("#PGADM_DR_Name").combogrid("getValue");
             param.ParRef = PreGId;
             param.GTeam = param.q;
         },
         onChange: function() {
             if ($("#PIADM_RowId").val() != "") {
                 $.messager.alert("提示", "预约后改变分组信息需要清屏之后重新预约！", "info");
                 Clear_click();
             }
         },
         onShowPanel: function() {
             $('#PGTeam_DR_Name').combogrid('grid').datagrid('reload');
         },
         columns: [
             [
                 { field: 'PGT_RowId', hidden: true },
                 { field: 'PGT_ParRef_Name', title: '团体名称', width: 240 },
                 { field: 'PGT_Desc', title: '分组名称', width: 130 }
             ]
         ]
     });


     //检查种类
     var CategoryObj = $HUI.combobox("#Category", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindCategory&ResultSetType=array",
         valueField: 'id',
         textField: 'Category'
     })

     //行业
     var IndustryObj = $HUI.combobox("#Industry", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindIndustry&ResultSetType=array",
         valueField: 'id',
         textField: 'Industry'
     })

     //工种
     var TypeofworkObj = $HUI.combobox("#Typeofwork", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
         valueField: 'id',
         textField: 'Typeofwork'
     })

     //工种
     var ZYTypeofworkObj = $HUI.combobox("#ZYTypeofwork", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindTypeofwork&ResultSetType=array",
         valueField: 'id',
         textField: 'Typeofwork'
     })

     //防护措施
     var ProtectiveMeasureObj = $HUI.combobox("#ProtectiveMeasure", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindProtectiveMeasure&ResultSetType=array",
         valueField: 'id',
         textField: 'ProtectiveMeasure'
     })


     //接害因素
     var HarmInfoObj = $HUI.combotree("#HarmInfo", {
         url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
         checkbox: true,
         multiple: true,
         onlyLeafCheck: true
     });

     //饮酒史
     var AlcolHisObj = $HUI.combobox("#AlcolHis", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: '不饮酒', text: '不饮酒' }, { id: '偶饮酒', text: '偶饮酒' }, { id: '经饮', text: '经常饮' }],
         onSelect: function(record) {
             if (record.id == "不饮酒") {
                 $('#AlcolNo').numberbox("setValue", "");
                 $('#AlcolNo').attr("disabled", true);
                 $('#Alcol').numberbox("setValue", "");
                 $('#Alcol').attr("disabled", true);
             } else {
                 $('#AlcolNo').attr("disabled", false);
                 $('#Alcol').attr("disabled", false);
             }
         }
     });

     //吸烟史
     var SmokeHisObj = $HUI.combobox("#SmokeHis", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: '不吸烟', text: '不吸烟' }, { id: '偶吸烟', text: '偶吸烟' }, { id: '经吸', text: '经常吸' }],
         onSelect: function(record) {
             if (record.id == "不吸烟") {
                 $('#SmokeNo').numberbox("setValue", "");
                 $('#SmokeNo').attr("disabled", true);
                 $('#SmokeAge').numberbox("setValue", "");
                 $('#SmokeAge').attr("disabled", true);
             } else {
                 $('#SmokeNo').attr("disabled", false);
                 $('#SmokeAge').attr("disabled", false);
             }
         }
     });

     //放射史
     var HarmInfoObj = $HUI.combotree("#HarmInfo", {
         url: $URL + "?ClassName=web.DHCPE.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array",
         checkbox: true,
         multiple: true,
         onlyLeafCheck: true
     });

     $HUI.combobox("#OHRadiationFlag", {
         valueField: 'id',
         textField: 'text',
         selectOnNavigation: false,
         panelHeight: "auto",
         editable: false,
         data: [{ id: 'N', text: '否' }, { id: 'Y', text: '是' }],
         onSelect: function(record) {
             if (record.id != "Y") {
                 $('#OHRadiationType').val("").attr("disabled", true);
                 $('#OHRadiationDose').val("").attr("disabled", true);
                 $('#OHExRadHistory').val("").attr("disabled", true);
             } else {
                 $('#OHRadiationType').attr("disabled", false);
                 $('#OHRadiationDose').attr("disabled", false);
                 $('#OHExRadHistory').attr("disabled", false);
             }
         },
         onLoadSuccess: function(data) {}
     });


 }

 var init = function() {

     window.onresize = function() {
         window.location.reload();
     }

     $(window).bind('beforeunload', function() {

         if (AdmType == "TEAM") { var gteam = PreAdmId; }
         if (AdmType == "PERSON") { var gteam = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "GetGTeamByIADM", PreAdmId); }
         window.opener.$("#TeamPersonGrid").datagrid('load', { ClassName: "web.DHCPE.PreIADM", QueryName: "SearchGTeamIADM", GTeam: gteam, RegNo: "", Name: "", DepartName: "", OperType: "", Status: "" });
     });

     LoadCard();

     if (!AdmType) AdmType = "PERSON"
     if (!PreOrAdd) PreOrAdd = "PRE"


     var Status = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "GetPIADMStatus", PreAdmId, AdmType);
     if ((AdmType != "PERSON") || ((Status != "PREREG") && (Status != "PREREGED") && (Status != ""))) {

         $("#BRegister").hide();
     }


    // 极简 炫彩 样式调整
    ChangeHISUICss();

     $('#ZYBTab').tabs('disableTab', "基本信息");
     $('#ZYBTab').tabs('disableTab', "职业史");
     $('#ZYBTab').tabs('disableTab', "病史");
     $('#ZYBTab').tabs('disableTab', "职业病史");
     $('#ZYBTab').tabs('select', "体检项目");

     $('#ZYBTabItem').tabs('disableTab', "基本信息");
     $('#ZYBTabItem').tabs('disableTab', "职业史");
     $('#ZYBTabItem').tabs('disableTab', "病史");
     $('#ZYBTabItem').tabs('disableTab', "职业病史");
     $('#ZYBTabItem').tabs('select', "体检项目");

     InitDisable();

     InitCombobox();

     var myobj = document.getElementById("ReadRegInfo");
     if (myobj) {
         myobj.onclick = ReadRegInfo_OnClick;
     }

     var obj = document.getElementById('ReadCard');
     if (obj) obj.onclick = ReadCardClickHandler;

     $("#PAPMINo").val(PAPMINo);
     $("#AdmType").val(AdmType);


     $("#BSaveAmount").click(function() {

         BSaveAmount_click();

     });

     //复制项目
     $("#BCopyItem").click(function() {

         BCopyItem_click();
     });


     $("#BPreDate").click(function() {

         BPreDate_click();

     });

     $("#PAPMINo").change(function() {
         RegNoOnChange();
     });

     $("#PAPMINo").keydown(function(e) {

         if (e.keyCode == 13) {
             //保留change事件即可
             //RegNoOnChange();
         }

     });

     $("#OpenCharge").checkbox({


         onCheckChange: function(e, value) {

             OpenCharge_change(value);

         }
     });

     $("#IFeeAsCharged").checkbox({

         onCheckChange: function(e, value) {
             IFeeAsCharged_change(value)

         }
     });

     $("#Age").change(function() {

         AgeOnChange();
     });



     $("#CardNo").change(function() {
         CardNoOnChange();
     });

     /*
     $("#CardNo").keydown(function(e) {
         
         if(e.keyCode==13){
             CardNoOnChange();
         }
         
     });
     */

     $("#IDCard").change(function() {
         IDCardOnChange();
     });

     /*
     $("#IDCard").keydown(function(e) {
         
         if(e.keyCode==13){
             IDCardOnChange();
         }
         
     });
     */

     $("#BPhoto").click(function() {

         BPhoto_click();

     });

     // 预约时增加复查判断
     $("#Update").click(function() {
         if ($("#ReCheckFlag").checkbox('getValue')) {
             SelReviewRecord();
         } else {
             Save();
         }
     });

     // 复查勾选后VIP自动选为职业病
     $("#ReCheckFlag").change(function(chk) {
         if ($("#ReCheckFlag").checkbox("getValue")) {
             //$('#VIPLevel').combobox('setValue',5);
         }
     });

     //确认加项
     $("#ConfirmOrdItem").click(function() {

         ConfirmOrdItem_Click();

     });

     //刷新项目
     $("#BReload").click(function() {

         BReload_click();

     });


     // 危害因素
     $("#BEndanger").click(function() {
         BEndanger_Click();

     });
     // 基本信息
     $("#JBSave").click(function() {
         JBSave();
     });
     $("#JBNext").click(function() {
         JBNext();
     });
     // 职业史
     $("#ZYSave").click(function() {
         ZYSave();
     });
     $("#ZYDelete").click(function() {
         ZYDelete();
     });
     $("#ZYCancel").click(function() {
         ZYCancel();
     });
     $("#ZYNext").click(function() {
         ZYNext();
     });
     // 病史
     $("#BSSave").click(function() {
         BSSave();
     });
     $("#BSNext").click(function() {
         BSNext();
     });
     // 职业病史
     $("#ZYBSave").click(function() {
         ZYBSave();
     });
     $("#ZYBDelete").click(function() {
         ZYBDelete();
     });
     $("#ZYBCancel").click(function() {
         ZYBCancel();
     });
     $("#ZYBNext").click(function() {
         ZYBNext();
     });


     $("#BRegister").click(function() {

         Register();

     });



     $("#BClear").click(function() {

         Clear_click();

     });

     //删除项目
     $("#DeleteOrdItem").click(function() {
         DeleteOrdItem_Click();
     });

     //输入别名字母同步更新下面的项目
     $('#Set').on /*bind*/("input propertychange", function() {
         SetBFind_click();
     });

     $('#Item').on /*bind*/("input propertychange", function() {

         RisBFind_click();
     });

     $('#LisItem').on /*bind*/("input propertychange", function() {
         LisBFind_click();
     });


     $("#SetBFind").click(function() {
         SetBFind_click();
     });


     $("#Set").keydown(function(e) {

         if (e.keyCode == 13) {
             SetBFind_click();
         }
     });

     $("#Name").keydown(function(e) {

         if (e.keyCode == 13) {
             Name_keydown();
         }
     });
     $("#RisBFind").click(function() {
         RisBFind_click();

     });

     $("#Item").keydown(function(e) {

         if (e.keyCode == 13) {
             RisBFind_click();
         }
     });


     $("#LisBFind").click(function() {
         LisBFind_click();

     });

     $("#LisItem").keydown(function(e) {

         if (e.keyCode == 13) {
             LisBFind_click();
         }
     });

     $("#OtherBFind").click(function() {
         OtherBFind_click();

     });

     $("#OtherItem").keydown(function(e) {

         if (e.keyCode == 13) {
             OtherBFind_click();
         }
     });


     $("#MedicalBFind").click(function() {
         MedicalBFind_click();

     });

     $("#MedicalItem").keydown(function(e) {

         if (e.keyCode == 13) {
             MedicalBFind_click();
         }
     });
    
     
     $("#LisTab").tabs({
         toolPosition: "right",
         border: 1,
         tools: [{
             iconCls: 'icon-arrow-left',
             handler: function() {
                 $('#TPanel').layout('collapse', 'west');
				 $("#ZYBTab").tabs("resize");
                 $('#PreItemList').datagrid({
                     fitColumns: true
                 });
             }
         }]
     });

     $('#LisTab').tabs({
         border: 1,
         onSelect: function(title) {
             $("#QryOtherItm").datagrid('resize');
             $("#QryMedicalItm").datagrid('resize');
         }
     });

     $('#ItemLisTab').tabs({
         border: 1,
         onSelect: function(title) {
             $("#QryOtherItm").datagrid('resize');
             $("#QryMedicalItm").datagrid('resize');
         }
     });





     var ZYHistoryObj = $HUI.datagrid("#ZYHistory", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.OccupationalDisease",
             QueryName: "FindOccuHistory",
             PreIADM: ""
         },
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true,
         fitColumns: false,
         columns: [
             [
                 { field: 'TWorkTypeID', hidden: true, title: '工种id' },
                 { field: 'TProtectiveMeasureID', hidden: true, title: '防护id' },
                 { field: 'TStartDate', width: '100', title: '开始日期' },
                 { field: 'TEndDate', width: '100', title: '结束日期' },
                 { field: 'TWorkPlace', width: '200', title: '工作单位' },
                 { field: 'TWorkDepartment', width: '120', title: '部门' },
                 { field: 'TWorkShop', width: '100', title: '车间' },
                 { field: 'TWorkTeam', width: '100', title: '班组' },
                 { field: 'TWorkType', width: '100', title: '工种' },
                 { field: 'TDailyWorkHours', width: '100', title: '每日工时数' },
                 { field: 'THarmfulFactor', width: '200', title: '接触危害' },
                 { field: 'TProtectiveMeasure', width: '100', title: '防护措施' },
                 {
                     field: 'TRadiationFlag',
                     width: '70',
                     title: '放射史',
                     formatter: function(value, row, index) {
                         return value == "Y" ? "是" : "否";
                     }
                 },
                 { field: 'TRadiationType', width: '100', title: '放射线种类' },
                 { field: 'TRadiationDose', width: '100', title: '累积受照剂量' },
                 { field: 'TExRadHistory', width: '100', title: '过量照射史' },
                 { field: 'TRemark', width: '150', title: '备注' }
             ]
         ],
         onClickRow: function(rowIndex, rowData) {
             setValueById("StartDate", rowData.TStartDate);
             setValueById("EndDate", rowData.TEndDate);
             setValueById("WorkPlace", rowData.TWorkPlace);
             setValueById("WorkDepartment", rowData.TWorkDepartment);
             setValueById("WorkShop", rowData.TWorkShop);
             setValueById("ZYTypeofwork", rowData.TWorkTypeID);
             setValueById("DailyWorkHours", rowData.TDailyWorkHours);
             setValueById("HarmfulFactor", rowData.THarmfulFactor);
             setValueById("ProtectiveMeasure", rowData.TProtectiveMeasureID);
             setValueById("WorkTeam", rowData.TWorkTeam);
             setValueById("OHRadiationFlag", rowData.TRadiationFlag);

             if (rowData.TRadiationFlag != "Y") {
                 $('#OHRadiationType').attr("disabled", true);
                 $('#OHRadiationDose').attr("disabled", true);
                 $('#OHExRadHistory').attr("disabled", true);
             } else {
                 $('#OHRadiationType').attr("disabled", false);
                 $('#OHRadiationDose').attr("disabled", false);
                 $('#OHExRadHistory').attr("disabled", false);
             }
             setValueById("OHRadiationType", rowData.TRadiationType);
             setValueById("OHRadiationDose", rowData.TRadiationDose);
             setValueById("OHExRadHistory", rowData.TExRadHistory);
             setValueById("OHRemark", rowData.TRemark);
         }
     });

     var ZYBHistoryObj = $HUI.datagrid("#ZYBHistory", {
         url: $URL,
         queryParams: {
             ClassName: "web.DHCPE.OccupationalDisease",
             QueryName: "FindOccuDiseaseHistory",
             PreIADM: ""
         },
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         fit: true,
         fitColumns: true,
         columns: [
             [
                 { field: 'TDiseaseDesc', width: '100', title: '病名' },
                 { field: 'TDiagnosisDate', width: '100', title: '诊断日期' },
                 { field: 'TDiagnosisPlace', width: '150', title: '诊断单位' },
                 { field: 'TProcess', width: '150', title: '治疗经过' },
                 { field: 'TReturn', width: '120', title: '归转' }
                 //{field:'TIsRecovery',width:'200',title:'是否痊愈'}
             ]
         ],
         onClickRow: function(rowIndex, rowData) {
             setValueById("DiseaseDesc", rowData.TDiseaseDesc);
             setValueById("DiagnosisDate", rowData.TDiagnosisDate);
             setValueById("DiagnosisPlace", rowData.TDiagnosisPlace);
             setValueById("Process", rowData.TProcess);
             setValueById("Return", rowData.TReturn);
         }
     });


     var QrySetObj = $HUI.datagrid("#QrySet", {
         url: $URL,
		 fitColumns: true,
         pagination: true,
         pageSize: 20,
         displayMsg: "",
         showPageList:false, 
   		 showRefresh:true,
         fit: true,
         queryParams: {
             ClassName: "web.DHCPE.HandlerOrdSetsEx",
             QueryName: "queryOrdSet",
             Set: "",
             Type: "ItemSet",
             AdmId: PreAdmId,
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID'],
             UserID: session['LOGON.USERID']



         },
         onDblClickRow: function(rowIndex, rowData) {
             var RowIdStr = $("#PIADM_RowId").val()

             if (RowIdStr == "") {
                 $.messager.alert("提示", "请先预约！", "info");
                 return false;
             }
             var AdmIdStr = RowIdStr.split("^");
             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var RowId = AdmIdStr[i];
                 var SetId = rowData.OrderSetId;
                 $("#Set").select();
                 var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
                 if (GAAuditedFlag == "1") {
                     $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
                     return false;
                 }

                 var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
                 var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
                 var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
                 if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
                     $.messager.alert("提示", "已经收表,不能加项", "info");
                     return false;
                 }

                 var SetSexFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsSetSex", RowId, AdmType, SetId);
                 var SetSexCanFlag = SetSexFlag.split("^")

                 if (SetSexCanFlag[0] == "1") {
                     $.messager.alert("提示", SetSexCanFlag[1], "info");
                     return false;
                 }

                 var IsExistStopItem = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistARCSets", SetId);
                 if (IsExistStopItem != "") {
                     //判断套餐是不是包含已经停止的医嘱，存在已经停止的医嘱不允许预约，需要修改套餐后进行预约
                     $.messager.alert("提示", "存在已停止医嘱项：" + IsExistStopItem + ", 需要把套餐内已停医嘱项删除后方可预约", "info");
                     return false;
                 }

                 var IsExistRecLocStr = tkMakeServerCall("web.DHCPE.HISUICommon", "ExistRecLocByOrdSets", SetId, session['LOGON.CTLOCID']);
                 var RecLocFlag = IsExistRecLocStr.split("$")[0];
                 var ARCIMDesc = IsExistRecLocStr.split("$")[1];
                 if (RecLocFlag == "0") {
                     $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室，请与信息中心联系!", "info");
                     return false;

                 }

                 var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, "", PreOrAdd, SetId);
                 if (IsAddPhc == "1") {
                     if ("PERSON" == AdmType) {
                         $.messager.alert("提示", "套餐中包含药品，个人不允许加药", "info");
                         return false;
                     }
                     if ("TEAM" == AdmType) {
                         $.messager.alert("提示", "套餐中包含药品，分组不允许加药", "info");
                         return false;
                     }
                 }


                 var isetid = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItems", RowId, AdmType, SetId);
                 /*
                if("1"==isetid) {
            
                    $.messager.alert("提示","本次体检已有套餐,不能继续添加","info");
                    return false;
                }
                */

                 //套餐中是否药品和材料库存不足 
                 var Str = tkMakeServerCall("web.DHCPE.HISUICommon", "GetRMItemByARCOS", SetId);
                 if (Str != "") {

                     var ArcArr = Str.split("%%");
                     for (var i = 0; i < ArcArr.length; i++) {

                         var ArcID = ArcArr[i].split("^")[0];
                         var ArcDesc = ArcArr[i].split("^")[1];
                         var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ArcID, session['LOGON.CTLOCID']);
                         if (Invent == "0") {
                             $.messager.alert("提示", ArcDesc + "  库存不足，请查看库存！", "info");
                             return false;
                         }

                     }
                 }

                 var RepeatFlag = 0;
                 var RepeatFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsRepeatItem", RowId, SetId, AdmType)

                 //if("1"==isetid) {
                 //$.messager.confirm("操作提示", "本次体检已有套餐，是否继续增加？若继续添加，若已存在相同项目，该套餐会自动拆分！", 
                 if ("1" == RepeatFlag) {
                     $.messager.confirm("操作提示", "套餐中有重复的项目，是否将套餐中重复的项目自动删除？",

                         function(data) {
                             if (data) {
                                 var UserId = session['LOGON.USERID'];
                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": "",
                                     "ArcItemSetId": SetId,
                                     "UpdateUserId": UserId,
                                     "RepeatFlag": 1
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;

                                     } else {
                                         $.messager.alert("提示", jsonData.ret, "info");
                                     }
                                 });

                             } else {
                                 var UserId = session['LOGON.USERID'];
                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": "",
                                     "ArcItemSetId": SetId,
                                     "UpdateUserId": UserId,
                                     "RepeatFlag": 0
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;

                                     } else {
                                         $.messager.alert("提示", jsonData.ret, "info");
                                     }
                                 });
                             }
                         }
                     );

                 } else {
                     var UserId = session['LOGON.USERID'];
                     $.cm({
                         ClassName: "web.DHCPE.PreItemList",
                         MethodName: "HISUIIInsertItem",
                         "AdmId": RowId,
                         "AdmType": AdmType,
                         "PreOrAdd": PreOrAdd,
                         "ArcItemId": "",
                         "ArcItemSetId": SetId,
                         "UpdateUserId": UserId,
                         "RepeatFlag": 1
                     }, function(jsonData) {
                         if (jsonData.ret == "") {
                             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                             var myDiv = document.getElementById("TotalFee");
                             myDiv.innerText = TotalAmount;
                             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                             var myDiv = document.getElementById("ConfirmInfo");
                             myDiv.innerText = ConfirmInfo;

                         } else {
                             $.messager.alert("提示", jsonData.ret, "info");
                         }
                     });
                 }
             }

         },
        
         columns: [
             [{
                     field: 'OrderSetId',
                     title: '预览',
                     formatter: function(value, row, index) {
	                     return "<span style='cursor:pointer;padding-left:7px;' class='icon-eye' title='' onclick='openSetWin("+value+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='openSetWin(\"" +  + "\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
                    </a>";
                     }
                 },
                 { field: 'OrderSetDesc', title: '名称', width: 100 },
                 { field: 'OrderSetPrice', title: '金额', align: 'right' }
             ]
         ]
		 

     })

     var QryRisObj = $HUI.datagrid("#QryRisItm", {
         url: $URL,
		 fitColumns: true,
         pagination: true,
         pageSize: 20,
         displayMsg: "",
         showPageList:false, 
   		 showRefresh:true,
         fit: true,
         queryParams: {
             ClassName: "web.DHCPE.StationOrder",
             QueryName: "StationOrderList",
             Type: "Item",
             TargetFrame: "PreItemList",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']

         },
         onDblClickRow: function(rowIndex, rowData) {

             var RowIdStr = $("#PIADM_RowId").val()

             if (RowIdStr == "") {
                 $.messager.alert("提示", "请先预约！", "info");
                 return false;
             }

             var AdmIdStr = RowIdStr.split("^");
             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var RowId = AdmIdStr[i]
                 var ItemId = rowData.STORD_ARCIM_DR;
                 $("#Item").select();
                 var FlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "GetArcItemRecLoc", ItemId, session['LOGON.CTLOCID']);
                 var RecLocFlag = FlagStr.split("$")[0];
                 var ARCIMDesc = FlagStr.split("$")[1];
                 if (RecLocFlag != "1") {
                     $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室,请与信息中心联系!", "info");
                     return false;

                 }

                 var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
                 if (GAAuditedFlag == "1") {
                     $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
                     return false;
                 }

                 var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
                 var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
                 var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
                 if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
                     $.messager.alert("提示", "已经收表,不能加项", "info");
                     return false;
                 }

                 var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, ItemId, PreOrAdd);

                 if (IsAddPhc == "1") {
                     if ("PERSON" == gAdmType) {
                         $.messager.alert("提示", "个人不允许加药", "info");
                         return false;
                     }
                     if ("TEAM" == gAdmType) {
                         $.messager.alert("提示", "分组不允许加药", "info");
                         return false;
                     }
                 }

                 var ExcludeFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistExcludeItem", RowId, AdmType, ItemId)
                 if (ExcludeFlag == "1") {
                     $.messager.alert("提示", "存在排斥项目，不允许添加", "info");
                     return false;
                 }
				
				//判断客户的性别、年龄范围是否与医嘱项维护的性别、年龄范围一致
                 var ArcItemFlag= tkMakeServerCall("web.DHCPE.PreItemList","JustArcItemInfo",RowId, AdmType, ItemId);
                 var Char_2=String.fromCharCode(2);
                 var ArcItemFlagArr=ArcItemFlag.split(Char_2);
                 if(ArcItemFlagArr[0]=="1"){
	                 if(ArcItemFlagArr[1]!=""){
		             	$.messager.alert("提示", "客户性别与医嘱项维护的性别不一致！", "info");
                     	return false;
	                 }
	                 if(ArcItemFlagArr[2]!=""){
		                $.messager.alert("提示", "客户年龄与医嘱项维护的年龄不一致！", "info");
                     	return false;
	                 }
                 }
                 // 判断药品、材料类医嘱库存
                 var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ItemId, session['LOGON.CTLOCID']);
                 if (Invent == "0") {
                     $.messager.alert("提示", "库存不足，请查看库存！", "info");
                     return false;
                 }

                 var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", RowId, AdmType, ItemId, "", session['LOGON.CTLOCID']);
                 var flagArr = flagret.split("^");
                 var flag = flagArr[0];

                 if ("1" == flag) {

                     if (flagArr[1] == "1") {

                         $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                             if (data) {
                                 var UserId = session['LOGON.USERID'];
                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": ItemId,
                                     "ArcItemSetId": "",
                                     "UpdateUserId": UserId
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;
                                     }


                                 });
                             } else {
                                 return false;
                             }
                         });

                     } else {
                         $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                         return false;
                     }
                 } else if ("2" == flag) {
                     $.messager.alert("提示", "项目中的化验项目,和已有项目有重复,是否继续添加?", "info")
                     return false;
                 }
                 if (flagArr[1] == "1") { return false; }
                 var ItemFlag;
                 ItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ItemCanPreInfo", RowId, AdmType, ItemId)

                 var ItemCanFlag = ItemFlag.split(",")

                 if (ItemCanFlag[0] == -1) {
                     var ItemCanStr = ""
                     for (i = 1; i < ItemCanFlag.length; i++) {
                         if (ItemCanStr == "") { var ItemCanStr = ItemCanFlag[i]; } else { var ItemCanStr = ItemCanStr + "," + ItemCanFlag[i]; }
                     }

                     $.messager.confirm("操作提示", ItemCanStr, function(data) {
                         if (data) {
                             var UserId = session['LOGON.USERID'];
                             $.cm({
                                 ClassName: "web.DHCPE.PreItemList",
                                 MethodName: "HISUIIInsertItem",
                                 "AdmId": RowId,
                                 "AdmType": AdmType,
                                 "PreOrAdd": PreOrAdd,
                                 "ArcItemId": ItemId,
                                 "ArcItemSetId": "",
                                 "UpdateUserId": UserId
                             }, function(jsonData) {
                                 if (jsonData.ret == "") {
                                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                     var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                     var myDiv = document.getElementById("TotalFee");
                                     myDiv.innerText = TotalAmount;
                                     var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                                     var myDiv = document.getElementById("ConfirmInfo");
                                     myDiv.innerText = ConfirmInfo;



                                 } else {
                                     $.messager.alert("提示", jsonData.ret, "info");
                                 }

                             });
                         } else {
                             return false;
                         }
                     });

                 }
                 if (ItemCanFlag[0] == -1) { return false; }

                 var UserId = session['LOGON.USERID'];
                 $.cm({
                     ClassName: "web.DHCPE.PreItemList",
                     MethodName: "HISUIIInsertItem",
                     "AdmId": RowId,
                     "AdmType": AdmType,
                     "PreOrAdd": PreOrAdd,
                     "ArcItemId": ItemId,
                     "ArcItemSetId": "",
                     "UpdateUserId": UserId
                 }, function(jsonData) {
                     if (jsonData.ret == "") {
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                         var myDiv = document.getElementById("TotalFee");
                         myDiv.innerText = TotalAmount;
                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                         var myDiv = document.getElementById("ConfirmInfo");
                         myDiv.innerText = ConfirmInfo;
                     } else {
                         $.messager.alert("提示", jsonData.ret, "info");
                     }

                 });
             }


         },
         
         columns: [
             [{
                     field: 'STORD_ARCIM_DR',
                     title: '操作',
					 align: 'center',
                     formatter: function(value, row, index) {
	                     return "<span style='cursor:pointer;padding-left:7px;' class='icon-add' title='' onclick='AddItem(\"" + value + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='AddItem(\"" + value + "\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                     }
                 },
                
                 { field: 'STORD_ARCIM_Desc', title: '名称' },
                 { field: 'STORD_ARCIM_Price', title: '价格', align: 'right' },
                 { field: 'TLocDesc', title: '站点' },
                 { field: 'STORD_ARCIM_Code', title: '编码' },
             ]
         ]
		

     })


     var QryLisObj = $HUI.datagrid("#QryLisItm", {
         url: $URL,
		 fitColumns: true,
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         showPageList:false, 
   		 showRefresh:true,
         fit: true,
         queryParams: {
             ClassName: "web.DHCPE.StationOrder",
             QueryName: "StationOrderList",
             Type: "Lab",
             TargetFrame: "PreItemList",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']


         },
         onDblClickRow: function(rowIndex, rowData) {

             var RowIdStr = $("#PIADM_RowId").val()

             if (RowIdStr == "") {
                 $.messager.alert("提示", "请先预约！", "info");
                 return false;
             }

             var AdmIdStr = RowIdStr.split("^");
             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var RowId = AdmIdStr[i]
                 var ItemId = rowData.STORD_ARCIM_DR;
                 $("#LisItem").select();

                 var FlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "GetArcItemRecLoc", ItemId, session['LOGON.CTLOCID']);
                 var RecLocFlag = FlagStr.split("$")[0];
                 var ARCIMDesc = FlagStr.split("$")[1];
                 if (RecLocFlag != "1") {
                     $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室,请与信息中心联系!", "info");
                     return false;

                 }


                 var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
                 if (GAAuditedFlag == "1") {
                     $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
                     return false;
                 }


                 var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
                 var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
                 var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
                 if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
                     $.messager.alert("提示", "已经收表,不能加项", "info");
                     return false;
                 }

                 var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, ItemId, PreOrAdd);

                 if (IsAddPhc == "1") {
                     if ("PERSON" == AdmType) {
                         $.messager.alert("提示", "个人不允许加药", "info");
                         return false;
                     }
                     if ("TEAM" == AdmType) {
                         $.messager.alert("提示", "分组不允许加药", "info");
                         return false;
                     }
                 }

                 var ExcludeFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistExcludeItem", RowId, AdmType, ItemId)
                 if (ExcludeFlag == "1") {
                     $.messager.alert("提示", "存在排斥项目，不允许添加", "info");
                     return false;
                 }
				//判断客户的性别、年龄范围是否与医嘱项维护的性别、年龄范围一致
                 var ArcItemFlag= tkMakeServerCall("web.DHCPE.PreItemList","JustArcItemInfo",RowId, AdmType, ItemId);
                 var Char_2=String.fromCharCode(2);
                 var ArcItemFlagArr=ArcItemFlag.split(Char_2);
                 if(ArcItemFlagArr[0]=="1"){
	                 if(ArcItemFlagArr[1]!=""){
		             	$.messager.alert("提示", "客户性别与医嘱项维护的性别不一致！", "info");
                     	return false;
	                 }
	                 if(ArcItemFlagArr[2]!=""){
		                $.messager.alert("提示", "客户年龄与医嘱项维护的年龄不一致！", "info");
                     	return false;
	                 }
                 }

                 // 判断药品、材料类医嘱库存
                 var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ItemId, session['LOGON.CTLOCID']);
                 if (Invent == "0") {
                     $.messager.alert("提示", "库存不足，请查看库存！", "info");
                     return false;
                 }

                 var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", RowId, AdmType, ItemId, "", session['LOGON.CTLOCID']);
                 var flagArr = flagret.split("^");
                 var flag = flagArr[0];

                 if ("1" == flag) {

                     if (flagArr[1] == "1") {

                         $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                             if (data) {
                                 var UserId = session['LOGON.USERID'];
                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": ItemId,
                                     "ArcItemSetId": "",
                                     "UpdateUserId": UserId
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;
                                     }


                                 });
                             } else {
                                 return false;
                             }
                         });

                     } else {
                         $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                         return false;
                     }
                 } else if ("2" == flag) {
                     $.messager.alert("提示", "项目中的化验项目,和已有项目有重复,是否继续添加?", "info")
                     return false;
                 }
                 if (flagArr[1] == "1") { return false; }
                 var ItemFlag;
                 ItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ItemCanPreInfo", RowId, AdmType, ItemId)

                 var ItemCanFlag = ItemFlag.split(",")
                 if (ItemCanFlag[0] == -1) {

                     $.messager.confirm("操作提示", ItemCanFlag[1], function(data) {
                         if (data) {
                             var UserId = session['LOGON.USERID'];
                             $.cm({
                                 ClassName: "web.DHCPE.PreItemList",
                                 MethodName: "HISUIIInsertItem",
                                 "AdmId": RowId,
                                 "AdmType": AdmType,
                                 "PreOrAdd": PreOrAdd,
                                 "ArcItemId": ItemId,
                                 "ArcItemSetId": "",
                                 "UpdateUserId": UserId
                             }, function(jsonData) {
                                 if (jsonData.ret == "") {
                                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                     var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                     var myDiv = document.getElementById("TotalFee");
                                     myDiv.innerText = TotalAmount;
                                     var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                     var myDiv = document.getElementById("ConfirmInfo");
                                     myDiv.innerText = ConfirmInfo;
                                 }


                             });
                         } else {
                             return false;
                         }
                     });

                 }
                 if (ItemCanFlag[0] == -1) { return false; }
                 var UserId = session['LOGON.USERID'];
                 $.cm({
                     ClassName: "web.DHCPE.PreItemList",
                     MethodName: "HISUIIInsertItem",
                     "AdmId": RowId,
                     "AdmType": AdmType,
                     "PreOrAdd": PreOrAdd,
                     "ArcItemId": ItemId,
                     "ArcItemSetId": "",
                     "UpdateUserId": UserId
                 }, function(jsonData) {

                     if (jsonData.ret == "") {
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                         var myDiv = document.getElementById("TotalFee");

                         myDiv.innerText = TotalAmount;
                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                         var myDiv = document.getElementById("ConfirmInfo");
                         myDiv.innerText = ConfirmInfo;
                     } else {
                         $.messager.alert("提示", jsonData.ret, "info");
                     }

                 });

             }

         },
         columns: [
             [{
                     field: 'STORD_ARCIM_DR',
                     title: '操作',
					 align: 'center',
                     formatter: function(value, row, index) {
	                     return "<span style='cursor:pointer;padding-left:7px;' class='icon-add' title='' onclick='AddItem(\"" + value + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='AddItem(\"" + value + "\")'>\
                    <img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                     }
                 },
                 
                 { field: 'STORD_ARCIM_Desc', title: '名称' },
                 { field: 'STORD_ARCIM_Price', title: '价格', align: 'right' },
                 { field: 'TLocDesc', title: '站点' },
                 { field: 'STORD_ARCIM_Code', title: '编码' },
             ]
         ]
		 

     })


     var QryOtherObj = $HUI.datagrid("#QryOtherItm", {
         url: $URL,
		 fitColumns: true,
		 fit: true,
         pagination: true,
         displayMsg: "",
         showPageList:false, 
   		 showRefresh:true,
         pageSize: 20,
         queryParams: {
             ClassName: "web.DHCPE.StationOrder",
             QueryName: "StationOrderList",
             Type: "Other",
             TargetFrame: "PreItemList",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']


         },
         onDblClickRow: function(rowIndex, rowData) {

             var RowIdStr = $("#PIADM_RowId").val()

             if (RowIdStr == "") {
                 $.messager.alert("提示", "请先预约！", "info");
                 return false;
             }

             var AdmIdStr = RowIdStr.split("^");
             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var RowId = AdmIdStr[i]
                 var ItemId = rowData.STORD_ARCIM_DR;
                 $("#OtherItem").select();
                 var FlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "GetArcItemRecLoc", ItemId, session['LOGON.CTLOCID']);
                 var RecLocFlag = FlagStr.split("$")[0];
                 var ARCIMDesc = FlagStr.split("$")[1];
                 if (RecLocFlag != "1") {
                     $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室,请与信息中心联系!", "info");
                     return false;

                 }


                 var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
                 if (GAAuditedFlag == "1") {
                     $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
                     return false;
                 }

                 var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
                 var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
                 var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
                 if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
                     $.messager.alert("提示", "已经收表,不能加项", "info");
                     return false;
                 }

                 var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, ItemId, PreOrAdd);
                 if (IsAddPhc == "1") {
                     if ("PERSON" == AdmType) {
                         $.messager.alert("提示", "个人不允许加药", "info");
                         return false;
                     }
                     if ("TEAM" == AdmType) {
                         $.messager.alert("提示", "分组不允许加药", "info");
                         return false;
                     }
                 }

                 var ExcludeFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistExcludeItem", RowId, AdmType, ItemId)
                 if (ExcludeFlag == "1") {
                     $.messager.alert("提示", "存在排斥项目，不允许添加", "info");
                     return false;
                 }
				//判断客户的性别、年龄范围是否与医嘱项维护的性别、年龄范围一致
                 var ArcItemFlag= tkMakeServerCall("web.DHCPE.PreItemList","JustArcItemInfo",RowId, AdmType, ItemId);
                 var Char_2=String.fromCharCode(2);
                 var ArcItemFlagArr=ArcItemFlag.split(Char_2);
                 if(ArcItemFlagArr[0]=="1"){
	                 if(ArcItemFlagArr[1]!=""){
		             	$.messager.alert("提示", "客户性别与医嘱项维护的性别不一致！", "info");
                     	return false;
	                 }
	                 if(ArcItemFlagArr[2]!=""){
		                $.messager.alert("提示", "客户年龄与医嘱项维护的年龄不一致！", "info");
                     	return false;
	                 }
                 }

                 // 判断药品、材料类医嘱库存
                 var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ItemId, session['LOGON.CTLOCID']);
                 if (Invent == "0") {
                     $.messager.alert("提示", "库存不足，请查看库存！", "info");
                     return false;
                 }

                 var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", RowId, AdmType, ItemId, "", session['LOGON.CTLOCID']);
                 var flagArr = flagret.split("^");
                 var flag = flagArr[0];

                 if ("1" == flag) {

                     if (flagArr[1] == "1") {

                         $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                             if (data) {
                                 var UserId = session['LOGON.USERID'];
                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": ItemId,
                                     "ArcItemSetId": "",
                                     "UpdateUserId": UserId
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;
                                     }


                                 });
                             } else {
                                 return false;
                             }
                         });

                     } else {
                         $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                         return false;
                     }
                 } else if ("2" == flag) {
                     $.messager.alert("提示", "项目中的化验项目,和已有项目有重复,是否继续添加?", "info")
                     return false;
                 }
                 if (flagArr[1] == "1") { return false; }
                 var ItemFlag;
                 ItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ItemCanPreInfo", RowId, AdmType, ItemId)

                 var ItemCanFlag = ItemFlag.split(",")
                 if (ItemCanFlag[0] == -1) {

                     $.messager.confirm("操作提示", ItemCanFlag[1], function(data) {
                         if (data) {
                             var UserId = session['LOGON.USERID'];
                             $.cm({
                                 ClassName: "web.DHCPE.PreItemList",
                                 MethodName: "HISUIIInsertItem",
                                 "AdmId": RowId,
                                 "AdmType": AdmType,
                                 "PreOrAdd": PreOrAdd,
                                 "ArcItemId": ItemId,
                                 "ArcItemSetId": "",
                                 "UpdateUserId": UserId
                             }, function(jsonData) {
                                 if (jsonData.ret == "") {
                                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                     var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                     var myDiv = document.getElementById("TotalFee");
                                     myDiv.innerText = TotalAmount;
                                     var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                     var myDiv = document.getElementById("ConfirmInfo");
                                     myDiv.innerText = ConfirmInfo;
                                 }


                             });
                         } else {
                             return false;
                         }
                     });

                 }
                 if (ItemCanFlag[0] == -1) { return false; }
                 var UserId = session['LOGON.USERID'];
                 $.cm({
                     ClassName: "web.DHCPE.PreItemList",
                     MethodName: "HISUIIInsertItem",
                     "AdmId": RowId,
                     "AdmType": AdmType,
                     "PreOrAdd": PreOrAdd,
                     "ArcItemId": ItemId,
                     "ArcItemSetId": "",
                     "UpdateUserId": UserId
                 }, function(jsonData) {

                     if (jsonData.ret == "") {
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                         var myDiv = document.getElementById("TotalFee");
                         myDiv.innerText = TotalAmount;
                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                         var myDiv = document.getElementById("ConfirmInfo");
                         myDiv.innerText = ConfirmInfo;

                     } else {
                         $.messager.alert("提示", jsonData.ret, "info");
                     }

                 });


             }

         },
        
         columns: [
             [{
                     field: 'STORD_ARCIM_DR',
                     title: '操作',
					 align: 'center',
                     formatter: function(value, row, index) {
	                     return "<span style='cursor:pointer;padding-left:7px;' class='icon-add' title='' onclick='AddItem(\"" + value + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='AddItem(\"" + value + "\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                     }
                 },
            
                 { field: 'STORD_ARCIM_Desc', title: '名称' },
                 { field: 'STORD_ARCIM_Price', title: '价格', align: 'right' },
                 { field: 'TLocDesc', title: '站点' },
                 { field: 'STORD_ARCIM_Code', title: '编码' },
             ]
         ]
         

     })



     var QryMedicalObj = $HUI.datagrid("#QryMedicalItm", {
         url: $URL,
		 fitColumns: true,
		 fit: true,
         pagination: true,
         displayMsg: "",
         showPageList:false, 
   		 showRefresh:true,
         pageSize: 20,
         queryParams: {
             ClassName: "web.DHCPE.StationOrder",
             QueryName: "StationOrderList",
             Type: "Medical",
             TargetFrame: "PreItemList",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']


         },
         onDblClickRow: function(rowIndex, rowData) {

             var RowIdStr = $("#PIADM_RowId").val()

             if (RowIdStr == "") {
                 $.messager.alert("提示", "请先预约！", "info");
                 return false;
             }

             var AdmIdStr = RowIdStr.split("^");
             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var RowId = AdmIdStr[i]
                 var ItemId = rowData.STORD_ARCIM_DR;
                 var FlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "GetArcItemRecLoc", ItemId, session['LOGON.CTLOCID']);
                 var RecLocFlag = FlagStr.split("$")[0];
                 var ARCIMDesc = FlagStr.split("$")[1];
                 if (RecLocFlag != "1") {
                     $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室,请与信息中心联系!", "info");
                     return false;

                 }

                 var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
                 if (GAAuditedFlag == "1") {
                     $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
                     return false;
                 }


                 var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
                 var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
                 var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
                 if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
                     $.messager.alert("提示", "已经收表,不能加项", "info");
                     return false;
                 }

                 var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, ItemId, PreOrAdd);
                 if (IsAddPhc == "1") {
                     if ("PERSON" == AdmType) {
                         $.messager.alert("提示", "个人不允许加药", "info");
                         return false;
                     }
                     if ("TEAM" == AdmType) {
                         $.messager.alert("提示", "分组不允许加药", "info");
                         return false;
                     }
                 }

                 var ExcludeFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistExcludeItem", RowId, AdmType, ItemId)
                 if (ExcludeFlag == "1") {
                     $.messager.alert("提示", "存在排斥项目，不允许添加", "info");
                     return false;
                 }

				//判断客户的性别、年龄范围是否与医嘱项维护的性别、年龄范围一致
                 var ArcItemFlag= tkMakeServerCall("web.DHCPE.PreItemList","JustArcItemInfo",RowId, AdmType, ItemId);
                 var Char_2=String.fromCharCode(2);
                 var ArcItemFlagArr=ArcItemFlag.split(Char_2);
                 if(ArcItemFlagArr[0]=="1"){
	                 if(ArcItemFlagArr[1]!=""){
		             	$.messager.alert("提示", "客户性别与医嘱项维护的性别不一致！", "info");
                     	return false;
	                 }
	                 if(ArcItemFlagArr[2]!=""){
		                $.messager.alert("提示", "客户年龄与医嘱项维护的年龄不一致！", "info");
                     	return false;
	                 }
                 }

                 // 判断药品、材料类医嘱库存
                 var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ItemId, session['LOGON.CTLOCID']);
                 if (Invent == "0") {
                     $.messager.alert("提示", "库存不足，请查看库存！", "info");
                     return false;
                 }

                 var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", RowId, AdmType, ItemId, "", session['LOGON.CTLOCID']);
                 var flagArr = flagret.split("^");
                 var flag = flagArr[0];

                 if ("1" == flag) {

                     if (flagArr[1] == "1") {

                         $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                             if (data) {
                                 var UserId = session['LOGON.USERID'];
                                 // 判断是否药品医嘱
                                 var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

                                 if (itemInfo.ItemOrderType == "R") {

                                     AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
                                 } else {

                                     $.cm({
                                         ClassName: "web.DHCPE.PreItemList",
                                         MethodName: "HISUIIInsertItem",
                                         "AdmId": RowId,
                                         "AdmType": AdmType,
                                         "PreOrAdd": PreOrAdd,
                                         "ArcItemId": ItemId,
                                         "ArcItemSetId": "",
                                         "UpdateUserId": UserId
                                     }, function(jsonData) {
                                         if (jsonData.ret == "") {
                                             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                             var myDiv = document.getElementById("TotalFee");
                                             myDiv.innerText = TotalAmount;
                                             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                             var myDiv = document.getElementById("ConfirmInfo");
                                             myDiv.innerText = ConfirmInfo;
                                         }


                                     });
                                 }
                             } else {
                                 return false;
                             }
                         });

                     } else {
                         $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                         return false;
                     }
                 } else if ("2" == flag) {
                     $.messager.alert("提示", "项目中的化验项目,和已有项目有重复,是否继续添加?", "info")
                     return false;
                 }
                 if (flagArr[1] == "1") { return false; }
                 var ItemFlag;
                 ItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ItemCanPreInfo", RowId, AdmType, ItemId)

                 var ItemCanFlag = ItemFlag.split(",")
                 if (ItemCanFlag[0] == -1) {

                     $.messager.confirm("操作提示", ItemCanFlag[1], function(data) {
                         if (data) {
                             var UserId = session['LOGON.USERID'];
                             // 判断是否药品医嘱
                             var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

                             if (itemInfo.ItemOrderType == "R") {

                                 AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
                             } else {

                                 $.cm({
                                     ClassName: "web.DHCPE.PreItemList",
                                     MethodName: "HISUIIInsertItem",
                                     "AdmId": RowId,
                                     "AdmType": AdmType,
                                     "PreOrAdd": PreOrAdd,
                                     "ArcItemId": ItemId,
                                     "ArcItemSetId": "",
                                     "UpdateUserId": UserId
                                 }, function(jsonData) {
                                     if (jsonData.ret == "") {
                                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                         var myDiv = document.getElementById("TotalFee");
                                         myDiv.innerText = TotalAmount;
                                         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                         var myDiv = document.getElementById("ConfirmInfo");
                                         myDiv.innerText = ConfirmInfo;
                                     }


                                 });
                             }
                         } else {
                             return false;
                         }
                     });

                 }
                 if (ItemCanFlag[0] == -1) { return false; }
                 var UserId = session['LOGON.USERID'];
                 // 判断是否药品医嘱
                 var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

                 if (itemInfo.ItemOrderType == "R") {

                     AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
                 } else {

                     $.cm({
                         ClassName: "web.DHCPE.PreItemList",
                         MethodName: "HISUIIInsertItem",
                         "AdmId": RowId,
                         "AdmType": AdmType,
                         "PreOrAdd": PreOrAdd,
                         "ArcItemId": ItemId,
                         "ArcItemSetId": "",
                         "UpdateUserId": UserId
                     }, function(jsonData) {

                         if (jsonData.ret == "") {
                             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                             var myDiv = document.getElementById("TotalFee");
                             myDiv.innerText = TotalAmount;
                             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                             var myDiv = document.getElementById("ConfirmInfo");
                             myDiv.innerText = ConfirmInfo;
                         } else {
                             $.messager.alert("提示", jsonData.ret, "info");
                         }
                     });
                 }

             }

         },
         
         columns: [
             [{
                     field: 'STORD_ARCIM_DR',
                     title: '操作',
					 align: 'center',
                     formatter: function(value, row, index) {
	                    return "<span style='cursor:pointer;padding-left:7px;' class='icon-add' title='' onclick='AddItem(\"" + value + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                         return "<a href='#' onclick='AddItem(\"" + value + "\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
                    </a>";
                     }
                 },
                 
                 { field: 'STORD_ARCIM_Desc', title: '名称' },
                 { field: 'STORD_ARCIM_Price', title: '价格', align: 'right' },
                 { field: 'TLocDesc', title: '站点' },
                 { field: 'STORD_ARCIM_Code', title: '编码' },
             ]
         ]
         

     })


     //分组界面的"费别"、"自付"、"公费自费转换" 不显示，个人的都显示
     if (AdmType == "TEAM") {
         var Hide = true;
     } else {
         var Hide = false;
     }

     var PreItemListObj = $HUI.datagrid("#PreItemList", {
         url: $URL,
		 fitColumns: true,
		 fit: true,
         singleSelect: false,
         checkOnSelect: true,
         selectOnCheck: true,
         pagination: true,
         displayMsg: "",
         pageSize: 20,
         onDblClickRow: onDblClickRow,
         queryParams: {
             ClassName: "web.DHCPE.Query.PreItemList",
             QueryName: "QueryPreItemList",
             AdmId: "",
             AdmType: AdmType,
             PreOrAdd: PreOrAdd,
             AddType: "Item",
             SelectType: "ItemSet",
             ShowFlag: "",
             Control: "",
             BType: "B",
             LocID: session['LOGON.CTLOCID'],
             hospId: session['LOGON.HOSPID']

         },
         
         onLoadSuccess: function(data) {

             editIndex = undefined;
             if (PreAdmId) {
                 var rows = $("#PreItemList").datagrid("getRows");

                 $("#PreItemList").datagrid("scrollTo", rows.length - 1);
             }

         },

         onAfterEdit: function(rowIndex, rowData, changes) {


             var OrdItemDR = rowData.RowId
             var ItemType = rowData.TItemType
             var ItemFeeType = rowData.TItemFeeType
             var Qty = rowData.TQty
             var OrderEntDR = rowData.OrderEntId
             var TItemStat = rowData.TItemStat

             if (TItemStat == 1) {
                 var Strings = OrdItemDR + "," + AdmType + "," + ItemType + "," + ItemFeeType + "," + Qty + "," + OrderEntDR
                 var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateItemFeeType", Strings);
                 if (Flag != 0) {
                     //$.messager.alert("提示",Flag,"info"); 
                 }

             }
             var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateRecLoc", rowData.TRecLoc, rowData.RowId, AdmType);
             if (Flag != 0) {
                 //alert(Flag);

             }

             var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateSpecName", rowData.TSpecCode + "^" + rowData.TSpecName, rowData.RowId, AdmType);
             if (Flag != 0) {
                 //alert(Flag);

             }

             var CanChange = rowData.TModifiedFlag
             var Data = rowData.PrivilegeModeID
             var MedicalFlag = rowData.TIsMedical
             if ((CanChange == "1") || ((Data == "OP") || (MedicalFlag == "1")) && (rowData.TStatus != "P") && (rowData.TStatus != "PP")) {
                 var FactAmount = rowData.TFactAmount
                 var AccountAmount = rowData.TAccountAmount
                 var Strings = OrdItemDR + "," + FactAmount + "," + Qty + "," + AccountAmount
                 var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateOPAmount", Strings, AdmType);
                 if (Flag != 0) {
                     //alert(Flag)
                 }

             }



             var IADM = getValueById("PIADM_RowId")

             //$("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:IADM,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:""});    
             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", IADM, AdmType);
             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", IADM, AdmType);

             var myDiv = document.getElementById("TotalFee");
             myDiv.innerText = TotalAmount;

         },

         columns: [
             [
                 { field: 'select', checkbox: true },
                 {
                     field: 'IsBreakable',
                     title: '操作',
					 align: 'left',
                     formatter: function(value, row, index) {

                         var itemInfo = ""
                         // 判断是否药品医嘱
                         if (row.ItemId != "") {
                             var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: row.ItemId }, false);
                         }

                         if (row.ItemSetDesc != "") {
                             if ((itemInfo.ItemOrderType == "R") && (row.RowId.split("||").length < 3)) {
	                             
	                             return "<span style='cursor:pointer;padding-left:7px;' class='icon-cancel' title='删除项目' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>\
                   				<span style='cursor:pointer;;padding-left:7px;' class='icon-cut' title='删除套餐' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^1" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>\
								<span style='cursor:pointer;;padding-left:7px;' class='icon-drug' title='药品信息修改' onclick='UpdateDrugDetail(\"" + row.RowId + "^" + row.ItemId + "^" + AdmType + "^" + PreOrAdd + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
                                /*
                                 return "<a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>\
                    		<img style='padding-left:7px;' title='删除项目' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    		</a><a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^1" + "\")'>\
                    		<img style='padding-left:7px;' title='删除套餐' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cut.png' border=0/>\
                    		</a><a href='#' onclick='UpdateDrugDetail(\"" + row.RowId + "^" + row.ItemId + "^" + AdmType + "^" + PreOrAdd + "\")'>\
                    		<img style='padding-left:7px;' title='药品信息修改' src='../scripts_lib/hisui-0.1.0/dist/css/icons/drug.png' border=0/>\
                    		</a>";*/
                             } else {
	                              
	                             return "<span style='cursor:pointer;padding-left:7px;' class='icon-cancel' title='删除项目' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>\
                   				<span style='cursor:pointer;;padding-left:7px;' class='icon-cut' title='删除套餐' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^1" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
								/*
                                 return "<a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>\
                    		<img style='padding-left:7px;' title='删除项目' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    		</a><a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^1" + "\")'>\
                    		<img style='padding-left:7px;' title='删除套餐' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cut.png' border=0/>\
                    		</a>";*/
                             }

                         } else {
                             if ((itemInfo.ItemOrderType == "R") && (row.RowId.split("||").length < 3)) {
	                              
	                             return "<span style='cursor:pointer;padding-left:7px;' class='icon-cancel' title='删除项目或套餐' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>\
								<span style='cursor:pointer;;padding-left:7px;' class='icon-drug' title='药品信息修改' onclick='UpdateDrugDetail(\"" + row.RowId + "^" + row.ItemId + "^" + AdmType + "^" + PreOrAdd + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					             /*
                                 return "<a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>\
                       	 	<img style='padding-left:7px;' title='删除项目或套餐' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                       		</a><a href='#' onclick='UpdateDrugDetail(\"" + row.RowId + "^" + row.ItemId + "^" + AdmType + "^" + PreOrAdd + "\")'>\
                       		<img style='padding-left:7px;' title='药品信息修改' src='../scripts_lib/hisui-0.1.0/dist/css/icons/drug.png' border=0/>\
                       		</a>"*/
                             } else {
	                              
	                             return "<span style='cursor:pointer;padding-left:7px;' class='icon-cancel' title='删除项目或套餐' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   				 /*
                                 return "<a href='#' onclick='DeleteItemSet(\"" + row.RowId + "^" + row.OrderEntId + "^0" + "\")'>\
                        	<img style='padding-left:7px;' title='删除项目或套餐' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                      	    </a>"*/
                             }

                         }
                     }
                 },
                 { field: 'RowId', hidden: true },
                 { field: 'OrderEntId', hidden: true },
                 { field: 'ItemId', hidden: true },
                 { field: 'ItemSetId', hidden: true },
                 { field: 'TItemType', hidden: true },
                 { field: 'TItemStat', hidden: true },
                 { field: 'TAccountAmount', hidden: true },
                 { field: 'TModifiedFlag', hidden: true },
                 { field: 'PrivilegeModeID', hidden: true },
                 { field: 'TIsMedical', hidden: true },
                 { field: 'ItemDesc', title: '项目名称',width:150},
                 { field: 'ItemSetDesc', title: '套餐' },
                 { field: 'TAddOrdItem', title: '费别', hidden: Hide },
                 { field: 'TFactAmount', title: '优惠金额', hidden: Hide, align: 'right', editor: { type: 'numberbox', options: { min: 0, precision: 2 } } },
                 { field: 'TPreOrAdd', title: '项目类别' },
                 { field: 'TQty', title: '数量', editor: { type: 'numberbox' } },
                 { field: 'TUint', title: '单位' },
                 { field: 'PrivilegeMode', title: '优惠方式' },
                 { field: 'TPersonAmount', title: '自付', align: 'right', hidden: Hide },
                 {
                     field: 'TRecLoc',
                     title: '接收科室',
                     formatter: function(value, row) {
                         return row.TRecLocDesc;
                     },
                     editor: {
                         type: 'combobox',
                         options: {
                             valueField: 'RecLocRID',
                             textField: 'RecLocDesc',
                             method: 'get',
                             url: $URL + "?ClassName=web.DHCPE.TransAdmInfo&QueryName=QueryReceiveLoc&ResultSetType=array",
                             onBeforeLoad: function(param) {
                                 var DefaultPAADM = tkMakeServerCall("web.DHCPE.HISUICommon", "GetDefaultPAADM");

                                 var row = $('#PreItemList').datagrid('getRows')[NowRow]

                                 param.arcItemId = row.ItemId
                                 param.paadmId = DefaultPAADM

                             }

                         }
                     }
                 },
                 {
                     field: 'TSpecCode',
                     title: '样本',
                     formatter: function(value, row) {
                         return row.TSpecName;
                     },
                     editor: {
                         type: 'combobox',
                         options: {
                             valueField: 'TSpecCode',
                             textField: 'TSpceName',
                             method: 'get',
                             url: $URL + "?ClassName=web.DHCPE.BarPrint&QueryName=SerchSpecName&ResultSetType=array",
                             onBeforeLoad: function(param) {

                                 var row = $('#PreItemList').datagrid('getRows')[NowRow]

                                 param.ItemID = row.ItemId,
                                     param.LocID = session['LOGON.CTLOCID']

                             },
                             onSelect: function(record) {
                                 var row = $('#PreItemList').datagrid('getRows')[NowRow];
                                 var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateSpecName", record.TSpecCode + "^" + record.TSpecName, row.RowId, AdmType);
                                 row.TSpecName = record.TSpceName;
                             }

                         }
                     }
                 },



                 { field: 'TAddUser', title: '操作员' },
                 { field: 'TTotalAmount', title: '总应收', align: 'right' },
                 { field: 'TTotalFactAmount', title: '总费用', align: 'right',hidden: Hide },
                 {
                     field: 'BChangeFee',
                     title: '公费自费转换(加项)',width:60,
                     align: 'center',
                     hidden: Hide,
                     formatter: function(value, row, index) {
                         return tkMakeServerCall("web.DHCPE.PreItemListEx", "OutChangeFeeButtonHISUI", row.RowId);
                     }
                 },
                 {
                     field: 'TItemFeeType',
                     title: '体检类型',width:60,
                     
                     formatter: function(value, row) {
                         return row.TItemFeeTypeDesc;
                     },
                     editor: {
                         type: 'combobox',
                         options: {
                             valueField: 'id',
                             textField: 'desc',
                             method: 'get',
                             url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array"

                         }
                     }
                 }


             ]
         ]
         

     });





     function endEditing() {

         if (editIndex == undefined) { return true }

         if ($('#PreItemList').datagrid('validateRow', editIndex)) {

             var ed = $('#PreItemList').datagrid('getEditor', { index: editIndex, field: 'TItemFeeType' });

             var name = $(ed.target).combobox('getText');

             $('#PreItemList').datagrid('getRows')[editIndex]['TItemFeeTypeDesc'] = name;

             $('#PreItemList').datagrid('endEdit', editIndex);
             editIndex = undefined;
             return true;
         } else {
             return false;
         }
     }

     function onDblClickRow(index, value) {

         NowRow = index;
         if (editIndex != index) {
             if (endEditing()) {
                 $('#PreItemList').datagrid('selectRow', index).datagrid('beginEdit', index);



                 var dd = $('#PreItemList').datagrid('getEditor', { index: index, field: 'TFactAmount' });
                 var PrivilegeModeID = $('#PreItemList').datagrid('getRows')[index]['PrivilegeModeID']
                 var ModifiedFlag = $('#PreItemList').datagrid('getRows')[index]['TModifiedFlag']
                 if ((PrivilegeModeID == $g("项目优惠")) || (ModifiedFlag == 1)) $(dd.target).numberbox('enable');
                 else $(dd.target).numberbox('disable');


                 var tt = $('#PreItemList').datagrid('getEditor', { index: index, field: 'TQty' });
                 var IsMedical = $('#PreItemList').datagrid('getRows')[index]['TIsMedical']

                 // if(IsMedical==1) $(dd.target).numberbox('enable');
                 // else $(tt.target).numberbox('disable');
                 if (IsMedical == 1) {
                     if ((PrivilegeModeID == $g("项目优惠")) || (ModifiedFlag == 1)) {
                         $(dd.target).numberbox('enable');
                         $(tt.target).numberbox('enable');
                     }
                     if ((PrivilegeModeID != $g("项目优惠")) && (ModifiedFlag != 1)) {
                         $(dd.target).numberbox('disable');
                         $(tt.target).numberbox('enable');
                     }
                 } else {

                     $(tt.target).numberbox('disable');
                 }

                 //$('#PreItemList').datagrid('selectRow',index).datagrid('editCell',{index:index,field:field});
                 editIndex = index;

             } else {
                 $('#PreItemList').datagrid('selectRow', editIndex);
             }
         }

     }


     function BSaveAmount_click() {
         endEditing();
         var FlagStr = "",
             SpecFlagStr = "";
         var rows = $("#PreItemList").datagrid("getRows");

         for (var i = 0; i < rows.length; i++) {

             var OrdItemDR = rows[i].RowId
             var ItemType = rows[i].TItemType
             var ItemFeeType = rows[i].TItemFeeType
             var Qty = rows[i].TQty
             var OrderEntDR = rows[i].OrderEntId
             var TItemStat = rows[i].TItemStat

             if (TItemStat == 1) {
                 var Strings = OrdItemDR + "," + AdmType + "," + ItemType + "," + ItemFeeType + "," + Qty + "," + OrderEntDR;
                 var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateItemFeeType", Strings);

             }

             var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateRecLoc", rows[i].TRecLoc, rows[i].RowId, AdmType);

             var OldRecLoc = tkMakeServerCall("web.DHCPE.PreItemList", "GetOldRecLoc", rows[i].RowId, AdmType);
             if (OldRecLoc != rows[i].TRecLoc) {
                 if (Flag != "0") {
                     if (FlagStr == "") var FlagStr = Flag;
                     else var FlagStr = Flag + "," + FlagStr;

                 }
             }


             var SpecFlag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateSpecName", rows[i].TSpecCode + "^" + rows[i].TSpecName, rows[i].RowId, AdmType);
             var OldSpec = tkMakeServerCall("web.DHCPE.PreItemList", "GetOldSpec", rows[i].RowId, AdmType);
             var NewSpec = rows[i].TSpecCode + "^" + rows[i].TSpecName
             if ((OldSpec != NewSpec) && (OldSpec != "")) {
                 if (SpecFlag != "0") {
                     if (SpecFlagStr == "") var SpecFlagStr = SpecFlag;
                     else var SpecFlagStr = SpecFlag + "," + SpecFlagStr;
                 }

             }


             var CanChange = rows[i].TModifiedFlag
             var Data = rows[i].PrivilegeModeID
             var MedicalFlag = rows[i].TIsMedical

             if (Data == "OP") {
                 if (CanChange == "1") {
                     var FactAmount = rows[i].TFactAmount;
                     var AccountAmount = rows[i].TAccountAmount;
                     var Strings = OrdItemDR + "," + FactAmount + "," + Qty + "," + AccountAmount
                     var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateOPAmount", Strings, AdmType);

                 }

             } else {
                 if ((MedicalFlag == "1") && (CanChange == "1")) {
                     var FactAmount = rows[i].TFactAmount;
                     var AccountAmount = rows[i].TAccountAmount;
                     var Strings = OrdItemDR + "," + FactAmount + "," + Qty + "," + AccountAmount
                     var Flag = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateOPAmount", Strings, AdmType);
                 }

             }



         }


         if (FlagStr.indexOf("状态") > "-1") {
             $.messager.alert("提示", "医嘱状态不是核实状态,不能修改接收科室", "info");

         }

         if (FlagStr.indexOf("错误") > "-1") {
             $.messager.alert("提示", "更新医嘱科室错误,不能修改接收科室", "info");

         }
         if (SpecFlagStr.indexOf("项目状态不是有效状态") > "-1") {
             $.messager.alert("提示", "项目状态不是有效状态,不能修改样本", "info");

         }

         if (SpecFlagStr.indexOf("人员项目已经到达") > "-1") {
             $.messager.alert("提示", "人员项目已经到达,不能修改样本", "info");
         }


         var IADM = getValueById("PIADM_RowId")

         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: IADM, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", IADM, AdmType);
         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", IADM, AdmType);

         var myDiv = document.getElementById("TotalFee");
         myDiv.innerText = TotalAmount;
     }


     //出生日期
     $('#DOB').datebox({

         onChange: function(date) {

             var Bob = $('#DOB').datebox('getValue');
             if (Bob != "") {
                 var AgeDesc = GetAgeNew(Bob, "");
                 $('#Age').val(AgeDesc);
             } else {
                 $('#Age').val("");
             }

         },
         onSelect: function(date) {

             var Bob = $('#DOB').datebox('getValue');
             if (Bob != "") {
                 var AgeDesc = GetAgeNew(Bob, "");
                 $('#Age').val(AgeDesc);
             }
         }
     });
     /*
     $("#ZYBTabItem").tabs({
         toolPosition:"left",
         tools:[{
         iconCls:'icon-arrow-bottom',
         handler:function(){
             $('#TPanel').layout('collapse','south');
         }
         }]
     });
     */
     /*
     $("#ZYBTab").tabs({
         toolPosition:"left",
         tools:[{
         iconCls:'icon-arrow-left',
         handler:function(){
             $('#TPanel').layout('collapse','west');
         }
         },
         {
         iconCls:'icon-arrow-right',
         handler:function(){
             $('#TPanel').layout('expand','west');
         }
         }]
     });
     */


     $("#ZYBTabItem").tabs({
         border: 1,
         onSelect: function(title, index) {
             if (title == $g('基本信息')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }

                 $cm({
                     ClassName: "web.DHCPE.OccupationalDisease",
                     MethodName: "GetPreOccuInfo",
                     PreIADM: RowId
                 }, function(jsonData) {
                     if (jsonData.code == "0") {
                         if (jsonData.msg != "") {
                             setValueById("Industry", jsonData.msg.Industry);
                             setValueById("Typeofwork", jsonData.msg.WorkType);
                             setValueById("WorkNo", jsonData.msg.JobNumber);
                             setValueById("AllWorkYear", jsonData.msg.WorkAgeY);
                             setValueById("AllWorkMonth", jsonData.msg.WorkAgeM);
                             setValueById("Category", jsonData.msg.OMEType);
                             SetHarmInfo(jsonData.msg.HarmInfo);
                         }
                     } else {
                         $.messager.alert("提示", jsonData.msg, "info");
                     }
                 });
             }
             if (title == $g('病史')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }
                 var Data = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetHisData", RowId);

                 if (Data == $g("无信息")) { return false; }
                 var Datas = Data.split("^");
                 setValueById("DHis", Datas[0]);
                 setValueById("DHome", Datas[1]);

                 setValueById("NowChild", Datas[2]);
                 setValueById("Abortion", Datas[3]);
                 setValueById("Prematurebirth", Datas[4]);
                 setValueById("DeadBirth", Datas[5]);
                 setValueById("AbnormalFetal", Datas[6]);

                 setValueById("SmokeHis", Datas[7]);
                 if (Datas[7] == $g("不吸烟")) {
                     $('#SmokeNo').attr("disabled", true);
                     $('#SmokeAge').attr("disabled", true);
                 }
                 setValueById("SmokeNo", Datas[8]);
                 setValueById("SmokeAge", Datas[9]);

                 setValueById("AlcolHis", Datas[10]);
                 if (Datas[10] == $g("不饮酒")) {
                     $('#AlcolNo').attr("disabled", true);
                     $('#Alcol').attr("disabled", true);
                 }
                 setValueById("AlcolNo", Datas[11]);
                 setValueById("Alcol", Datas[12]);

                 setValueById("FirstMenstrual", Datas[13]);
                 setValueById("Period", Datas[14]);
                 setValueById("Cycle", Datas[15]);
                 setValueById("MenoParseAge", Datas[16]);

                 setValueById("WeddingDate", Datas[17]);
                 setValueById("SpouseHarm", Datas[18]);
                 setValueById("SpouseHealth", Datas[19]);

                 return true;
             }
         }
     });

     $("#ZYBTab").tabs({
         border: 1,
         onSelect: function(title, index) {
             if (title == $g('基本信息')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }

                 $cm({
                     ClassName: "web.DHCPE.OccupationalDisease",
                     MethodName: "GetPreOccuInfo",
                     PreIADM: RowId
                 }, function(jsonData) {
                     if (jsonData.code == "0") {
                         if (jsonData.msg != "") {
                             setValueById("Industry", jsonData.msg.Industry);
                             setValueById("Typeofwork", jsonData.msg.WorkType);
                             setValueById("WorkNo", jsonData.msg.JobNumber);
                             setValueById("AllWorkYear", jsonData.msg.WorkAgeY);
                             setValueById("AllWorkMonth", jsonData.msg.WorkAgeM);
                             setValueById("Category", jsonData.msg.OMEType);
                             SetHarmInfo(jsonData.msg.HarmInfo);
                         }
                     } else {
                         $.messager.alert("提示", jsonData.msg, "info");
                     }
                 });
             }
             if (title == $g('病史')) {
                 var RowId = $("#PIADM_RowId").val();
                 if (RowId == "") {
                     return false;
                 }
                 var Data = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetHisData", RowId);

                 if (Data == $g("无信息")) { return false; }
                 var Datas = Data.split("^");
                 setValueById("DHis", Datas[0]);
                 setValueById("DHome", Datas[1]);

                 setValueById("NowChild", Datas[2]);
                 setValueById("Abortion", Datas[3]);
                 setValueById("Prematurebirth", Datas[4]);
                 setValueById("DeadBirth", Datas[5]);
                 setValueById("AbnormalFetal", Datas[6]);

                 setValueById("SmokeHis", Datas[7]);
                 if (Datas[7] ==$g("不吸烟")) {
                     $('#SmokeNo').attr("disabled", false);
                     $('#SmokeAge').attr("disabled", false);
                 }
                 setValueById("SmokeNo", Datas[8]);
                 setValueById("SmokeAge", Datas[9]);

                 setValueById("AlcolHis", Datas[10]);
                 if (Datas[10] == $g("不饮酒")) {
                     $('#AlcolNo').attr("disabled", false);
                     $('#Alcol').attr("disabled", false);
                 }
                 setValueById("AlcolNo", Datas[11]);
                 setValueById("Alcol", Datas[12]);

                 setValueById("FirstMenstrual", Datas[13]);
                 setValueById("Period", Datas[14]);
                 setValueById("Cycle", Datas[15]);
                 setValueById("MenoParseAge", Datas[16]);

                 setValueById("WeddingDate", Datas[17]);
                 setValueById("SpouseHarm", Datas[18]);
                 setValueById("SpouseHealth", Datas[19]);

                 return true;
             }
         }
     });


     $("#BSetDefaultVIP").click(function() {

         BSetDefaultVIP_click();

     });

     $("#PIADM_RowId").val(PreAdmId);

     var PIADMRowId = $("#PIADM_RowId").val()
     window.onload = function() {
         if (PIADMRowId) {
             var iPIADMRowId = PreAdmId.split("^")[0]
             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: iPIADMRowId, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", iPIADMRowId, AdmType);
             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", iPIADMRowId, AdmType);
             var myDiv = document.getElementById("TotalFee");
             myDiv.innerText = TotalAmount;
             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", iPIADMRowId, AdmType);
             var myDiv = document.getElementById("ConfirmInfo");
             myDiv.innerText = ConfirmInfo;
             var VIPLevel = tkMakeServerCall("web.DHCPE.PreIADM", "GetVIPByPIAdm", iPIADMRowId);
  
            if ((VIPLevel == $g("职业病"))) {
                 $('#ZYBTabItem').tabs('enableTab', "基本信息");
                 $('#ZYBTabItem').tabs('enableTab', "职业史");
                 $('#ZYBTabItem').tabs('enableTab', "病史");
                 $('#ZYBTabItem').tabs('enableTab', "职业病史");
                 $('#ZYBTabItem').tabs('select', "体检项目");
                 $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPIADMRowId });
                 $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPIADMRowId });
                 $('#BEndanger').linkbutton('enable');
             }

             /***自费加项视同收费 start***/
             var PreGADM = tkMakeServerCall("web.DHCPE.HISUICommon", "GetGADMByIADM", iPIADMRowId);

             if (AdmType == "TEAM") {
                 $("#IFeeAsCharged").checkbox("disable");
             } else if (AdmType == "PERSON") {
                 //个人————自费加项视同收费不允许操作
                 if (PreGADM == "") {
                     $("#IFeeAsCharged").checkbox("disable");
                 }
                 //团体————页面加载时需要自动加载"自费加项视同收费"的值（^DHCPEPreIADM(PreIAdmID,"IFeeAsCharged")）
                 if ((AdmType == "PERSON") && (PreGADM != "")) {

                     $("#IFeeAsCharged").checkbox("enable");
                     var IFeeAsChargedFlag = tkMakeServerCall("web.DHCPE.PreItemListEx", "GetIFeeAsCharged", iPIADMRowId);
                     if (IFeeAsChargedFlag == "Y") {
                         $("#IFeeAsCharged").checkbox('setValue', true);
                     } else {
                         $("#IFeeAsCharged").checkbox('setValue', false);
                     }
                 }

             }
             /***自费加项视同收费 end***/


             $("#QrySet").datagrid('load', { ClassName: "web.DHCPE.HandlerOrdSetsEx", QueryName: "queryOrdSet", Set: $("#Set").val(), Type: "ItemSet", AdmId: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'], UserID: session['LOGON.USERID'] });

             $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), PreIADMID: iPIADMRowId, StationID: $("#StationID").combobox("getValue"), BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryLisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Lab", TargetFrame: "PreItemList", Item: $("#LisItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryOtherItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Other", TargetFrame: "PreItemList", Item: $("#OtherItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryMedicalItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Medical", TargetFrame: "PreItemList", Item: $("#MedicalItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });




         }

     }
     SetDefault();
     InitPicture();

     $(document).ready(function() {
         if (PIADMRowId) {
             var iPIADMRowId = PreAdmId.split("^")[0]
             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: iPIADMRowId, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         }
     })


 };


 function SetDefault() {
     var VIPNV = "";
     var jsonData = $.cm({
         ClassName: "web.DHCPE.HISUICommon",
         MethodName: "GetVIP",
         UserID: session['LOGON.USERID'],
         LocID: session['LOGON.CTLOCID']

     }, false);

     VIPNV = jsonData;

     $('#VIPLevel').combobox('setValue', jsonData);


     var jsonData = $.cm({
         ClassName: "web.DHCPE.HISUICommon",
         MethodName: "GetDefault",
         LocID: session['LOGON.CTLOCID']
     }, false);

     var SexNV = jsonData.ret;
     SexNV = SexNV.split("^");
     $('#Sex_DR_Name').combobox('setValue', SexNV[1]);
     $('#PAPMICardType_DR_Name').combobox('setValue', SexNV[4]);

     var LocID = session['LOGON.CTLOCID'];
     var UserID = session['LOGON.USERID'];
     /*********************诊室重新加载*******************/
     $HUI.combobox("#RoomPlace", {
         onBeforeLoad: function(param) {
             var VIP = $("#VIPLevel").combobox("getValue");
             param.VIPLevel = VIP;
             param.GIType = "I";
             param.LocID = session['LOGON.CTLOCID']
         }
     });

     $('#RoomPlace').combobox('reload');
     /*********************诊室重新加载*******************/

     /*********************诊室默认值*******************/
     var DefaultRoomPlace = tkMakeServerCall("web.DHCPE.CT.RoomManagerEx", "GetDefaultRoomPlace", VIPNV, "I", LocID);
     $('#RoomPlace').combobox('setValue', DefaultRoomPlace);
     /*********************诊室默认值*******************/

     /*********************收费默认设置 start*********************/
     var OpenCharge = tkMakeServerCall("web.DHCPE.HISUICommon", "GetOpenCharge", LocID, UserID);
     if (OpenCharge == "1") {
         $("#OpenCharge").checkbox('setValue', true);
         //分组、个人的公费加项不勾选收费
         var GADM = tkMakeServerCall("web.DHCPE.HISUICommon", "GetGADMByIADM", PreAdmId);
         if ((AdmType == "TEAM") || ((AdmType == "PERSON") && (GADM != "") && (PreOrAdd == "PRE"))) {
             $("#OpenCharge").checkbox('setValue', false);
         }

     } else {
         $("#OpenCharge").checkbox('setValue', false);
     }
     /*********************收费默认设置 end*********************/

     var curr_time = new Date();

     function myformatter(date) {
         var y = date.getFullYear();
         var m = date.getMonth() + 1;
         var d = date.getDate();
         return (d < 10 ? ('0' + d) : d) + '/' + (m < 10 ? ('0' + m) : m) + '/' + y;
     }

     //$('#PEDateBegin').datebox('setValue', myformatter(curr_time));
     var today = getDefStDate(0);
     $('#PEDateBegin').datebox('setValue', today);

     $("#DietFlag").checkbox('setValue', true);

 }

 function trim(s) {
     if ("" == s) { return ""; }
     var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
     return (m == null) ? "" : m[1];
 }

 //验证电话或移动电话
 function CheckTelOrMobile(telephone, Name, Type) {
     if (isMoveTel(telephone)) return true;
     if (telephone.indexOf('-') >= 0) {
         $.messager.alert("提示", Type + "固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!", "info", function() {
             $("#" + Name).focus();
         });
         return false;
     } else {
         if (telephone.length != 11) {
             $.messager.alert("提示", Type + "联系电话电话长度应为【11】位,请核实!", "info", function() {
                 $("#" + Name).focus();
             });
             return false;
         } else {
             $.messager.alert("提示", Type + "不存在该号段的手机号,请核实!", "info", function() {
                 $("#" + Name).focus();
             });
             return false;
         }
     }
     return true;
 }
 /* 
 用途：检查输入是否正确的电话和手机号 
 输入： 电话号
 value：字符串 
 返回： 如果通过验证返回true,否则返回false 
 */
 function isMoveTel(telephone) {

     var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
     var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/;
     var mobileReg = /^1[3|4|5|6|7|8|9][0-9]{9}$/;
     if (!teleReg1.test(telephone) && !teleReg2.test(telephone) && !mobileReg.test(telephone)) {
         return false;
     } else {
         return true;
     }

 }

 function SaveIBIInfo() {

     var iRowId = $("#PIBI_RowId").val();
     var iPAPMINo = $("#PAPMINo").val();
     var iName = $("#Name").val();
     if (iName == "") {
         $.messager.alert("提示", "姓名不能为空!", "info", function() {
             var valbox = $HUI.validatebox("#Name", {
                 required: true,
             });
             $("#Name").focus();
         });
         return false;
     }
     var iSex_DR = $("#Sex_DR_Name").combobox('getValue');
     if (iSex_DR == "") {
         $.messager.alert("提示", "性别不能为空!", "info", function() {
             var valbox = $HUI.combobox("#Sex_DR_Name", {
                 required: true,
             });
             $("#Sex_DR_Name").focus();
         });
         return false;
     }

     /*
     var NameHasValue=$("#Name").validatebox('isValid');
     
     if(!NameHasValue)
     {
         $.messager.alert("提示","姓名不能为空","info");
         return
     }
     
     var MobilePhoneHasValue=$("#MobilePhone").validatebox('isValid');
     if(!MobilePhoneHasValue)
     {
         $.messager.alert("提示","移动电话不正确","info");
         return
     }
     */
     var iMobilePhone = $("#MobilePhone").val();

     if (iMobilePhone == "") {
         $.messager.alert("提示", "移动电话不能为空!", "info", function() {
             var valbox = $HUI.validatebox("#MobilePhone", {
                 required: true,
             });
             $("#MobilePhone").focus();
         });
         return false;
     } else {

         if (!CheckTelOrMobile(iMobilePhone, "MobilePhone", "")) return false;
     }



     var iTel1 = $("#Tel1").val();
     iTel1 = trim(iTel1);
     if (iTel1 != "") {
         if (!CheckTelOrMobile(iTel1, "Tel1", "")) return false;

     }

     var iMobilePhone = $("#MobilePhone").val();
     if (iTel1 == "") {
         //$("#Tel1").val(iMobilePhone);
         //var iTel1=$("#Tel1").val();
     }
     var iTel2 = "";



     var iDOB = $("#DOB").datebox('getValue');
     if (iDOB == "") {
         $.messager.alert("提示", "出生日期不能为空!", "info", function() {
             var valbox = $HUI.datebox("#DOB", {
                 required: true,
             });
             $("#DOB").focus();
         });

         return false

     }

     //var iPatType_DR="1";
     var LocID = session['LOGON.CTLOCID'];
     var iPatType_DR = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetPatType", iPAPMINo, LocID);
     var iIDCard = $("#IDCard").val();
     //if (!isIdCardNo(iIDCard)) return;
     var iPAPMICardType = $("#PAPMICardType_DR_Name").combobox('getText');
     if ((iPAPMICardType.indexOf("身份证") != "-1") && (iIDCard != "")) {
         var myIsID = isIdCardNo(iIDCard);
         if (!myIsID) {
             $("#IDCard").focus();
             return false;
         }
         var IDNoInfoStr = GetInfoFromIDCard(iIDCard)
         var IDBirthday = IDNoInfoStr[2]
         if (iDOB != IDBirthday) {
             $.messager.alert("提示", "出生日期与身份证信息不符!", "info", function() {
                 $("#Birth").focus();
             });
             return false;
         }
         var IDSex = IDNoInfoStr[3]
         var mySex = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetSexDescByID", iSex_DR)
         //alert(mySex+"^"+IDSex)
         if (mySex != IDSex) {
             $.messager.alert("提示", "身份证号:" + iIDCard + "对应的性别是【" + IDSex + "】,请选择正确的性别!", "info", function() {
                 $('#Sex').next('span').find('input').focus();
             });
             return false;
         }
     }

     var iVocation = "";
     var iPosition = $("#Position").val();
     var iCompany = "";
     var iPostalcode = "";
     var iAddress = $("#Address").val();
     var iNation = "";
     var iEmail = "";
     var iMarriedDR = $("#Married_DR_Name").combobox('getValue');
     var iBloodDR = "";
     var iUpdateDate = "";
     var iUpdateUserDR = session['LOGON.USERID'];
     var iHPNo = "";
     var iHCPDR = "";
     var iHCADR = "";
     var iCardNo = getValueById("CardNo");
     var myCardTypeDR = "";
     var CardTypeStr = $HUI.combobox("#CardType").getValue();
     if (CardTypeStr != "") myCardTypeDR = CardTypeStr.split("^")[0];

     if (iCardNo != "") iCardNo = iCardNo + "$" + myCardTypeDR;

     var iVIPLevel = $("#VIPLevel").combobox('getValue');
     var iMedicareCode = "";
     var FIBIUpdateModel = "NoGen";
     var iPAPMICardType = $("#PAPMICardType_DR_Name").combobox('getValue');
     var SpecialTypeID = $("#SpecialTypeID").val();
     /*
    if(iRowId!=""){
        var BaseInfoStr=tkMakeServerCall("web.DHCPE.PreIADM","GetPreIBaseInfo",iRowId);
        var BaseInfo=BaseInfoStr.split("^");
        var iVocation=BaseInfo[9];
        var iCompany=BaseInfo[11];
        var iPostalcode=BaseInfo[12];
        var iNation=BaseInfo[14];
        var iEmail=BaseInfo[15];
        var iBloodDR=BaseInfo[17];
    }
    */
     //门诊的客户直接在个人预约界面预约（获取个人预约界面没有但是个人基本信息维界面有的值）
     var BaseInfoStr = tkMakeServerCall("web.DHCPE.PreIADM", "GetPatBaseInfo", iPAPMINo, LocID);
     var BaseInfo = BaseInfoStr.split("^");
     var iVocation = BaseInfo[0];
     var iCompany = BaseInfo[1];
     var iPostalcode = BaseInfo[2];
     var iNation = BaseInfo[3];
     var iEmail = BaseInfo[4];
     var iBloodDR = BaseInfo[5];

     /*
     if (iPAPMINo!="")
     {
         var HisName=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetHisNameByRegNo",iPAPMINo);
         
         if (iName!=HisName)
         {
             $.messager.alert("提示","保存信息和his不一致!","info");
             return false;
             
         }
         
     }*/
     var Instring = trim(iRowId) //PIBI      1 
         +
         "^" + trim(iPAPMINo) //登记号    2
         +
         "^" + trim(iName) //姓名        3
         +
         "^" + trim(iSex_DR) //性别        4
         +
         "^" + trim(iDOB) //生日        5
         +
         "^" + trim(iPatType_DR) //客人类型  6
         +
         "^" + trim(iTel1) //电话号码1 7
         +
         "^" + trim(iTel2) //电话号码2 8
         +
         "^" + trim(iMobilePhone) //移动电话  9
         +
         "^" + trim(iIDCard) //身份证号  10
         +
         "^" + trim(iVocation) //职业        11
         +
         "^" + trim(iPosition) //职位        12
         +
         "^" + trim(iCompany) //公司        13
         +
         "^" + trim(iPostalcode) //邮编        14
         +
         "^" + trim(iAddress) //联系地址  15
         +
         "^" + trim(iNation) //民族        16
         +
         "^" + trim(iEmail) //电子邮件  17
         +
         "^" + trim(iMarriedDR) //婚姻状况  18
         +
         "^" + trim(iBloodDR) //血型        19
         +
         "^" + trim(iUpdateDate) //日期        20
         +
         "^" + trim(iUpdateUserDR) //更新人   21
         +
         "^" + trim(iHPNo) //体检号
         +
         "^" + trim(iHCPDR) +
         "^" + trim(iHCADR) +
         "^" + trim(iCardNo) //卡号
         +
         "^" + trim(iVIPLevel) //VIP等级
         +
         "^" + trim(iMedicareCode) +
         "^" + trim(iPAPMICardType) //证件类型
         +
         "^" + SpecialTypeID //特殊类型ID
         +
         ";" + FIBIUpdateModel


     var jsonData = $.cm({
         ClassName: "web.DHCPE.PreIBIUpdate",
         MethodName: "HISUISave",
         "itmjs": "",
         "itmjsex": "",
         "InString": Instring

     }, false);


     if (iRowId != "") {
         return true;
     }

     flag = jsonData.code;
     iRowId = jsonData.rowid;
     iRegNo = jsonData.regno;

     if (flag == '0') {

         $("#PIBI_RowId").val(iRowId);
         $("#PAPMINo").val(iRegNo);
         $("#PAPMINo").attr("disabled", false);
         return true;
     }
     return false;



 }

 function JBNext() {
     $('#ZYBTab').tabs('select', '职业史');
     $('#ZYBTabItem').tabs('select', '职业史');
 }

 function ZYNext() {
     $('#ZYBTab').tabs('select', '病史');
     $('#ZYBTabItem').tabs('select', '病史');
 }

 function ZYBNext() {
     $('#ZYBTab').tabs('select', "体检项目");
     $('#ZYBTabItem').tabs('select', "体检项目");
 }

 function BSNext() {
     $('#ZYBTab').tabs('select', '职业病史');
     $('#ZYBTabItem').tabs('select', '职业病史');
 }

 function ZYCancel() {
     $("#ZYform").form("clear");
     $("#ZYHistory").datagrid('clearSelections');
 }

 function ZYBCancel() {
     $("#ZYBform").form("clear");
     $("#ZYBHistory").datagrid('clearSelections');
 }

 function ZYDelete() {
     var RowId = $("#PIADM_RowId").val();
     if (RowId == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }
     var row = $('#ZYHistory').datagrid('getSelected');
     if (row) {} else {
         $.messager.alert("提示", "未选中需要删除的记录！", "info");
         return;
     }
     $.messager.confirm("删除", "确定要删除记录吗?", function(r) {
         if (r) {
             var iPreIADM = getValueById("PIADM_RowId");

             var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuHistory", iPreIADM);
             var oldinfostr = oldinfo.split("$")

             var row = $('#ZYHistory').datagrid('getSelected');

             if (row) {
                 var CurrentSel = $('#ZYHistory').datagrid('getRowIndex', row) + 1;
                 oldinfostr[CurrentSel - 1] = "";
                 var NowInfo = oldinfostr.join("$");
             } else {

                 $.messager.alert("提示", "未选中需要删除的记录！", "info");
                 return;
             }

             var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuHistory", iPreIADM, NowInfo);
             var infoData = info.split("^");

             if (infoData[0] <= 0) {
                 $.messager.alert("提示", info, "info");
                 return;
             } else {
                 $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPreIADM });
                 ZYCancel();
             }
         } else {
             return;
         }
     });
 }

 function ZYBDelete() {
     var row = $('#ZYBHistory').datagrid('getSelected');
     if (row) {} else {
         $.messager.alert("提示", "未选中需要删除的记录！", "info");
         return;
     }
     $.messager.confirm("删除", "确定要删除记录吗?", function(r) {
         if (r) {
             var iPreIADM = getValueById("PIADM_RowId");

             var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuDiseaseHistory", iPreIADM);
             var oldinfostr = oldinfo.split("$")

             var row = $('#ZYBHistory').datagrid('getSelected');
             if (row) {
                 var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex', row) + 1;
                 oldinfostr[CurrentSel - 1] = "";
                 var NowInfo = oldinfostr.join("$");
             } else {
                 $.messager.alert("提示", "未选中需要删除的记录！", "info");
                 return;
             }

             var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuDiseaseHistory", iPreIADM, NowInfo);
             var infoData = info.split("^");

             if (infoData[0] <= 0) {
                 $.messager.alert("提示", info, "info");
                 return;
             } else {
                 $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPreIADM });
                 ZYBCancel();
             }
         } else {
             return;
         }
     });
 }

 function ZYBSave() {
     var iDiseaseDesc = "",
         iDiagnosisDate = "",
         iDiagnosisPlace = "",
         iiProcess = "",
         iReturn = "",
         iIsRecovery = "",
         iPreIADM = "";

     var iDiseaseDesc = getValueById("DiseaseDesc"); // 病名
     if (iDiseaseDesc == "") {
         $.messager.alert("提示", "病名不能为空！", "info");
         return;
     }

     var iDiagnosisDate = getValueById("DiagnosisDate"); // 诊断日期
     if (iDiagnosisDate == "") {
         $.messager.alert("提示", "诊断日期不能为空！", "info");
         return;
     }

     var ret = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateOverNow", iDiagnosisDate);
     if (ret == 1) {
         $.messager.alert("提示", "诊断日期不能大于当前日期!", "info");
         return;
     }

     var iDiagnosisPlace = getValueById("DiagnosisPlace"); // 诊断单位
     var iProcess = getValueById("Process"); // 治疗经过
     var iReturn = getValueById("Return"); // 归转

     //var iIsRecovery = getValueById("IsRecovery");
     //if (iIsRecovery) { iIsRecovery = "1"; }
     //else { iIsRecovery = "0"; }

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring = trim(iDiseaseDesc) +
         "^" + trim(iDiagnosisDate) +
         "^" + trim(iDiagnosisPlace) +
         "^" + trim(iProcess) +
         "^" + trim(iReturn);
     var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuDiseaseHistory", iPreIADM);
     var oldinfostr = oldinfo.split("$");

     var row = $('#ZYBHistory').datagrid('getSelected');
     if (row) {
         var CurrentSel = $('#ZYBHistory').datagrid('getRowIndex', row) + 1;
         oldinfostr[CurrentSel - 1] = Instring;
         var NowInfo = oldinfostr.join("$");
     } else {
         var NowInfo = oldinfo + "$" + Instring;
     }

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuDiseaseHistory", iPreIADM, NowInfo);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPreIADM });
         ZYBCancel();
     }
 }

 function ZYSave() {
     var RowId = $("#PIADM_RowId").val();
     if (RowId == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     var iStartDate = "",
         iEndDate = "",
         iWorkPlace = "",
         iWorkDepartment = "",
         iWorkTeam = "";
     var iWorkType = "",
         iWorkShop = "",
         iHarmfulFactor = "",
         iDailyWorkHours = "",
         iProtectiveMeasure = "";
     var iOHRadiationFlag = "",
         iOHRadiationType = "",
         iOHRadiationDose = "",
         iOHExRadHistory = "",
         iOHRemark = "";
     var iPreIADM = "";

     var iStartDate = getValueById("StartDate");
     var iStartDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", iStartDate);
     if (iStartDate == "") {
         $.messager.alert("提示", "开始日期不能为空!", "info");
         return;
     }
     var iEndDate = getValueById("EndDate");
     var iEndDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", iEndDate);

     if ((iStartDate > iEndDate) && (iEndDate != "")) {
         $.messager.alert("提示", "开始日期不能大于结束日期!", "info");
         return;
     }

     var iOHRadiationFlag = getValueById("OHRadiationFlag"); // 放射史
     var iOHRadiationType = getValueById("OHRadiationType"); // 放射线种类
     if (iOHRadiationFlag == "Y" && iOHRadiationType == "") {
         $.messager.alert("提示", "放射史请填写放射线种类!", "info");
         return;
     }
     var iOHRadiationDose = getValueById("OHRadiationDose"); // 累积受照剂量
     if (iOHRadiationFlag == "Y" && iOHRadiationDose == "") {
         $.messager.alert("提示", "放射史请填写累积受照剂量!", "info");
         return;
     }

     var iWorkPlace = getValueById("WorkPlace");
     var iWorkDepartment = getValueById("WorkDepartment");
     var iWorkShop = getValueById("WorkShop");
     var iWorkTeam = getValueById("WorkTeam");
     var iWorkType = getValueById("ZYTypeofwork");
     var iDailyWorkHours = getValueById("DailyWorkHours");
     var iHarmfulFactor = getValueById("HarmfulFactor");
     var iProtectiveMeasure = getValueById("ProtectiveMeasure");

     var iOHExRadHistory = getValueById("OHExRadHistory"); // 过量照射史
     var iOHRemark = getValueById("OHRemark"); // 备注

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring = trim(iStartDate) +
         "^" + trim(iEndDate) +
         "^" + trim(iWorkPlace) +
         "^" + trim(iWorkDepartment) +
         "^" + trim(iWorkShop) +
         "^" + trim(iWorkTeam) +
         "^" + trim(iWorkType) +
         "^" + trim(iDailyWorkHours) +
         "^" + trim(iHarmfulFactor) +
         "^" + trim(iProtectiveMeasure) +
         "^" + trim(iOHRadiationFlag) +
         "^" + trim(iOHRadiationType) +
         "^" + trim(iOHRadiationDose) +
         "^" + trim(iOHExRadHistory) +
         "^" + trim(iOHRemark);
     if (Instring == "^^^^^^^^^^^^^^") {
         $.messager.alert("提示", "职业史信息不能全是空！", "info");
         return;
     }
     var oldinfo = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetOccuHistory", iPreIADM);
     var oldinfostr = oldinfo.split("$");

     var row = $('#ZYHistory').datagrid('getSelected');
     if (row) {
         var CurrentSel = $('#ZYHistory').datagrid('getRowIndex', row) + 1;
         oldinfostr[CurrentSel - 1] = Instring;
         var NowInfo = oldinfostr.join("$");
     } else {
         var NowInfo = oldinfo + "$" + Instring;
     }

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveOccuHistory", iPreIADM, NowInfo);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPreIADM });
         ZYCancel();
     }
 }

 function BSSave() {
     var DHis = getValueById("DHis");
     var DHome = getValueById("DHome");

     var SmokeHis = getValueById("SmokeHis");
     var SmokeNo = getValueById("SmokeNo");
     var SmokeAge = getValueById("SmokeAge");
     var AlcolHis = getValueById("AlcolHis");
     var AlcolNo = getValueById("AlcolNo");
     var Alcol = getValueById("Alcol");

     var FirstMenstrual = getValueById("FirstMenstrual");
     var Period = getValueById("Period");
     var Cycle = getValueById("Cycle");
     var MenoParseAge = getValueById("MenoParseAge");

     var NowChild = getValueById("NowChild");
     var Abortion = getValueById("Abortion");
     var Prematurebirth = getValueById("Prematurebirth");
     var DeadBirth = getValueById("DeadBirth");
     var AbnormalFetal = getValueById("AbnormalFetal");

     var WeddingDate = getValueById("WeddingDate");
     var WeddingDate = tkMakeServerCall("web.DHCPE.OccupationalDisease", "DateChangeNum", WeddingDate);

     var SpouseHarm = getValueById("SpouseHarm");
     var SpouseHealth = getValueById("SpouseHealth");

     var iPreIADM = getValueById("PIADM_RowId");

     var Instring1 = trim(SmokeHis) + "^" + trim(SmokeNo) + "^" + trim(SmokeAge);
     var info1 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring1);

     var Instring2 = trim(AlcolHis) + "^" + trim(AlcolNo) + "^" + trim(Alcol);
     var info2 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring2);


     var Instring3 = trim(FirstMenstrual) + "^" + trim(Period) + "^" + trim(Cycle) + "^" + trim(MenoParseAge);
     var info3 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring3);

     var Instring4 = trim(NowChild) + "^" + trim(Abortion) + "^" + trim(Prematurebirth) + "^" + trim(DeadBirth) + "^" + trim(AbnormalFetal);
     var info4 = tkMakeServerCall("web.DHCPE.OccupationalDisease", "GetListDataByData", Instring4);

     // var Instring5 = trim(WeddingDate) + "^" + trim(SpouseHarm) + "^" + trim(SpouseHealth);
     // var info5 = tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring5);
     var Instring5 = trim(WeddingDate) + "$" + trim(SpouseHarm) + "$" + trim(SpouseHealth);
     var info5 = Instring5;

     var Instring = trim(DHis) +
         "^" + trim(DHome) +
         "^" + trim(info1) +
         "^" + trim(info2) +
         "^" + trim(info3) +
         "^" + trim(info4) +
         "^" + trim(info5);

     var info = tkMakeServerCall("web.DHCPE.OccupationalDisease", "SaveDiseaseHistory", iPreIADM, Instring);
     var infoData = info.split("^");

     if (infoData[0] <= 0) {
         $.messager.alert("提示", info, "info");
         return;
     } else {
         $.messager.alert("提示", "更新成功", "success");
     }
 }

 function JBSave() {
     var Strings = "";
     var PreIADM = getValueById("PIADM_RowId");
     if (PreIADM == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     var AllWorkYear = getValueById("AllWorkYear"); // 总工龄
     var AllWorkMonth = getValueById("AllWorkMonth");
     if (AllWorkYear == "" && AllWorkMonth == "") {
         $.messager.alert("提示", "请输入总工龄，无则输入0！", "info");
         return;
     }

     var Category = getValueById("Category"); // 检查种类
     if (Category == "") {
         $.messager.alert("提示", "请选择检查种类！", "info");
         return;
     }

     var EndangerInfo = GetHarmInfo(); // $("#HarmInfo").combotree("getValues");

     if (EndangerInfo.code != "0") {
         $.messager.alert("提示", OccuStr.msg, "info");
         return;
     } else if (EndangerInfo.msg == "") {
         $.messager.alert("提示", "请选择接害因素及接害工龄！", "info");
         return;
     }
     var EndangerStr = EndangerInfo.msg

     var Industry = getValueById("Industry"); // 行业
     var Typeofwork = getValueById("Typeofwork"); // 工种
     var WorkNo = getValueById("WorkNo"); // 工号

     var OccuStr = Industry + "^" + Typeofwork + "^" + WorkNo + "^" + Category + "^" + AllWorkYear + "^" + AllWorkMonth;

     $cm({
         ClassName: "web.DHCPE.OccupationalDisease",
         MethodName: "UpdPreOccuInfo",
         PreIADM: PreIADM,
         OccStr: OccuStr,
         EndangerStr: EndangerStr
     }, function(jsonData) {
         if (jsonData.code == "0") {
             $.messager.alert("提示", "更新成功", "success");
         } else {
             $.messager.alert("提示", jsonData.msg, "info");
         }
     });
 }

 function BEndanger_Click() {
     var PreAdmId = getValueById("PIADM_RowId");
     openOccuWin(PreAdmId);
 }

 function ConfirmOrdItem_Click() {

     var AdmIdStr = PreAdmId.split("^");
     var Rows = AdmIdStr.length;
     for (i = 0; i < Rows; i++) {
         var AdmId = AdmIdStr[i]
         if (AdmType == "PERSON") {
             var flag = tkMakeServerCall("web.DHCPE.TransAdmInfo", "ConfirmAddOrdItem", AdmId, gUserId)
         } else if (AdmType == "TEAM") {
             var flag = tkMakeServerCall("web.DHCPE.TransAdmInfo", "ConfirmAddOrdItemGT", AdmId, gUserId)
         }
     }


     var val = tkMakeServerCall("web.DHCPE.PreItemList", "GetConfirmInfoStatus", AdmId, AdmType)
     if (val == "") {
         $.messager.alert("提示", "不需要确认加项!", "info");
         return false;
     }

     if ((flag == "") || (flag == 0)) {

         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: AdmId, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", AdmId, AdmType);
         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", AdmId, AdmType);
         var myDiv = document.getElementById("TotalFee");
         myDiv.innerText = TotalAmount;

         var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", AdmId, AdmType);
         var myDiv = document.getElementById("ConfirmInfo");
         myDiv.innerText = ConfirmInfo;

         $.messager.alert("提示", "确认成功!", "success");
         var IFAsCharged = "N"
         var IFeeAsCharged = $("#IFeeAsCharged").checkbox('getValue');
         if (IFeeAsCharged) { var IFAsCharged = "Y" } else { var IFAsCharged = "N" }
         if ((AdmType == "PERSON") && (IFAsCharged != "Y")) {

             OpenChargePanel();
         }

     } else {
         $.messager.alert("提示", "确认加项异常!", "info");

     }

     return false;

 }

 function CopyItem(PreIADMID) {
     var CurID = getValueById("PIADM_RowId");

     if (PreIADMID == "") return false;
     if (PreIADMID == CurID) return false;

     var rows = $("#PreItemList").datagrid("getRows");
     for (var i = 0; i < rows.length; i++) {
         var ItemID = rows[i].ItemId
         var SetsID = rows[i].ItemSetId
         if ((ItemID == "") && (SetsID == "")) continue;
         //复制套餐时，如果有默认vip等级绑定的套餐，不重复条件
         var OrdSet = tkMakeServerCall("web.DHCPE.PreIADM", "IsExistDefaultOrdSet", CurID);
         if ((OrdSet == SetsID) && (OrdSet != "")) continue;

         var flag = tkMakeServerCall("web.DHCPE.PreItemList", "IInsertItem", CurID, AdmType, PreOrAdd, ItemID, SetsID, gUserId);

     }
     var flag = tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus", "CopyOrdSet", PreIADMID, CurID);
 }


 ///给注册医疗卡写校验码
 function WrtCard() {
     //var myPAPMINo=$("#PAPMINo").val();
     var myPAPMINo = "";
     var mySecrityNo = $.cm({
         ClassName: "web.UDHCAccCardManage",
         MethodName: "GetCardCheckNo",
         dataType: "text",
         PAPMINo: myPAPMINo
     }, false);

     if (mySecrityNo != "") {
         var myCardNo = $("#CardNo").val();
         //alert("myCardNo:"+myCardNo+"mySecrityNo:"+mySecrityNo)
         //var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, "");
         var rtn = DHCACC_WrtMagCard("3", "", mySecrityNo, myEquipDR);
         //alert("rtn:"+rtn)
         if (rtn != "0") {
             return "-1^"
         }
     } else {
         return "-1^";
     }
     return "0^" + mySecrityNo
 }


 function Save() {

     var VIPLevel = $("#VIPLevel").combobox('getText');
     /*
    if(VIPLevel=="职业病")
    {
        $('#ZYBTab').tabs('enableTab',"基本信息");
        $('#ZYBTab').tabs('enableTab',"职业史");
        $('#ZYBTab').tabs('enableTab',"病史");
        $('#ZYBTab').tabs('enableTab',"职业病史");
        $('#ZYBTab').tabs('select',"基本信息");
        $('#BEndanger').linkbutton('enable');
    }
    else
    {
        
        $('#ZYBTab').tabs('disableTab',"基本信息");
        $('#ZYBTab').tabs('disableTab',"职业史");
        $('#ZYBTab').tabs('disableTab',"病史");
        $('#ZYBTab').tabs('disableTab',"职业病史");
        $('#ZYBTab').tabs('select',"体检项目");
        $('#BEndanger').linkbutton('disable');
    }
	*/

     var iPAPMINo = $("#PAPMINo").val();
     var CTLocID = session['LOGON.CTLOCID'];
     if (iPAPMINo != "") {
         var iPAPMINo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", iPAPMINo, CTLocID);
         var flag = tkMakeServerCall("web.DHCPE.PreIADM", "JudgeIGByRegNo", iPAPMINo);
         if (flag == "G") {
             $.messager.alert("提示", "团体人员,请在团体基本信息维护界面操作", 'info');
             return false;
         }
     }
     var DataStr = "";
     var iPIADMRowId = $("#PIADM_RowId").val();
     DataStr = iPIADMRowId;
     var OldPIADMRowId = getValueById("Old_RowId");

     var flag = SaveIBIInfo(); //保存客户基本信息

     var iCardNo = $("#CardNo").val();
     var myCardTypeDR = "";
     var CardTypeStr = $HUI.combobox("#CardType").getValue();
     if (CardTypeStr != "") myCardTypeDR = CardTypeStr.split("^")[0];
     if (iCardNo != "") iCardNo = iCardNo + "$" + myCardTypeDR;
     if ((OverWriteFlag == "Y") && (CardPAPMINo == "")) {
         var myrtn = WrtCard(); //注册医疗卡写校验码
         //alert("myrtn:"+myrtn)
         var SecurityNo = myrtn.split("^")[1]; //校验码
         //alert("iCardNo:"+iCardNo+",SecurityNo:"+SecurityNo)
         //更新卡表DHC_CardRef校验码字段CF_SecurityNO
         var ret = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "UpdateCardSecurityNo", iCardNo, SecurityNo)
         //alert("ret:"+ret)
     }

     if (!flag) return false;

     var PIBIID = $("#PIBI_RowId").val();

     DataStr = DataStr + "^" + PIBIID;



     var GADMID = "";
     GADMID = $("#PGADM_DR_Name").combogrid("getValue");
     if (($("#PGADM_DR_Name").combogrid('getValue') == undefined) || ($("#PGADM_DR_Name").combogrid('getText') == "")) { var GADMID = ""; }
     DataStr = DataStr + "^" + GADMID;

     var GTeamID = "";
     GTeamID = $("#PGTeam_DR_Name").combogrid("getValue");
     if (($("#PGTeam_DR_Name").combogrid('getValue') == undefined) || ($("#PGTeam_DR_Name").combogrid('getText') == "")) { var GTeamID = ""; }
     DataStr = DataStr + "^" + GTeamID;

     var iPEDateBegin = $("#PEDateBegin").datebox('getValue');
     var dtformat = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetSYSDatefomat");
     if (dtformat == "YMD") {
         var PEDateBeginYear = iPEDateBegin.split("-")[0];
     }
     if (dtformat == "DMY") {
         var PEDateBeginYear = iPEDateBegin.split("/")[2];
     }

     if (PEDateBeginYear < 1840) {
         $.messager.alert('提示', '体检日期不能小于1840年!', "info");
         return false;
     }

     DataStr = DataStr + "^" + iPEDateBegin;

     var iDOB = $("#DOB").datebox('getValue');

     if (dtformat == "YMD") {
         var DOBYear = iDOB.split("-")[0];
     }
     if (dtformat == "DMY") {
         var DOBYear = iDOB.split("/")[2];
     }

     if (DOBYear < 1840) {
         $.messager.alert('提示', '出生日期不能小于1840年!', "info");
         return false;
     }

     var iiDOB = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", iDOB)
     var mydate = new Date();
     var CurMonth = mydate.getMonth() + 1;
     if ((CurMonth <= 9) && (CurMonth >= 0)) { var CurMonth = "0" + CurMonth; }
     var CurDate = mydate.getFullYear() + "-" + CurMonth + "-" + mydate.getDate();
     var CurDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", CurDate)
     if (iiDOB > CurDate) {
         $.messager.alert("提示", "出生日期大于当前日期.", "info");
         return false;
     }

     var iiPEDateBegin = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", iPEDateBegin)
     if (iiDOB > iiPEDateBegin) {
         $.messager.alert("提示", "出生日期大于体检日期.", "info");
         return false;
     }

     var iPEDateEnd = iPEDateBegin;
     DataStr = DataStr + "^" + iPEDateEnd;
     var iPETime = getValueById("PETime");
     DataStr = DataStr + "^" + iPETime;
     var iPEDeskClerk_DR = "";
     DataStr = DataStr + "^" + iPEDeskClerk_DR;
     var iPIADM_Status = "PREREG";
     DataStr = DataStr + "^" + iPIADM_Status;
     var iAsCharged = "N";
     var LocID = session['LOGON.CTLOCID'];
     var iAsCharged = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetCashierSystem", LocID)
     if ((iAsCharged == "1") || (iAsCharged == "3")) { var iAsCharged = "Y"; } else { var iAsCharged = "N"; }
     DataStr = DataStr + "^" + iAsCharged;
     var iAddOrdItem = "N";
     DataStr = DataStr + "^" + iAddOrdItem;
     var iAddOrdItemLimit = "N";
     DataStr = DataStr + "^" + iAddOrdItemLimit;
     var iAddOrdItemAmount = "";
     DataStr = DataStr + "^" + iAddOrdItemAmount;
     var iAddPhcItem = "N";
     DataStr = DataStr + "^" + iAddPhcItem;
     var iAddPhcItemLimit = "N";
     DataStr = DataStr + "^" + iAddPhcItemLimit;
     var iAddPhcItemAmount = "";
     DataStr = DataStr + "^" + iAddPhcItemAmount;
     //var iIReportSend="DC";
     var iIReportSend = "IS";
     DataStr = DataStr + "^" + iIReportSend;
     var iDisChargedMode = "ID";
     DataStr = DataStr + "^" + iDisChargedMode;
     var iVIPLevel = $("#VIPLevel").combobox('getValue');
     if (iVIPLevel == "") {
         $.messager.alert("提示", "VIP等级不能为空.", "info");
         return false;
     }
     DataStr = DataStr + "^" + iVIPLevel;
     var iDelayDate = "";
     DataStr = DataStr + "^" + iDelayDate;
     var iRemark = "";
     DataStr = DataStr + "^" + iRemark;
     var iSales_DR = "";
     DataStr = DataStr + "^" + iSales_DR;
     var iType = "";
     DataStr = DataStr + "^" + iType;
     var iGetReportDate = "";
     DataStr = DataStr + "^" + iGetReportDate;
     var iGetReportTime = "";
     DataStr = DataStr + "^" + iGetReportTime;
     var iPayType = "";
     DataStr = DataStr + "^" + iPayType;
     var iPercent = "";
     DataStr = DataStr + "^" + iPercent;
     var iDietFlag = 0;
     var DietFlag = $("#DietFlag").checkbox('getValue');
     if (DietFlag) iDietFlag = 1;
     DataStr = DataStr + "^" + iDietFlag;
     var iGiftFlag = 0;
     var GiftFlag = $("#GiftFlag").checkbox('getValue');
     if (GiftFlag) iGiftFlag = 1;
     DataStr = DataStr + "^" + iGiftFlag;
     var iInsureUnit = "";
     DataStr = DataStr + "^" + iInsureUnit;
     var iPatType_DR_Name = "";
     DataStr = DataStr + "^" + iPatType_DR_Name;
     var iCheckRoom = "";
     DataStr = DataStr + "^" + iCheckRoom;
     var Position = "";
     Position = $("#Position").val();
     DataStr = DataStr + "^" + Position;
     var iPatFeeType_DR_Name = "";
     iPatFeeType_DR_Name = $('#PatFeeType_DR_Name').combobox('getValue');
     DataStr = DataStr + "^" + iPatFeeType_DR_Name;
     var iReCheckFlag = "N";
     var ReCheckFlag = $("#ReCheckFlag").checkbox('getValue');
     if (ReCheckFlag) iReCheckFlag = "Y";
     var RVSelectID = $("#RVSelectID").val();
     if (RVSelectID == "undefined" || RVSelectID == undefined) RVSelectID = "";

     DataStr = DataStr + "^" + iReCheckFlag + "@@" + RVSelectID;
     //DataStr=DataStr+"^"+iReCheckFlag;
     var iRoomPlace = $('#RoomPlace').combobox('getValue');
     var DefaultRoomPlace = tkMakeServerCall("web.DHCPE.CT.RoomManagerEx", "GetDefaultRoomPlace", iVIPLevel, "I", session['LOGON.CTLOCID']);

     if ((iRoomPlace == "") && (DefaultRoomPlace != "")) {
         $.messager.alert("提示", "诊室位置不能为空!", "info");
         return false;
     }

    DataStr = DataStr + "^" + iRoomPlace;
    //var NetPreID="";
    /**  不知道传这个干嘛的，后台未获取，先注释了  wgy
    var PhotoInfo = ""
    var PhotoInfo = $("#imgPic").val();

    DataStr = DataStr + "^" + PhotoInfo;
     */
    /** 排班ID */
    DataStr = DataStr + "^" + $("#DetailID").val();

     var DataStr = DataStr + "$$" + NetPreID;

     var LocID = session["LOGON.CTLOCID"];

     var flag = tkMakeServerCall("web.DHCPE.NetPre.GetPreInfo", "IsCanPreForHis", iPEDateBegin, LocID, iVIPLevel, "I", iPETime, PIBIID);

     var Arr = flag.split("^");

     if (Arr[0] == "0") {

         $.messager.confirm("提示", Arr[1], function(r) {
             if (r) {
                 if (GADMID == "") {
                     var jsonData = $.cm({
                         ClassName: "web.DHCPE.PreIADM",
                         MethodName: "HISUISave",
                         "itmjs": "",
                         "itmjsex": "",
                         "InString": DataStr

                     }, false);
                     var flag = jsonData.ret;

                 } else {
                     if (GTeamID == "") {
                         $.messager.alert("提示", "请选择分组", "info");
                         return false;
                     }

                     var flag = tkMakeServerCall("web.DHCPE.PreIADM", "InsertIADMInGTeam", PIBIID, GADMID, GTeamID, Position, iVIPLevel);

                 }




                 var Rets = flag.split("^");
                 flag = Rets[0];
                 if ("" == iPIADMRowId) {
                     iPIADMRowId = Rets[1];
                     if (flag == '0') {

                         $("#PIADM_RowId").val(Rets[1]);
                         //$("#Old_RowId").val(Rets[1]);
                         var NoRefresh = $("#NoRefresh").checkbox('getValue');
                         if (!NoRefresh) {
                             $("#Old_RowId").val(Rets[1]);
                         }



                     }

                 }


                 if ('0' == flag) {

                    
  					if ((VIPLevel == $g("职业病"))) {
                         $('#ZYBTab').tabs('enableTab', "基本信息");
                         $('#ZYBTab').tabs('enableTab', "职业史");
                         $('#ZYBTab').tabs('enableTab', "病史");
                         $('#ZYBTab').tabs('enableTab', "职业病史");
                         $('#ZYBTab').tabs('select', "基本信息");
                         $('#BEndanger').linkbutton('enable');
                     } else {

                         $('#ZYBTab').tabs('disableTab', "基本信息");
                         $('#ZYBTab').tabs('disableTab', "职业史");
                         $('#ZYBTab').tabs('disableTab', "病史");
                         $('#ZYBTab').tabs('disableTab', "职业病史");
                         $('#ZYBTab').tabs('select', "体检项目");
                         $('#BEndanger').linkbutton('disable');
                     }

                     $.messager.alert("提示", "预约成功", "success");

                     if ("" == iPIADMRowId) {

                     } else {
                         //填写调查问卷   add by wangguoying 
                         if (SurveyFlag == "Y") {
                             openSurveyWin(iPIADMRowId);
                         }

                         //CopyItem(OldPIADMRowId);
                         $("#jbinfo").form("clear");
                         $("#ZYform").form("clear");
                         $("#DHistory").form("clear");
                         $("#ZYBform").form("clear");
                         //$("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:"",BType:"B",LocID:session['LOGON.CTLOCID'], hospId:session['LOGON.HOSPID']}); 
                         var NoRefresh = $("#NoRefresh").checkbox('getValue');

                         if (!NoRefresh) {

                             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: iPIADMRowId, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                         } else {
                             CopyItem($("#Old_RowId").val())
                             //$("#Old_RowId").val("")
                         }


                         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", iPIADMRowId, AdmType);
                         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", iPIADMRowId, AdmType);
                         var myDiv = document.getElementById("TotalFee");
                         myDiv.innerText = TotalAmount;
                         //var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",iPIADMRowId,AdmType);
                         //var myDiv=document.getElementById("ConfirmInfo");
                         //myDiv.innerText=ConfirmInfo;

                         $("#QrySet").datagrid('load', { ClassName: "web.DHCPE.HandlerOrdSetsEx", QueryName: "queryOrdSet", Set: $("#Set").val(), Type: "ItemSet", AdmId: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'], UserID: session['LOGON.USERID'] });
                         $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), PreIADMID: iPIADMRowId, StationID: $("#StationID").combobox("getValue"), BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                         $("#QryLisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Lab", TargetFrame: "PreItemList", Item: $("#LisItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                         $("#QryOtherItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Other", TargetFrame: "PreItemList", Item: $("#OtherItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                         $("#QryMedicalItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Medical", TargetFrame: "PreItemList", Item: $("#MedicalItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

                         $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPIADMRowId });
                         $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPIADMRowId });

                     }
                 } else {
                     $('#ZYBTab').tabs('disableTab', "基本信息");
                     $('#ZYBTab').tabs('disableTab', "职业史");
                     $('#ZYBTab').tabs('disableTab', "病史");
                     $('#ZYBTab').tabs('disableTab', "职业病史");
                     $('#ZYBTab').tabs('select', "体检项目");
                     $('#BEndanger').linkbutton('disable');

                     if ('Err 02' == flag) {
                         $.messager.alert("提示", "此客户已登记", "info")
                         return false;
                     } else if ('Err 05' == flag) {
                         $.messager.alert("提示", "记录已不是登记状态,不能修改", "info")
                         return false;
                     } else if ('-105' == flag) {
                         $.messager.alert("提示", "数据格式错误,操作终止", "info")
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList" });
                         return false;

                     } else if ('Err 09' == flag) {
                         $.messager.alert("提示", "更新错误:" + Rets[1], "info")
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList" });
                         return false;
                     } else if ('Err 07' == flag) {
                         $.messager.alert("提示", "更新错误:患者在团体中已存在", "info")
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList" });
                         return false;
                     } else {
                         $.messager.alert("提示", "更新错误:" + flag, "info")
                         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList" });
                         return false;
                     }

                     return true;
                 }
             } else {
                 return false;
             }
         });
     } else {

         if (GADMID == "") {
             var jsonData = $.cm({
                 ClassName: "web.DHCPE.PreIADM",
                 MethodName: "HISUISave",
                 "itmjs": "",
                 "itmjsex": "",
                 "InString": DataStr

             }, false);
             var flag = jsonData.ret;

         } else {
             if (GTeamID == "") {
                 $.messager.alert("提示", "请选择分组", "info");
                 return false;
             }

             var flag = tkMakeServerCall("web.DHCPE.PreIADM", "InsertIADMInGTeam", PIBIID, GADMID, GTeamID, Position, iVIPLevel);

         }




         var Rets = flag.split("^");
         flag = Rets[0];
         if ("" == iPIADMRowId) {
             iPIADMRowId = Rets[1];
             if (flag == '0') {

                 $("#PIADM_RowId").val(Rets[1]);
                 //$("#Old_RowId").val(Rets[1]);
                 var NoRefresh = $("#NoRefresh").checkbox('getValue');
                 if (!NoRefresh) {
                     $("#Old_RowId").val(Rets[1]);
                 }

             }

         }


         if ('0' == flag) {
              
  				if (VIPLevel == $g("职业病")) {
                 $('#ZYBTab').tabs('enableTab', "基本信息");
                 $('#ZYBTab').tabs('enableTab', "职业史");
                 $('#ZYBTab').tabs('enableTab', "病史");
                 $('#ZYBTab').tabs('enableTab', "职业病史");
                 $('#ZYBTab').tabs('select', "基本信息");
                 $('#BEndanger').linkbutton('enable');
             } else {

                 $('#ZYBTab').tabs('disableTab', "基本信息");
                 $('#ZYBTab').tabs('disableTab', "职业史");
                 $('#ZYBTab').tabs('disableTab', "病史");
                 $('#ZYBTab').tabs('disableTab', "职业病史");
                 $('#ZYBTab').tabs('select', "体检项目");
                 $('#BEndanger').linkbutton('disable');
             }

             $.messager.alert("提示", "预约成功", "success");

             if ("" == iPIADMRowId) {

             } else {
                 //填写调查问卷   add by wangguoying 
                 if (SurveyFlag == "Y") {
                     openSurveyWin(iPIADMRowId);
                 }

                 //CopyItem(OldPIADMRowId);
                 $("#jbinfo").form("clear");
                 $("#ZYform").form("clear");
                 $("#DHistory").form("clear");
                 $("#ZYBform").form("clear");
                 // $("#PreItemList").datagrid('load',{ClassName:"web.DHCPE.Query.PreItemList",QueryName:"QueryPreItemList",AdmId:iPIADMRowId,AdmType:AdmType,PreOrAdd:PreOrAdd,AddType:"Item",SelectType:"ItemSet",ShowFlag:"",Control:"",BType:"B",LocID:session['LOGON.CTLOCID'], hospId:session['LOGON.HOSPID']}); 
                 var NoRefresh = $("#NoRefresh").checkbox('getValue');

                 if (!NoRefresh) {
                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: iPIADMRowId, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

                 } else {
                     CopyItem($("#Old_RowId").val())
                     //$("#Old_RowId").val("")
                 }

                 var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", iPIADMRowId, AdmType);
                 var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", iPIADMRowId, AdmType);
                 var myDiv = document.getElementById("TotalFee");
                 myDiv.innerText = TotalAmount;
                 //var ConfirmInfo=tkMakeServerCall("web.DHCPE.PreItemList","GetItemName",iPIADMRowId,AdmType);
                 //var myDiv=document.getElementById("ConfirmInfo");
                 //myDiv.innerText=ConfirmInfo;

                 $("#QrySet").datagrid('load', { ClassName: "web.DHCPE.HandlerOrdSetsEx", QueryName: "queryOrdSet", Set: $("#Set").val(), Type: "ItemSet", AdmId: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'], UserID: session['LOGON.USERID'] });
                 $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), PreIADMID: iPIADMRowId, StationID: $("#StationID").combobox("getValue"), BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                 $("#QryLisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Lab", TargetFrame: "PreItemList", Item: $("#LisItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                 $("#QryOtherItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Other", TargetFrame: "PreItemList", Item: $("#OtherItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


                 $("#QryMedicalItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Medical", TargetFrame: "PreItemList", Item: $("#MedicalItem").val(), PreIADMID: iPIADMRowId, BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

                 $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: iPIADMRowId });
                 $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: iPIADMRowId });

             }
         } else {
             $('#ZYBTab').tabs('disableTab', "基本信息");
             $('#ZYBTab').tabs('disableTab', "职业史");
             $('#ZYBTab').tabs('disableTab', "病史");
             $('#ZYBTab').tabs('disableTab', "职业病史");
             $('#ZYBTab').tabs('select', "体检项目");
             $('#BEndanger').linkbutton('disable');
             if ('Err 02' == flag) {
                 $.messager.alert("提示", "此客户已登记", "info")
                 return false;
             } else if ('Err 05' == flag) {
                 $.messager.alert("提示", "记录已不是登记状态,不能修改", "info")
                 return false;
             } else if ('-105' == flag) {
                 $.messager.alert("提示", "数据格式错误,操作终止", "info")
                 return false;

             } else if ('Err 09' == flag) {
                 $.messager.alert("提示", "更新错误:" + Rets[1], "info")
                 return false;
             } else if ('Err 07' == flag) {
                 $.messager.alert("提示", "更新错误:患者在团体中已存在", "info")
                 return false;
             } else {
                 $.messager.alert("提示", "更新错误:" + flag, "info")
                 return false;
             }

             return true;
         }
     }

 }

 function RegNoMask(RegNo, CTLocID) {
     if (RegNo == "") return RegNo;
     var RegNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", RegNo, CTLocID);
     return RegNo;
 }

 function SetPatient_Sel(value) {

     var Data = value.split(";");

     var IsShowAlert = Data[2];
     if ("Y" == IsShowAlert) {

         $.messager.confirm("确认", "客户已有预约，是否再次预约？", function(data) {
             if (data) {} else {
                 Clear_click();
             }
         })
     }

     if (Data[0].split("^")[2] == $g("未找到记录")) {
         $.messager.alert("提示", "未找到记录!", "info");
         return false;
     }

     if ((Data[0].split("^")[0] != 0) || (Data[1].split("^")[0] != 0)) {
         var PreIBaseInfoData = Data[0];
         if ("" != PreIBaseInfoData) {
             SetPreIBaseInfo(PreIBaseInfoData);
         } else {
             var HisInfo = Data[1];
             SetHisInfo(HisInfo)
         }
     }

 }

 function SetPreIBaseInfo(value) {

     var Data = value.split("^");

     var iLLoop = 0;
     var iRowId = Data[iLLoop];
     $("#PIBI_RowId").val(iRowId);
     iLLoop = iLLoop + 1;
     $("#PAPMINo").val(Data[iLLoop]);
     iLLoop = iLLoop + 1;
     InitPicture();
     var iName = Data[iLLoop];
     if (iName == $g("未找到记录")) {
         //$.messager.alert("提示","未找到记录!","info");
         Clear_click()
         return;
     }

     $("#Name").val(Data[iLLoop]);
     if (($("#Name").val()) != "") {

         var valbox = $HUI.validatebox("#Name", {
             required: false,
         });

     }
     iLLoop = iLLoop + 1;
     $("#Sex_DR_Name").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#DOB").datebox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Tel1").val(Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#MobilePhone").val(Data[iLLoop]);
     if (($("#MobilePhone").val()) != "") {

         var valbox = $HUI.validatebox("#MobilePhone", {
             required: false,
         });

     }
     iLLoop = iLLoop + 1;
     $("#IDCard").val(Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#Position").val(Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Address").val(Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Married_DR_Name").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 8;
     $("#Age").val(Data[iLLoop].split("Y")[0]);
     iLLoop = iLLoop + 5;
     $("#CardNo").val(Data[iLLoop]);
     iLLoop = iLLoop + 1;
     $("#VIPLevel").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 2;

     $("#PAPMICardType_DR_Name").combobox('setValue', Data[iLLoop]);

     iLLoop = iLLoop + 3;
     $("#SpecialTypeID").val(Data[iLLoop]);

     VIPLevelOnChange();
 }

 function SetHisInfo(value) {
     var Data = value.split("^");
     var iLLoop = 1;
     $("#PAPMINo").val(Data[iLLoop]);
     iLLoop = iLLoop + 1;
     $("#Name").val(Data[iLLoop]);
     if (($("#Name").val()) != "") {

         var valbox = $HUI.validatebox("#Name", {
             required: false,
         });

     }
     iLLoop = iLLoop + 1;
     $("#Sex_DR_Name").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#DOB").datebox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Tel1").val(Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#MobilePhone").val(Data[iLLoop]);
     if (($("#MobilePhone").val()) != "") {

         var valbox = $HUI.validatebox("#MobilePhone", {
             required: false,
         });

     }
     iLLoop = iLLoop + 1;
     $("#IDCard").val(Data[iLLoop]);
     iLLoop = iLLoop + 2;
     $("#Position").val(Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Address").val(Data[iLLoop]);
     iLLoop = iLLoop + 3;
     $("#Married_DR_Name").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 8;
     $("#Age").val(Data[iLLoop].split("Y")[0]);
     iLLoop = iLLoop + 5;
     $("#CardNo").val(Data[iLLoop]);
     iLLoop = iLLoop + 1;
     $("#VIPLevel").combobox('setValue', Data[iLLoop]);
     iLLoop = iLLoop + 2;

     $("#PAPMICardType_DR_Name").combobox('setValue', Data[iLLoop]);
 }

 function OpenChargePanel() {
     var RowId = $("#PIADM_RowId").val();
     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);

     var CurRegNo = $("#PAPMINo").val();

     var ZFTotalAmount = TotalAmount.split("自费:");

     var OpenCharge = $("#OpenCharge").checkbox('getValue');

     if (OpenCharge) {
         if (AdmType == "TEAM") return false;
         var GIADM = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "GetIADMbyPreIADM", RowId);
         if (GIADM == "") return false;
         var ZFUPTotalAmount = tkMakeServerCall("web.DHCPE.PreIADM", "IsZFItemUPFee", RowId);

         //if(ZFTotalAmount[1]>0){
         if (ZFUPTotalAmount >= 0) {

             var lnk = 'dhcpeprecashier.hisui.csp?ADMType=I&GIADM=' + GIADM;
             //websys_lu(lnk, false, 'iconCls=icon-w-edit,width=1350,height=750,hisui=true,title=体检收费')  //无法兼容各种浏览器，弹窗不居中，不用了

            
        	$HUI.window("#CashierWin",{
        		title:"体检收费",
        		modal:true,
        		minimizable:false,
        		maximizable:false,
        		collapsible:false,
        		width:1350,
       		 	height:750,
       		 	content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
        		
        	});

         }
     }
 }

 function Register() {
     var RowId = $("#PIADM_RowId").val();

     if (!RowId) {
         $.messager.alert("提示", "请先预约！", "info")
         return;


     }
     var AdmIdStr = RowId.split("^");
     var Rows = AdmIdStr.length;
     for (i = 0; i < Rows; i++) {
         var AdmId = AdmIdStr[i]
         var ret = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "UpdateIADMInfo", AdmId, "2")
     }

     //var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",RowId,"2");

     if (ret == 0) {
         $.messager.alert("提示", "登记成功！", "success", function() {

             //var myDiv=document.getElementById("ConfirmInfo");
             //myDiv.innerText="";

             var NoRefresh = $("#NoRefresh").checkbox('getValue');

             if ((!NoRefresh) && (PreItemList == 0)) {

                 $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: "", AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

             }


             if (PreItemList == 1) {
                 $("#BRegister").hide();
             }

             $("#QrySet").datagrid('load', { ClassName: "web.DHCPE.HandlerOrdSetsEx", QueryName: "queryOrdSet", Set: $("#Set").val(), Type: "ItemSet", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'], UserID: session['LOGON.USERID'] });


             $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), StationID: $("#StationID").combobox("getValue"), PreIADMID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryLisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Lab", TargetFrame: "PreItemList", Item: $("#LisItem").val(), PreIADMID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryOtherItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Other", TargetFrame: "PreItemList", Item: $("#OtherItem").val(), PreIADMID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });


             $("#QryMedicalItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Medical", TargetFrame: "PreItemList", Item: $("#MedicalItem").val(), PreIADMID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

             $("#ZYBHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuDiseaseHistory", PreIADM: "" });

             $("#ZYHistory").datagrid('load', { ClassName: "web.DHCPE.OccupationalDisease", QueryName: "FindOccuHistory", PreIADM: "" });


             var OpenCharge = $("#OpenCharge").checkbox('getValue');

             if (OpenCharge) {
                 OpenChargePanel();
             }

             if (PreItemList == 0) {
                 Clear_click();
             }

             for (i = 0; i < Rows; i++) {
                 var AdmId = AdmIdStr[i]
                 PrintAllAppForHISUI(AdmId, "CRM", "", "", "PrePrint");

             }


         });


     } else {
         if (ret == "NoItem") { var ret = "没有预约项目,不能登记!" }
         $.messager.alert("提示", ret, "info");
     }

 }

 function InitPicture() {

     var PAPMINo = "";
     PAPMINo = $("#PAPMINo").val();
     var jsonData = $.cm({
         ClassName: "web.DHCPE.PreIADM",
         MethodName: "HISUIGetPatientID",
         "PAPMINo": PAPMINo

     }, false);
     var PatientID = jsonData.PatientID;

     PEShowPicByPatientID(PatientID, "imgPic") //DHCPECommon.js



 }

 function SetBFind_click() {
     //alert(PreAdmId)
     $("#QrySet").datagrid('load', { ClassName: "web.DHCPE.HandlerOrdSetsEx", QueryName: "queryOrdSet", Set: $("#Set").val(), Type: "ItemSet", AdmId: $("#PIADM_RowId").val(), BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'], UserID: session['LOGON.USERID'] });

 }

 function RisBFind_click() {
     $("#QryRisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Item", TargetFrame: "PreItemList", Item: $("#Item").val(), StationID: $("#StationID").combobox("getValue"), PreIADMID: $("#PIADM_RowId").val(), BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

 }

 function LisBFind_click() {
     $("#QryLisItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Lab", TargetFrame: "PreItemList", Item: $("#LisItem").val(), PreIADMID: $("#PIADM_RowId").val(), StationID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

 }


 function OtherBFind_click() {
     $("#QryOtherItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Other", TargetFrame: "PreItemList", Item: $("#OtherItem").val(), PreIADMID: $("#PIADM_RowId").val(), StationID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

 }


 function MedicalBFind_click() {
     $("#QryMedicalItm").datagrid('load', { ClassName: "web.DHCPE.StationOrder", QueryName: "StationOrderList", Type: "Medical", TargetFrame: "PreItemList", Item: $("#MedicalItem").val(), PreIADMID: $("#PIADM_RowId").val(), StationID: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

 }

 function DisableBtn(id, disabled) {
     if (disabled) {
         $HUI.linkbutton("#" + id).disable();
     } else {
         $HUI.linkbutton("#" + id).enable();
     }
 }

 var OverWriteFlag = ""

 function CardTypeKeydownHandler() {
     var SelValue = $HUI.combobox("#CardType").getValue();
     if (SelValue == "") { return; }
     var myary = SelValue.split("^");
     var myCardTypeDR = myary[0];
     OverWriteFlag = myary[23];
     if (myCardTypeDR == "") { return; }

     if (myary[16] == "Handle") {
         ;
         $("#CardNo").attr("disabled", false);
         DisableBtn("ReadCard", true);
         $("#CardNo").focus();
     } else {
         $("#CardNo").attr("disabled", true);
         $("#CardNo").val("")

         DisableBtn("ReadCard", false);
         $("#ReadCard").focus();

         m_CCMRowID = GetCardEqRowIdA();

         var myobj = document.getElementById("CardNo");

         if (myobj) { myobj.readOnly = false; }

         var obj = document.getElementById("ReadCard");
         if (obj) {
             obj.disabled = false;
         }
         DHCWeb_setfocus("ReadCard");
     }
 }
 /*
 function BClear()
 {
     Age  Name  PAPMINo
     
     Married_DR_Name
     $(".hisui-combobox").combobox('setValue',"");
     
 }*/

 function GetCardEqRowIdA() {
     var CardEqRowId = "";

     var CardTypeValue = $HUI.combobox("#CardType").getValue();

     if (CardTypeValue != "") {
         var CardTypeArr = CardTypeValue.split("^")
         CardEqRowId = CardTypeArr[14];
     }
     return CardEqRowId;
 }

 function GetCardTypeRowId() {
     var CardTypeRowId = "";
     var CardTypeValue = $HUI.combobox("#CardType").getValue();
     if (CardTypeValue != "") {
         var CardTypeArr = CardTypeValue.split("^")
         CardTypeRowId = CardTypeArr[0];
     }
     return CardTypeRowId;
 }

 function GetCardNoLength() {
     var CardNoLength = "";
     var CardTypeValue = $HUI.combobox("#CardType").getValue();
     if (CardTypeValue != "") {
         var CardTypeArr = CardTypeValue.split("^");
         CardNoLength = CardTypeArr[17];
     }
     return CardNoLength;
 }

 function FormatCardNo() {
     var CardNo = DHCC_GetElementData("CardNo");
     if (CardNo != '') {
         var CardNoLength = GetCardNoLength();
         if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
             for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
                 CardNo = "0" + CardNo;
             }
         }
     }
     return CardNo;
 }


 var CardPAPMINo = "";
 var myEquipDR = "";

 function ReadCardClickHandler() {
     var SelValue = $HUI.combobox("#CardType").getValue();
     if (SelValue == "") { return; }
     var myary = SelValue.split("^");
     var myCardTypeDR = myary[0];
     if (myCardTypeDR == "") { return; }

     var myary = SelValue.split("^");
     myEquipDR = myary[14];

     var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);



     var ReturnArr = rtn.split("^");

     if (ReturnArr[0] == "-200") {
         var cardvalue = rtn.split("^")[1];
         //$('#CardNo').val(cardvalue);
         return false;
     }
     CardPAPMINo = ReturnArr[5];
     $('#PAPMINo').val(ReturnArr[5]);
     RegNoOnChange();
     $('#CardNo').val(ReturnArr[1]);



 }

 function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR) {

     //var myrtn =DHCACC_ReadMagCard(EquipDR);

     var myrtn = DHCACC_ReadMagCard(EquipDR, "R", "23");

     var rtn = 0;
     var myLeftM = 0;
     var myAccRowID = "";
     var myPAPMI = "";
     var myPAPMNo = ""
     var myCardNo = "";
     var myCheckNo = "";
     var myGetCardTypeDR = "";
     var mySCTTip = "";
     var myary = myrtn.split("^");
     var encmeth = "";
     if (myary[0] == 0) {
         rtn = myary[0];
         myCardNo = myary[1];
         myCheckNo = myary[2];

         var myExpStr = "" + String.fromCharCode(2) + CardTypeDR;
         var myrtn = tkMakeServerCall("web.UDHCAccManageCLSIF", "getaccinfofromcardno", myCardNo, myCheckNo, myExpStr);

         var myary = myrtn.split("^");
         if (myary[0] == 0) {
             rtn = myary[0];


             var myAccRowID = myary[1];
             var myLeftM = myary[3];
             var myPAPMI = myary[7];
             var myPAPMNo = myary[8];
             var myAccType = myary[10];
             var myAccGrpLeftM = myary[17]
             if (myary.length > 12) {
                 myGetCardTypeDR = myary[12];
             }
             if (myary.length > 13) {
                 mySCTTip = myary[13];
             }
         }

     } else {
         rtn = myary[0];

     }
     return rtn + "^" + myCardNo + "^" + myCheckNo + "^" + myLeftM + "^" + myPAPMI + "^" + myPAPMNo + "^" + myAccType + "^" + myAccRowID + "^" + myGetCardTypeDR + "^" + mySCTTip + "^" + myAccGrpLeftM;
 }


 function RegNoOnChange() {
     NetPreID = "";
     $("#PIBI_RowId").val("");
     $("#PIADM_RowId").val("");
     var iPAPMINo = $("#PAPMINo").val();
     var iPAPMINo = iPAPMINo.replace("\\", "\\\\") //处理转移字符
     var CTLocID = session['LOGON.CTLOCID']
     if (iPAPMINo != "") {
         iPAPMINo = RegNoMask(iPAPMINo, CTLocID);

         //根据登记号获取体检特殊客户类型编码
         var SpecialTypeCode = tkMakeServerCall("web.DHCPE.SpecialType", "GetSpecialType", iPAPMINo);
         $("#SpecialTypeCode").val(SpecialTypeCode);

         var flag = tkMakeServerCall("web.DHCPE.PreIADM", "JudgeIGByRegNo", iPAPMINo)
         if (flag == "G") {
             $.messager.popover({ msg: "该登记号属于团体，请在团体预约界面操作", type: "info" });

             return false;
         }
         iPAPMINo = "^" + iPAPMINo + "^";
     }

     var SelValue = $HUI.combobox("#CardType").getValue();
     if (SelValue == "") { return; }
     var myary = SelValue.split("^");
     var myCardTypeDR = myary[0];
     if (myCardTypeDR == "") { return; }
     var jsonData = $.cm({
         ClassName: "web.DHCPE.PreIADM",
         MethodName: "HISUIDocListBroker",
         "itmjs": "",
         "itmjsex": "",
         "InString": iPAPMINo,
         "CardType": myCardTypeDR,
         "HospID": session['LOGON.HOSPID']
     }, false);

     var Data = jsonData.ret;

     SetPatient_Sel(Data);


 }


 $("#CardNo").keydown(function(e) {
     if (e.keyCode == 13) {

         var ClearFlag = 0
         var CardNo = "",
             SelectCardTypeRowID = "";
         var CardNo = $("#CardNo").val();
         if (CardNo == "") return;
         if (ClearFlag == "1") eval(Clear_click());

         var SelValue = $HUI.combobox("#CardType").getValue();
         if (SelValue == "") { return; }
         var myary = SelValue.split("^");
         var myCardTypeDR = myary[0];
         if (myCardTypeDR == "") { return; }

         var CardNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetCardNoLength", myCardTypeDR)
         if (CardNo.length < CardNoLength && CardNo.length > 0) {
             iCardNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "CardNoMaskNew", CardNo, CardNoLength);
             $("#CardNo").val(iCardNo);
         }
         var CardNo = $("#CardNo").val();
         SelectCardTypeRowID = myCardTypeDR;
         CardNo = CardNo + "$" + SelectCardTypeRowID;
         var RegNo = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "GetRelate", CardNo, "C");
         if (RegNo == "") {
             $.messager.alert("提示", "未找到记录!", "info");
             $("#PAPMINo").attr("disabled", true);
             BClearIBI_click();
             SetDefault();
             // Clear_click();
             return;
         }
         $("#PAPMINo").attr("disabled", false);
         $("#PAPMINo").val(RegNo);
         eval(RegNoOnChange());

     }

 });



 function CardNoOnChange() {

     CardNoChangeAppHISUI("PAPMINo", "CardNo", "RegNoOnChange()", "Clear_click()", "0");

 }

 function CardNoChangeAppHISUI(RegNoElement, CardElement, AppFunction, AppFunctionClear, ClearFlag) {


     var ClearFlag = 0;
     var CardNo = "",
         SelectCardTypeRowID = "";
     var CardNo = $("#CardNo").val();
     if (CardNo == "") return;

     if (ClearFlag == "1") eval(AppFunctionClear);


     var SelValue = $HUI.combobox("#CardType").getValue();
     if (SelValue == "") { return; }
     var myary = SelValue.split("^");
     var myCardTypeDR = myary[0];
     if (myCardTypeDR == "") { return; }

     var CardNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetCardNoLength", myCardTypeDR)
     if (CardNo.length < CardNoLength && CardNo.length > 0) {
         iCardNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "CardNoMaskNew", CardNo, CardNoLength);
         $("#CardNo").val(iCardNo);
     }
     var CardNo = $("#CardNo").val();


     SelectCardTypeRowID = myCardTypeDR;

     CardNo = CardNo + "$" + SelectCardTypeRowID;

     RegNo = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "GetRelate", CardNo, "C");

     if (RegNo == "") {
         $.messager.alert("提示", "未找到记录!", "info");
         $("#PAPMINo").attr("disabled", true);
         BClearIBI_click();
         SetDefault();
         //Clear_click();
         return;
     }

     $("#PAPMINo").attr("disabled", false);
     $("#PAPMINo").val(RegNo);
     eval(RegNoOnChange());
 }

 //清空个人基本信息
 function BClearIBI_click() {

     $("#PIBI_RowId").val("");
     $("#PIADM_RowId,#PIBI_RowId,#Sex,#Birth,#CredNo,#PhotoInfo,#PETime").val("");
     $("#Age,#SpecialTypeCode,#SpecialTypeID,#Name,#PAPMINo,#Position,#MobilePhone,#Address,#Tel1,#IDCard").val("");

     $("#Married_DR_Name").combobox('setValue', '');
     $("#PatFeeType_DR_Name").combobox('setValue', '');
     $("#Sex_DR_Name").combobox('setValue', '');
     $("#VIPLevel").combobox('setValue', '');
     $("#RoomPlace").combobox('setValue', '');
     $("#PAPMICardType_DR_Name").combobox('setValue', '');

     $("#PGADM_DR_Name").combobox('setValue', '');
     $("#PGTeam_DR_Name").combobox('setValue', '');

     $("#DOB").datebox('setValue', "");
     $("#PEDateBegin").datebox('setValue', "");

 }

 function Clear_click() {
     //$("#preiadmform").form("clear");

     BClearIBI_click();
     $("#CardNo").val("");
     $("#PAPMINo").attr("disabled", false);

     var valbox = $HUI.validatebox("#Name", {
         required: false,
     });
     var valbox = $HUI.datebox("#DOB", {
         required: false,
     });
     var valbox = $HUI.combobox("#Sex_DR_Name", {
         required: false,
     });
     var valbox = $HUI.validatebox("#MobilePhone", {
         required: false,
     });

     $("#jbinfo").form("clear");
     $("#ZYBform").form("clear");
     $("#DHistory").form("clear");
     $("#ZYform").form("clear");

     var src = "../images/uiimages/patdefault.png"
     PEShowPicBySrc(src, "imgPic");
     var myDiv = document.getElementById("TotalFee");
     myDiv.innerText = "0元";
     LoadCard();
     SetDefault();

     var CopyFlag = $("#NoRefresh").checkbox('getValue');
     if (!CopyFlag) {
         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         $("#Old_RowId").val("");
     }

     $("#Set,#Item,#LisItem").val("");
     $("#StationID").combobox('setValue', "");
     SetBFind_click();
     RisBFind_click();
     LisBFind_click();
     OtherBFind_click();

     var VIPLevel = $("#VIPLevel").combobox('getText');
  	 if (VIPLevel == $g("职业病")) {
         $('#ZYBTab').tabs('enableTab', "基本信息");
         $('#ZYBTab').tabs('enableTab', "职业史");
         $('#ZYBTab').tabs('enableTab', "病史");
         $('#ZYBTab').tabs('enableTab', "职业病史");
         $('#ZYBTab').tabs('select', "基本信息");

         $('#BEndanger').linkbutton('enable');
     } else {

         $('#ZYBTab').tabs('disableTab', "基本信息");
         $('#ZYBTab').tabs('disableTab', "职业史");
         $('#ZYBTab').tabs('disableTab', "病史");
         $('#ZYBTab').tabs('disableTab', "职业病史");
         $('#ZYBTab').tabs('select', "体检项目");

         $('#BEndanger').linkbutton('disable');
     }
 }

 function LoadCard() {
     var HospID = session['LOGON.HOSPID'];
     $.m({
         ClassName: "web.UDHCOPOtherLB",
         MethodName: "ReadCardTypeDefineListBroker",
         JSFunName: "GetCardTypeToHUIJson",
         ListName: "",
         SessionStr: "^^^^" + HospID
     }, function(val) {

         var ComboJson = JSON.parse(val);

         $HUI.combobox('#CardType', {
             data: ComboJson,
             valueField: 'id',
             textField: 'text',
             onSelect: function(record) {
                 CardTypeKeydownHandler();
             }
         });
         CardTypeKeydownHandler();
     });


 }

 function InitDrugInfo(Id) {
     // 剂量单位
     $HUI.combobox("#ItemUOMWin", {
         url: $URL + "?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDoseUOM&ARCIMRowid=" + Id + "&ResultSetType=array",
         valueField: 'Id',
         textField: 'Desc',
         defaultFilter: 4
     });
     // 频次
     $HUI.combobox("#ItemFrequenceWin", {
         url: $URL + "?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemFreq&ResultSetType=array",
         valueField: 'Id',
         textField: 'Desc',
         defaultFilter: 4
     });
     // 用法
     $HUI.combobox("#ItemInstructionWin", {
         url: $URL + "?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemInstruction&ResultSetType=array",
         valueField: 'Id',
         textField: 'Desc',
         defaultFilter: 4
     });
     // 疗程
     $HUI.combobox("#ItemDurationWin", {
         url: $URL + "?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDuration&ResultSetType=array",
         valueField: 'Id',
         textField: 'Desc',
         defaultFilter: 4
     });

 }

 function ItemClear(Data) {

     $("#ItemDescWin").val("");
     $("#ItemDoseQtyWin").numberbox('setValue', "");
     $("#ItemUOMWin").combobox('setValue', "");
     $("#ItemFrequenceWin").combobox('setValue', "");
     $("#ItemInstructionWin").combobox('setValue', "");
     $("#ItemDurationWin").combobox('setValue', "");

 }

 function GetDrugByArcIM(ArcIMID, PreItemID) {
     var LocID = session['LOGON.CTLOCID'];
     if (PreItemID == "") {
         var Info = tkMakeServerCall("web.DHCPE.CT.HISUICommon", "GetDrugByID", ArcIMID, LocID, "ArcimID");
     } else {
         var Info = tkMakeServerCall("web.DHCPE.CT.HISUICommon", "GetDrugByID", PreItemID, LocID, "PreItemID");
     }
     //alert(Info)
     var InfoOne = Info.split("^");
     $("#ItemDoseQtyWin").numberbox('setValue', InfoOne[0]);
     $("#ItemUOMWin").combobox('setValue', InfoOne[1]);
     $("#ItemFrequenceWin").combobox('setValue', InfoOne[2]);
     $("#ItemDurationWin").combobox('setValue', InfoOne[3]);
     $("#ItemInstructionWin").combobox('setValue', InfoOne[4]);

 }


 function UpdateDrugDetail(value) {
     //alert(value)
     var ArcimID = value.split("^")[1];
     var PreItemID = value.split("^")[0];
     var PreIADMID = PreItemID.split("||")[0];
     var AdmType = value.split("^")[2];
     var PreOrAdd = value.split("^")[3];

     var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ArcimID }, false);
     AddMedItem(ArcimID, itemInfo, PreIADMID, AdmType, PreOrAdd, PreItemID);
 }

 function AddMedItem(Id, itemInfo, RowId, AdmType, PreOrAdd, PreItemID) {
     var UserId = session['LOGON.USERID'];

     $("#AddMedItemWin").show();

     InitDrugInfo(Id); //初始化药品附加信息下拉列表

     $("#ItemDescWin").val(itemInfo.ARCIMDesc); //项目名称

     GetDrugByArcIM(Id, PreItemID); //根据医嘱项、预约项目初始化药品附加信息

     var AddMedItemWin = $HUI.dialog("#AddMedItemWin", {
         iconCls: 'icon-w-plus',
         resizable: true,
         collapsible: false,
         minimizable: false,
         maximizable: false,
         title: '药品信息',
         modal: true,

         onClose: function() {
             ItemClear("");
         },
         onOpen: function() {},
         buttonAlign: 'center',
         buttons: [{
             text: '确定',
             handler: function() {

                 ItemDoseQty = $("#ItemDoseQtyWin").val();
                 ItemDoseUOMID = $("#ItemUOMWin").combobox('getValue');
                 ItemFrequenceID = $("#ItemFrequenceWin").combobox('getValue');
                 ItemInstructionID = $("#ItemInstructionWin").combobox('getValue');
                 ItemDurationID = $("#ItemDurationWin").combobox('getValue');
                 var DrugInfo = ItemDoseQty + "^" + ItemDoseUOMID + "^" + ItemFrequenceID + "^" + ItemDurationID + "^" + ItemInstructionID;
                 if (PreItemID == "") {
                     $.cm({
                         ClassName: "web.DHCPE.PreItemList",
                         MethodName: "HISUIIInsertItem",
                         "AdmId": RowId,
                         "AdmType": AdmType,
                         "PreOrAdd": PreOrAdd,
                         "ArcItemId": Id,
                         "ArcItemSetId": "",
                         "UpdateUserId": UserId,
                         "DrugInfo": DrugInfo
                     }, function(jsonData) {
                         if (jsonData.ret == "") {
                             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                             var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                             var myDiv = document.getElementById("TotalFee");
                             myDiv.innerText = TotalAmount;
                             ItemClear("");
                             AddMedItemWin.close();
                             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                             var myDiv = document.getElementById("ConfirmInfo");
                             myDiv.innerText = ConfirmInfo;
                         } else {
                             $.messager.alert("提示", jsonData.ret, "info");
                         }

                     });
                 } else {
                     var ret = tkMakeServerCall("web.DHCPE.PreItemList", "UpdateDrugByPreItem", PreItemID, DrugInfo);
                     if (ret == "0") {
                         $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
                         AddMedItemWin.close();
                     }

                 }

             }

         }, {
             text: '取消',
             handler: function() {
                 ItemClear("");
                 AddMedItemWin.close();
             }
         }]
     });


 }

 function AddItem(arcitem) {

     var RowIdStr = $("#PIADM_RowId").val()
     //alert(RowIdStr)   
     if (RowIdStr == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     var FlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "GetArcItemRecLoc", arcitem, session['LOGON.CTLOCID']);
     var RecLocFlag = FlagStr.split("$")[0];
     var ARCIMDesc = FlagStr.split("$")[1];
     if (RecLocFlag != "1") {
         $.messager.alert("提示", ARCIMDesc + " 该医嘱没有维护接收科室,请与信息中心联系!", "info");
         return false;

     }

     var AdmIdStr = RowIdStr.split("^");
     var Rows = AdmIdStr.length;

     for (i = 0; i < Rows; i++) {
         var RowId = AdmIdStr[i]
         var ItemId = arcitem;

         var GAAuditedFlag = tkMakeServerCall("web.DHCPE.ResultEdit", "GeneralAdviceAudited", RowId, "CRM");
         if (GAAuditedFlag == "1") {
             $.messager.alert("提示", "总检建议已经审核,不能继续加项", "info");
             return false;
         }

         var IsAddItemFlagStr = tkMakeServerCall("web.DHCPE.HISUICommon", "IsRecPaper", RowId, session['LOGON.CTLOCID']);
         var IsRecPaperFlag = IsAddItemFlagStr.split("^")[0];
         var IsAddItemFlag = IsAddItemFlagStr.split("^")[1];
         if ((IsAddItemFlag != "Y") && (IsRecPaperFlag == "1")) {
             $.messager.alert("提示", "已经收表,不能加项", "info");
             return false;
         }

         var IsAddPhc = tkMakeServerCall("web.DHCPE.PreItemList", "IsAddPhcItem", RowId, AdmType, ItemId, PreOrAdd);
         if (IsAddPhc == "1") {
             if ("PERSON" == AdmType) {
                 $.messager.alert("提示", "个人不允许加药", "info");
                 return false;
             }
             if ("TEAM" == AdmType) {
                 $.messager.alert("提示", "分组不允许加药", "info");
                 return false;
             }
         }

         var ExcludeFlag = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistExcludeItem", RowId, AdmType, ItemId)
         if (ExcludeFlag == "1") {
             $.messager.alert("提示", "存在排斥项目，不允许添加", "info");
             return false;
         }

		//判断客户的性别、年龄范围是否与医嘱项维护的性别、年龄范围一致
         var ArcItemFlag= tkMakeServerCall("web.DHCPE.PreItemList","JustArcItemInfo",RowId, AdmType, ItemId);
         var Char_2=String.fromCharCode(2);
         var ArcItemFlagArr=ArcItemFlag.split(Char_2);
         if(ArcItemFlagArr[0]=="1"){
	          if(ArcItemFlagArr[1]!=""){
		          $.messager.alert("提示", "客户性别与医嘱项维护的性别不一致！", "info");
                   return false;
	           }
	           if(ArcItemFlagArr[2]!=""){
		          $.messager.alert("提示", "客户年龄与医嘱项维护的年龄不一致！", "info");
                  return false;
	             }
          }

         // 判断药品、材料类医嘱库存
         var Invent = tkMakeServerCall("web.DHCPE.HISUICommon", "FindInventary", ItemId, session['LOGON.CTLOCID']);
         if (Invent == "0") {
             $.messager.alert("提示", "库存不足，请查看库存！", "info");
             return false;
         }

         var flagret = tkMakeServerCall("web.DHCPE.PreItemList", "IsExistItem", RowId, AdmType, ItemId, "", session['LOGON.CTLOCID']);
         var flagArr = flagret.split("^");
         var flag = flagArr[0];


         if ("1" == flag) {


             if (flagArr[1] == "1") {

                 $.messager.confirm("操作提示", "项目已存在,是否再增加?", function(data) {
                     if (data) {
                         var UserId = session['LOGON.USERID'];

                         // 判断是否药品医嘱
                         var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

                         if (itemInfo.ItemOrderType == "R") {

                             AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
                         } else {

                             $.cm({
                                 ClassName: "web.DHCPE.PreItemList",
                                 MethodName: "HISUIIInsertItem",
                                 "AdmId": RowId,
                                 "AdmType": AdmType,
                                 "PreOrAdd": PreOrAdd,
                                 "ArcItemId": ItemId,
                                 "ArcItemSetId": "",
                                 "UpdateUserId": UserId
                             }, function(jsonData) {
                                 if (jsonData.ret == "") {
                                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                     var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                     var myDiv = document.getElementById("TotalFee");
                                     myDiv.innerText = TotalAmount;
                                     var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                     var myDiv = document.getElementById("ConfirmInfo");
                                     myDiv.innerText = ConfirmInfo;
                                 } else {

                                     $.messager.alert("提示", jsonData.ret, "info");
                                 }

                             });
                         }
                     } else {
                         return false;
                     }
                 });

             } else {
                 $.messager.alert("提示", "项目已存在,不能再增加.", "info");
                 return false;
             }
         } else if ("2" == flag) {
             $.messager.alert("提示", "项目中的化验项目,和已有项目有重复,是否继续添加?", "info")
             return false;
         }

         if (flagArr[1] == "1") { return false; }


         var ItemFlag;
         ItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ItemCanPreInfo", RowId, AdmType, ItemId)

         var ItemCanFlag = ItemFlag.split(",")

         if (ItemCanFlag[0] == -1) {
             var ItemCanStr = ""
             for (i = 1; i < ItemCanFlag.length; i++) {
                 if (ItemCanStr == "") { var ItemCanStr = ItemCanFlag[i]; } else { var ItemCanStr = ItemCanStr + "," + ItemCanFlag[i]; }
             }

             $.messager.confirm("操作提示", ItemCanStr, function(data) {
                 if (data) {
                     var UserId = session['LOGON.USERID'];

                     // 判断是否药品医嘱
                     var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

                     if (itemInfo.ItemOrderType == "R") {

                         AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
                     } else {

                         $.cm({
                             ClassName: "web.DHCPE.PreItemList",
                             MethodName: "HISUIIInsertItem",
                             "AdmId": RowId,
                             "AdmType": AdmType,
                             "PreOrAdd": PreOrAdd,
                             "ArcItemId": ItemId,
                             "ArcItemSetId": "",
                             "UpdateUserId": UserId
                         }, function(jsonData) {
                             if (jsonData.ret == "") {
                                 $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                                 var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                                 var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                                 var myDiv = document.getElementById("TotalFee");
                                 myDiv.innerText = TotalAmount;
                                 var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                                 var myDiv = document.getElementById("ConfirmInfo");
                                 myDiv.innerText = ConfirmInfo;
                             } else {

                                 $.messager.alert("提示", jsonData.ret, "info");
                             }

                         });
                     }
                 } else {
                     return false;
                 }
             });

         }

         if (ItemCanFlag[0] == -1) { return false; }

         var UserId = session['LOGON.USERID'];
         // 判断是否药品医嘱
         var itemInfo = $.cm({ ClassName: "web.DHCPE.CT.OrderSets", MethodName: "GetItemTypeAndDesc", ARCIMRowid: ItemId }, false);

         if (itemInfo.ItemOrderType == "R") {

             AddMedItem(ItemId, itemInfo, RowId, AdmType, PreOrAdd, ""); //添加药品附加信息
         } else {

             $.cm({
                 ClassName: "web.DHCPE.PreItemList",
                 MethodName: "HISUIIInsertItem",
                 "AdmId": RowId,
                 "AdmType": AdmType,
                 "PreOrAdd": PreOrAdd,
                 "ArcItemId": ItemId,
                 "ArcItemSetId": "",
                 "UpdateUserId": UserId
             }, function(jsonData) {

                 if (jsonData.ret == "") {


                     $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

                     var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", RowId, AdmType);
                     var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", RowId, AdmType);
                     var myDiv = document.getElementById("TotalFee");

                     myDiv.innerText = TotalAmount;
                     var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", RowId, AdmType);
                     var myDiv = document.getElementById("ConfirmInfo");
                     myDiv.innerText = ConfirmInfo;

                 } else {



                     $.messager.alert("提示", jsonData.ret, "info");
                 }

             });
         }
     }
 }

 //删除项目
 var Mfflag = "";

 function DeleteOrdItem_Click() {
     var gAdmId = $("#PIADM_RowId").val();
     if (gAdmId == "") {
         $.messager.alert("提示", "没有预约,不能删除！", "info");
         return false;
     }

     var rows = $("#PreItemList").datagrid("getChecked"); //获取的是数组，多行数据
     if (rows.length == 0) {
         $.messager.alert("提示", "请选择待删除的项目或套餐", "info");
         return false;
     }
     $.messager.confirm("确认", "确定要删除吗？", function(r) {
         if (r) {
             Mfflag = "";
             for (var i = 0; i < rows.length; i++) {
                 var ItemID = rows[i].RowId;
                 var SetsID = rows[i].OrderEntId;
                 //alert(ItemID+"^"+SetsID)
                 DeleteItemSetNew(ItemID + "^" + SetsID + "^0");
             }
             if (Mfflag.indexOf("1,") > "-1") {
                 $.messager.alert("提示", "项目已交费不能删除", "info");
                 return false;
             }
             if (Mfflag.indexOf("2,") > "-1") {
                 $.messager.alert("提示", "已总检审核不能删除", "info");
                 return false;
             }
             if (Mfflag.indexOf("3,") > "-1") {
                 $.messager.alert("提示", "项目已执行不能删除", "info");
                 return false;
             }
             if (Mfflag.indexOf("4,") > "-1") {
                 $.messager.alert("提示", "团体中个人存在执行过的项目不能删除", "info");
                 return false;
             }
             if (Mfflag.indexOf("6,") > "-1") {
                 $.messager.alert("提示", "已发药不能删除", "info");
                 return false;
             }



             var AdmIdStr = gAdmId.split("^");
             var AdmId = AdmIdStr[0];
             $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });

             var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", AdmId, AdmType);
             var myDiv = document.getElementById("TotalFee");
             if (myDiv) myDiv.innerText = TotalAmount;

             var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
             var myDiv = document.getElementById("ConfirmInfo");

             if (myDiv) { myDiv.innerText = ConfirmInfo; }
         }
     });
 }

 function DeleteItemSetNew(value) {

     var ordItemId = value.split("^")[0];

     var ordEntId = value.split("^")[1];

     var DeleteEntFlag = value.split("^")[2];

     if (DeleteEntFlag == "0") ordEntId = "";
     var OrderType = "ORDERITEM";
     var AddAmountFlag = "0";
     if (ordEntId != "") OrderType = "ORDERENT";


     if (OrderType == "ORDERITEM") { ordEntId = "" };
     if (OrderType == "ORDERENT") { ordItemId = "" };


     var gAdmType = AdmType;
     var gAdmId = $("#PIADM_RowId").val();

     var AdmIdStr = gAdmId.split("^");

     var Rows = AdmIdStr.length;
     for (i = 0; i < Rows; i++) {
         var AdmId = AdmIdStr[i]


         if (gAdmType == "PERSON") {

             if (ordItemId != "") {
                 var ordItemIdNew = tkMakeServerCall("web.DHCPE.PreItemList", "GetARCIMbyOEOrd", AdmId, ordItemId, "Item");

                 var ordEntIdNew = "";
             }
             if (ordEntId != "") {
                 var ordEntIdNew = tkMakeServerCall("web.DHCPE.PreItemList", "GetARCIMbyOEOrd", AdmId, ordEntId, "Ent");

                 var ordItemIdNew = "";
             }
         } else {
             ordItemIdNew = ordItemId;
             ordEntIdNew = ordEntId;
         }
         if ((ordItemIdNew == "") && (ordEntIdNew == "")) { return false; }
         //AddAmountFlag=tkMakeServerCall("web.DHCPE.PreItemList","GetAddAmountFlag",gAdmType,ordItemIdNew,ordEntIdNew);

         var DelAddAmountFlag = "0"
         var DelItemAddAmount = $("#DelItemAddAmount").checkbox('getValue');
         if (DelItemAddAmount) { DelAddAmountFlag = "1" }
         AddAmountFlag = DelAddAmountFlag;

         var flag = tkMakeServerCall("web.DHCPE.PreItemList", "IDeleteItem", AdmId, gAdmType, ordItemIdNew, ordEntIdNew, AddAmountFlag)
         /*
        if(flag!="") {  
            var fflag="";
            var fflag=flag.split("^")[0];
            if(fflag=="1"){var fflag="该项目已交费!";}
            if(fflag=="2"){alert("已经总检审核不能删除")}
            if(fflag=="3"){var fflag="该项目已执行!";}
            if(fflag=="4"){alert("团体中个人存在执行过的项目")}
            if(fflag=="6"){alert("已发药不能删除")}
            $.messager.alert("提示",fflag,"info");
            return false;
        }
    */
         if (flag != "") {
             var fflag = "";
             var fflag = flag.split("^")[0];
             if (Mfflag == "") Mfflag = fflag + ",";
             else { Mfflag = Mfflag + fflag + ","; }
             return Mfflag;

         }

     }
 }

 function DeleteItemSet(value) {
     $.messager.confirm("确认", "确定要删除吗？", function(r) {
         if (r) {
             var gAdmId = $("#PIADM_RowId").val();
             if (gAdmId == "") {
                 $.messager.alert("提示", "没有预约,不能删除！", "info");
                 return false;
             }


             var ordItemId = value.split("^")[0];

             var ordEntId = value.split("^")[1];

             var DeleteEntFlag = value.split("^")[2];

             if (DeleteEntFlag == "0") ordEntId = "";
             var OrderType = "ORDERITEM";
             var AddAmountFlag = "0";
             if (ordEntId != "") OrderType = "ORDERENT";


             if (OrderType == "ORDERITEM") { ordEntId = "" };
             if (OrderType == "ORDERENT") { ordItemId = "" };


             var gAdmType = AdmType;


             var AdmIdStr = gAdmId.split("^");

             var Rows = AdmIdStr.length;
             for (i = 0; i < Rows; i++) {
                 var AdmId = AdmIdStr[i]


                 if (gAdmType == "PERSON") {

                     if (ordItemId != "") {
                         var ordItemIdNew = tkMakeServerCall("web.DHCPE.PreItemList", "GetARCIMbyOEOrd", AdmId, ordItemId, "Item");

                         var ordEntIdNew = "";
                     }
                     if (ordEntId != "") {
                         var ordEntIdNew = tkMakeServerCall("web.DHCPE.PreItemList", "GetARCIMbyOEOrd", AdmId, ordEntId, "Ent");

                         var ordItemIdNew = "";
                     }
                 } else {
                     ordItemIdNew = ordItemId;
                     ordEntIdNew = ordEntId;
                 }
                 if ((ordItemIdNew == "") && (ordEntIdNew == "")) { return false; }
                 //AddAmountFlag=tkMakeServerCall("web.DHCPE.PreItemList","GetAddAmountFlag",gAdmType,ordItemIdNew,ordEntIdNew);

                 var DelAddAmountFlag = "0"
                 var DelItemAddAmount = $("#DelItemAddAmount").checkbox('getValue');
                 if (DelItemAddAmount) { DelAddAmountFlag = "1" }
                 AddAmountFlag = DelAddAmountFlag;

                 var flag = tkMakeServerCall("web.DHCPE.PreItemList", "IDeleteItem", AdmId, gAdmType, ordItemIdNew, ordEntIdNew, AddAmountFlag)
                 if (flag != "") {
                     var fflag = "";
                     var fflag = flag.split("^")[0];
                     if (fflag == "1") { var fflag = "该项目已交费!"; }
                     if (fflag == "2") { var fflag = "已经总检审核不能删除"; }
                     if (fflag == "3") { var fflag = "该项目已执行!"; }
                     if (fflag == "4") { var fflag = "项目已执行,不能删除"; }
                     if (fflag == "6") { var fflag = "已发药不能删除"; }
                     $.messager.alert("提示", fflag, "info");
                     return false;
                 }

                 $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: $("#PIADM_RowId").val(), AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
                 var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", AdmId, AdmType);
                 var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", AdmId, AdmType);
                 var myDiv = document.getElementById("TotalFee");
                 myDiv.innerText = TotalAmount;
                 var ConfirmInfo = tkMakeServerCall("web.DHCPE.PreItemList", "GetItemName", $("#PIADM_RowId").val(), AdmType);
                 var myDiv = document.getElementById("ConfirmInfo");
                 if (myDiv) { myDiv.innerText = ConfirmInfo; }

             }
         }
     });
 }
 /*
 function ReadRegInfo_OnClick()
   { 
     
     var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
     var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
     var myHCTypeDR=rtn.split("^")[0];
     

     var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
     

     var myary=myInfo.split("^");
     
     if(myary=="0")
     {
         $.messager.alert("提示","读卡失败或者没有读卡器！","info");
         return false;
     }
     
     if (myary[0]=="0")
     { 
       
       SetPatInfoByXML(myary[1]); 
       
       var mySexobj=document.getElementById("Sex");
       if (mySexobj){$("#Sex_DR_Name").combobox('setValue',mySexobj.value);}
       var myBirobj=document.getElementById("Birth");
         if(myBirobj){
         var mybirth=myBirobj.value;
           if (dtformat=="YMD"){
              if (mybirth.length==10){
             var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
             }else{
             var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
             }
         }
         if (dtformat=="DMY"){
             if (mybirth.length==10){
                 var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
             }else{
                 var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
             }
         }
       }
     if (myBirobj){$("#DOB").datebox('setValue',myBirobj.value);}
      
       var mycredobj=document.getElementById("CredNo");
       var myidobj=document.getElementById('IDCard');
         if ((mycredobj)&&(myidobj)){
             myidobj.value=mycredobj.value;
             
         }   
      }
      
     
     var photoobj=document.getElementById("PhotoInfo");
     if ((photoobj)&&(photoobj.value!="")){
         
         var src="data:image/png;base64,"+photoobj.value;
         document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+photoobj.value+' BORDER="0" width=120 height=140>'
     }
     else{
         var src='c://'+mycredobj.value+".bmp";
         var NoExistSrc="../images/uiimages/patdefault.png"; // //没有保存照片时显示的图片
         document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'
     
     
     }
     
     IDCardOnChange();

    }
    
 function SetPatInfoByXML(XMLStr)
 {
     XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
     var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
     if (!xmlDoc) return;
     
     //var xmlDoc=DHCDOM_CreateXMLDOM();
     //xmlDoc.async = false;
     //xmlDoc.loadXML(XMLStr);
     
     //if(xmlDoc.parseError.errorCode != 0) 
     //{    
         //$.messager.alert("提示",xmlDoc.parseError.reason,"info");
         //return; 
     //}
     
     var nodes = xmlDoc.documentElement.childNodes;
     if (nodes.length<=0){return;}
     for (var i = 0; i < nodes.length; i++) {

         
         //var myItemName=nodes(i).nodeName;
         //var myItemValue= nodes(i).text;
         
         var myItemName = getNodeName(nodes,i);
         
         var myItemValue = getNodeValue(nodes,i);
         if(myItemName=="Name") $("#Name").val(myItemValue);
         if(myItemName=="Address") $("#Address").val(myItemValue);
       
       
         
         
         if (myCombAry[myItemName]){
             myCombAry[myItemName].setComboValue(myItemValue);

         }else{
             DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
         }
     }
     delete(xmlDoc);
 }
 */
 function ReadRegInfo_OnClick() {

     var dtformat = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetSYSDatefomat")
     var rtn = tkMakeServerCall("DHCDoc.Interface.Inside.Service", "GetIECreat")
     var myHCTypeDR = rtn.split("^")[0];

     var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);

     var myary = myInfo.split("^");

     if (myary == "0") {
         $.messager.alert("提示", "读卡失败或者没有读卡器！", "info");
         return false;
     }

     if (myary[0] == "0") {

         SetPatInfoByXML(myary[1]);

         var PhotoInfo = $("#PhotoInfo").val();
         if (PhotoInfo != "") {

             var src = "data:image/png;base64," + PhotoInfo;
             document.getElementById("imgPic").innerHTML = '<img SRC="data:image/png;base64,' + PhotoInfo.replace(/(\r\n)|(\n)|(\r)/g, '') + '" BORDER="0" width=120 height=140>'
         } else {
             var src = 'c://' + $("#IDCard").val() + ".bmp"
             var NoExistSrc = "../images/uiimages/patdefault.png"; // //没有保存照片时显示的图片
             document.getElementById("imgPic").innerHTML = '<img SRC="' + src + '" BORDER="0" width=120 height=140 onerror=this.src="' + NoExistSrc + '">'
         }
     }


     IDCardOnChange();

 }

 function SetPatInfoByXML(XMLStr) {
     XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
     var xmlDoc = DHCDOM_CreateXMLDOMNew(XMLStr);
     if (!xmlDoc) return;


     var nodes = xmlDoc.documentElement.childNodes;
     if (nodes.length <= 0) { return; }
     for (var i = 0; i < nodes.length; i++) {

         var myItemName = getNodeName(nodes, i);

         var myItemValue = getNodeValue(nodes, i);

         //姓名
         if (myItemName == "Name") { $("#Name").val(myItemValue); }
         //地址
         if (myItemName == "Address") { $("#Address").val(myItemValue); }
         //性别
         if (myItemName == "Sex") $("#Sex_DR_Name").combobox('setValue', myItemValue);


         //出生日期
         if (myItemName == "Birth") {
             var mybirth = myItemValue;
             if (mybirth != "") {
                 if (dtformat == "YMD") {
                     if (mybirth.length == 10) {
                         var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(5, 7) + "-" + mybirth.substring(8, 10)
                     } else {
                         var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8)
                     }
                 }
                 if (dtformat == "DMY") {
                     if (mybirth.length == 10) {
                         var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(5, 7) + "-" + mybirth.substring(8, 10)
                     } else {
                         var mybirth = mybirth.substring(6, 8) + "/" + mybirth.substring(4, 6) + "/" + mybirth.substring(0, 4)
                     }
                 }
             }
             $("#DOB").val(mybirth);
         }

         //身份证号
         if (myItemName == "CredNo") { $("#IDCard").val(myItemValue); }

         //照片
         if (myItemName == "PhotoInfo") { $("#PhotoInfo").val(myItemValue); }



         if (myCombAry[myItemName]) {
             myCombAry[myItemName].setComboValue(myItemValue);

         } else {
             // DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue); //封装的谷歌浏览器不支持
         }
     }
     delete(xmlDoc);
 }

 var NetPreID = "";
 var NetSetsID = "";

 function IDCardOnChange() {

     var IDCard = $("#IDCard").val();
     var iPAPMICardType = $("#PAPMICardType_DR_Name").combobox('getText');
     if (iPAPMICardType.indexOf("身份证") != "-1") {
         var RegNo = tkMakeServerCall("web.DHCPE.PreIBaseInfo", "GetRegNoByIDCard", IDCard);
         if (RegNo == "") {
             //SetDefault();

             if ($("#PAPMINo").val() != "") {
                 $.messager.alert("提示", "还有其他客户信息，界面将被清空！", "info");
                 Clear_click();

             }

             if (IDCard != "") {
                 var ret = isIdCardNo(IDCard);
                 if (ret == true) {
                     GetInfoByIdCard(IDCard)
                     $("#IDCard").val(IDCard);
                 }
             }

             FindPreInfoByIDCard(IDCard);
             return false;
         }

         $("#PAPMINo").val(RegNo)
         RegNoOnChange();

         FindPreInfoByIDCard(IDCard);
     }
     return false;

 }

 $("#IDCard").keydown(function(e) {
     if (e.keyCode == 13) {

         var IDCard = $("#IDCard").val();
         var iPAPMICardType = $("#PAPMICardType_DR_Name").combobox('getText');
         if (iPAPMICardType.indexOf("身份证") != "-1") {
             var RegNo = tkMakeServerCall("web.DHCPE.PreIBaseInfo", "GetRegNoByIDCard", IDCard);
             if (RegNo == "") {
                 //SetDefault();
                 if ($("#PAPMINo").val() != "") {
                     $.messager.alert("提示", "还有其他客户信息，界面将被清空！", "info");
                     Clear_click();
                 }

                 if (IDCard != "") {
                     var ret = isIdCardNo(IDCard);
                     if (ret == true) {
                         GetInfoByIdCard(IDCard)
                         $("#IDCard").val(IDCard);
                     }
                 }

                 FindPreInfoByIDCard(IDCard);
                 return false;
             }

             $("#PAPMINo").val(RegNo)
             RegNoOnChange();

             FindPreInfoByIDCard(IDCard);
         }
         return false;
     }

 });



 function GetInfoByIdCard(num) {

     if (num == "") return true;
     var len = num.length;
     var re;
     var ShortNum = num.substr(0, num.length - 1)
     var ShortNum = ShortNum + "1"
     if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
     else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
     var a = (ShortNum).match(re);

     if (a != null) {

         if (len == 15) {
             var D = new Date("19" + a[3] + "/" + a[4] + "/" + a[5]);
             var B = D.getFullYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
         } else {
             var D = new Date(a[3] + "/" + a[4] + "/" + a[5]);
             var B = D.getFullYear() == a[3] && (D.getMonth() + 1) == a[4] && D.getDate() == a[5];
         }
         var dtformat = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetSYSDatefomat")
         if (dtformat == "YMD") {
             var mybirth = a[3] + "-" + a[4] + "-" + a[5];
         } else if (dtformat == "DMY") {
             var mybirth = a[5] + "/" + a[4] + "/" + a[3];
         }

         //var obj=document.getElementById("DOB");
         //if(obj){obj.value=mybirth;}
         $("#DOB").datebox('setValue', mybirth)
         var Dateinit = new Date
         var Yearinit = Dateinit.getFullYear();
         var Year = Yearinit - a[3]

         var myAge = tkMakeServerCall("web.DHCDocCommon", "GetAgeDescNew", mybirth, "")

         //DHCWebD_SetObjValueA("Age",myAge);
         $("#Age").val(myAge)
         if (len == 15) {
             var SexFlag = num.substr(14, 1);
         } else {
             var SexFlag = num.substr(16, 1);
         }
         var SexNV = ""
         var JsonData = $.cm({
             ClassName: "web.DHCPE.HISUICommon",
             MethodName: "GetDefault"
         }, false);

         var SexNV = JsonData.ret;

         SexNV = SexNV.split("^");


         if (SexFlag % 2 == 1) {
             $("#Sex_DR_Name").combobox('setValue', SexNV[2]);

         } else {
             $("#Sex_DR_Name").combobox('setValue', SexNV[3]);

         }

     }
     return true;
 }

 function FindPreInfoByIDCard(IDCard) {
     var LocID = session['LOGON.CTLOCID'];
     var ID = "";
     var obj = document.getElementById("ID");
     if (obj) ID = obj.value;
     if (ID != "") return false;
     var Info = tkMakeServerCall("web.DHCPE.NetPre.GetPreInfo", "GetInfo", IDCard, LocID);

     if (Info == "") return false;
     var Arr = Info.split("^");
     NetPreID = Arr[0];
     NetSetsID = Arr[1];
     var PreDate = Arr[2];
     if (PreDate != "") {
         $('#PEDateBegin').val(PreDate);
     }

     var obj = document.getElementById("Name");
     if (obj && obj.value == "") obj.value = Arr[3];
     var obj = document.getElementById("Sex_DR_Name");
     if (obj) obj.value = Arr[4];
     $("#VIPLevel").combobox('setValue', Arr[5]);
     VIPLevelOnChange();
     var obj = document.getElementById("PETime");
     if (obj) obj.value = Arr[6];
     var obj = document.getElementById("MobilePhone");
     if (obj && obj.value == "") obj.value = Arr[7];
     var obj = document.getElementById("Tel1");
     //if (obj&&obj.value=="") obj.value=Arr[7];
     if (obj && obj.value == "") obj.value = "";
     var obj = document.getElementById("PAPMINo");
     if (obj && obj.value == "") {
         obj.value = Arr[8];
     }
 }
 /*
 function isIdCardNo(num) {
     
     if (num=="") return true;
     var ShortNum=num.substr(0,num.length-1)
     if (isNaN(ShortNum))
     {
         alert("输入的不是数字?");
         return false;
     }
     var len = num.length;
     var re;
     if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
     else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
     else {alert("身份证号输入的数字位数不对?");
     websys_setfocus("IDCard");
     return false;}
     var ShortNum=ShortNum+"1"
     var a = (ShortNum).match(re);
     
     if (a != null)
     {
         if (len==15)
         {
             var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
             var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
         }
         else
         {
             var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
             var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
         }
         if (!B)
         {
             alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");
             websys_setfocus("IDCard");
             return false;
         }
         
         var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
         if (dtformat=="YMD"){
             var mybirth=a[3]+"-"+a[4]+"-"+a[5];
         }else if (dtformat=="DMY"){
             var mybirth=a[5]+"/"+a[4]+"/"+a[3];
         }
         
         $("#DOB").datebox('setValue',mybirth);
         
         var Dateinit=new Date;  
         var Yearinit=Dateinit.getFullYear();
         var Year=Yearinit-a[3]
         
         var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")
         
         DHCWebD_SetObjValueA("Age",myAge);

         if (len==15)
         {
             var SexFlag=num.substr(14,1);
         }
         else
         {
             var SexFlag=num.substr(16,1);
         }
         
         var JsonData=$.cm({
         ClassName:"web.DHCPE.HISUICommon",
         MethodName:"GetDefault"
         },false);
         
         var SexNV=JsonData.ret;
         
         SexNV=SexNV.split("^");
         
         
         if (SexFlag%2==1)
         {
             
             $('#Sex_DR_Name').combobox('setValue',SexNV[2]);
         }
         else
         {
             
             $('#Sex_DR_Name').combobox('setValue',SexNV[3]);
         }
         
     }
     return true;
 }
 */
 function isIdCardNo(pId) {
     pId = pId.toLowerCase();
     var arrVerifyCode = [1, 0, "x", 9, 8, 7, 6, 5, 4, 3, 2];
     var Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
     var Checker = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1];
     if (pId.length != 15 && pId.length != 18) {
         $.messager.alert("提示", "身份证号共有15位或18位", "info");
         return false;
     }
     var Ai = pId.length == 18 ? pId.substring(0, 17) : pId.slice(0, 6) + "19" + pId.slice(6, 15);

     if (!/^\d+$/.test(Ai)) {
         $.messager.alert("提示", "身份证除最后一位外必须为数字", "info");
         return false;
     }
     var yyyy = Ai.slice(6, 10),
         mm = Ai.slice(10, 12) - 1,
         dd = Ai.slice(12, 14);
     var d = new Date(yyyy, mm, dd),
         now = new Date();
     var year = d.getFullYear(),
         mon = d.getMonth(),
         day = d.getDate();
     if (year != yyyy || mon != mm || day != dd || d > now || year < 1901) {
         $.messager.alert("提示", "身份证输入错误", "info");
         return false;
     }
     for (var i = 0, ret = 0; i < 17; i++) ret += Ai.charAt(i) * Wi[i];
     Ai += arrVerifyCode[ret %= 11];

     if (pId.length == 18) {
         if (!validId18(pId)) {
             $.messager.alert("提示", "身份证号码有误,请检查!", "info");
             return false;
         }
     }
     if (pId.length == 15) {
         if (!validId15(pId)) {
             $.messager.alert("提示", "身份证号码有误,请检查!", "info");
             return false;
         }
     }
     return true;
 }

 function GetInfoFromIDCard(pId) {

     var pId = Get18IdFromCardNo(pId)
     if (pId == "") {
         return ["0", "", "", "", "", "", ""];
     }

     var id = String(pId);
     if (id.length == 18) {
         var sex = id.slice(14, 17) % 2 ? "男" : "女";

         var prov = "";

         var myMM = (id.slice(10, 12)).toString();
         var myDD = id.slice(12, 14).toString();
         var myYY = id.slice(6, 10).toString();
     } else {
         var prov = "";
         var sex = id.slice(14, 15) % 2 ? "男" : "女";
         var myMM = (id.slice(8, 10)).toString();
         var myDD = id.slice(10, 12).toString();
         var myYY = id.slice(6, 8).toString();
         if (parseInt(myYY) < 10) {
             myYY = '20' + myYY;
         } else {
             myYY = '19' + myYY;
         }

     }
     var myMM = myMM.length == 1 ? ("0" + myMM) : myMM;
     var myDD = myDD.length == 1 ? ("0" + myDD) : myDD;
     var sysDateFormat = tkMakeServerCall('websys.Conversions', 'DateFormat');
     if (sysDateFormat == "3") {
         var birthday = myYY + "-" + myMM + "-" + myDD;
     }
     if (sysDateFormat == "4") {
         var birthday = myDD + "/" + myMM + "/" + myYY;
     }
     var myAge = DHCWeb_GetAgeFromBirthDayA(birthday);

     return ["1", prov, birthday, sex, myAge];
 }

 function Get18IdFromCardNo(pId) {

     pId = pId.toLowerCase();

     var arrVerifyCode = [1, 0, "x", 9, 8, 7, 6, 5, 4, 3, 2];
     var Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
     var Checker = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1];

     if (pId.length != 15 && pId.length != 18) {
         alert("身份证号共有 15位或18位");
         return "";
     }
     if (pId.length == 18) {
         if (!validId18(pId)) {
             alert("身份证号码有误,请检查!");
             return "";
         }
     }
     if (pId.length == 15) {
         if (!validId15(pId)) {
             alert("身份证号码有误,请检查!");
             return "";
         }
     }
     var Ai = pId.length == 18 ? pId.substring(0, 17) : pId.slice(0, 6) + "19" + pId.slice(6, 15);

     if (!/^\d+$/.test(Ai)) {
         alert("身份证除最后一位外必须为数字");
         return "";
     }
     var yyyy = Ai.slice(6, 10),
         mm = Ai.slice(10, 12) - 1,
         dd = Ai.slice(12, 14);
     var d = new Date(yyyy, mm, dd),
         now = new Date();
     var year = d.getFullYear(),
         mon = d.getMonth(),
         day = d.getDate();
     if (year != yyyy || mon != mm || day != dd || d > now || year < 1901) {
         alert("身份证输入错误");
         return "";
     }


     for (var i = 0, ret = 0; i < 17; i++) ret += Ai.charAt(i) * Wi[i];
     Ai += arrVerifyCode[ret %= 11];

     return Ai;
 }

 function BSetDefaultVIP_click() {

     var VIP = $("#VIPLevel").combobox('getValue');
     var ret = tkMakeServerCall("web.DHCPE.VIPLevel", "SetDefaultVIP", session['LOGON.USERID'], VIP);
     if (ret == 0) {
         $.messager.alert("提示", "设置成功", "success");
         var DefaultVIP = tkMakeServerCall("web.DHCPE.HISUICommon", "GetDefaultVIP", session['LOGON.USERID']);
         $("#DefaultVIP").html(DefaultVIP);

     } else { $.messager.alert("提示", "设置失败", "error"); }

 }

 function VIPLevelOnChange() {
     var CTLocID = session['LOGON.CTLOCID'];
     var VIPLevel = $("#VIPLevel").combobox('getValue');
     if (VIPLevel == "") return false;
     var PatType = tkMakeServerCall("web.DHCPE.VIPLevel", "GetPatFeeType", VIPLevel, CTLocID)
     if (PatType != "") {
         $('#PatFeeType_DR_Name').combobox('setValue', PatType);
     }

     /***********诊室重新加载********************/
     $HUI.combobox("#RoomPlace", {
         onBeforeLoad: function(param) {
             var VIP = $("#VIPLevel").combobox("getValue");
             param.VIPLevel = VIP;
             param.GIType = "I";
             param.LocID = session['LOGON.CTLOCID']
         }
     });

     $('#RoomPlace').combobox('reload');
     /***********Z诊室重新加载********************/

     var DefaultRoomPlace = tkMakeServerCall("web.DHCPE.CT.RoomManagerEx", "GetDefaultRoomPlace", VIPLevel, "I", CTLocID);
     $('#RoomPlace').combobox('setValue', DefaultRoomPlace);

 }

 function OpenCharge_change(value) {
     var Flag = 0
     if (value) Flag = 1;

     var LocID = session['LOGON.CTLOCID'];
     var UserID = session['LOGON.USERID'];
     var ret = tkMakeServerCall("web.DHCPE.HISUICommon", "SetOpenCharge", Flag, LocID, UserID);

 }

 function IFeeAsCharged_change(value) {

     var AsCharged = "N";
     if (value) AsCharged = "Y";
     var ret = tkMakeServerCall("web.DHCPE.PreItemListEx", "SetIFeeAsCharged", PreAdmId, AsCharged);
     if (ret != "") {
         $.messager.alert("提示", ret, "info");
         if (ret == $g("团体不允许设置自费加项")) {
             $("#IFeeAsCharged").checkbox("disable");
             if (value) {
                 $("#IFeeAsCharged").checkbox('setValue', false);
             }

         }

     }
 }

 function AgeOnChange() {

     var iAge = $('#Age').val();

     if (iAge == "") return false;
     if (!(isNaN(iAge))) {
         var iDOB = $('#DOB').combobox('getValue');
         if (iAge == "") { iAge = 0 }
         //if (iDOB!="") return;

         iAge = parseInt(iAge)
         var D = new Date();
         var Year = D.getFullYear();
         var Year = Year - iAge;

         var dtformat = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetSYSDatefomat")
         if (dtformat == "YMD") {
             var newDOB = Year + "-01" + "-01";
         } else if (dtformat == "DMY") {
             var newDOB = "01" + "/" + "01" + "/" + Year;
         }

         $('#DOB').datebox('setValue', newDOB);


     }

 }

 function Name_keydown() {
     var iName = "";
     var obj = document.getElementById('Name');
     if (obj && "" != obj.value) { iName = obj.value; } else { return false; }
     var info = tkMakeServerCall("web.DHCPE.PreIBaseInfo", "GetPersonInfo", iName);
     if (info == 0) return;

     openNameWin(iName);
 }
 var picType = ".jpg"
 var PicFilePath = "D:\\"
 /*
 function BPhoto_click()
 {   
     var PAPMINo ="" 
     PAPMINo=getValueById('PAPMINo')
     
     //保存为jpg文件
     
     var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);
     
     
     if(PatientID==""){
         $.messager.alert("提示","基本信息ID不能为空。","info");
         return;
     }

     var PicHeight=300;
     var Picwidth=200;
     PEPhoto.FileName=PicFilePath+PAPMINo+picType; //保存图片的名称包括后缀
     if (PhotoFtpInfo==""){
         PEPhoto.FTPFlag="0" //是否上传到ftp服务器  0
     }else{
         var FTPArr=PhotoFtpInfo.split("^");
         PEPhoto.DBFlag = "0" //是否保存到数据库  0  1
         PEPhoto.FTPFlag = "1" //是否保存到FTP  0  1
         PEPhoto.AppName = FTPArr[4]+"/" //ftp目录
         PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP服务器
         PicHeight=FTPArr[5];
         Picwidth=FTPArr[6];
     }
     PEPhoto.PicWidth=Picwidth;
     PEPhoto.PicHeight=PicHeight;
     PEPhoto.PatientID=PatientID //PA_PatMas表的ID
     PEPhoto.ShowWin()
     InitPicture()
 }
 */

 /**
  * [websocket 客户端拍照]
  * @param    {[String]}    regNo [登记号]
  * @Author   wangguoying
  * @DateTime 2021-01-28
  */
 function photo_client(regNo) {
	 var paramJson = tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetCameramParam","PREIADM");
     var execParam = JSON.parse(paramJson);
     execParam.RegNo = regNo;
     execParam.business = "PECAMERA";
     execParam.imgName = regNo + ".png"
     
     var json = JSON.stringify(execParam);
     $PESocket.sendMsg(json, peSoceket_onMsg);
 }
 /**
  * [websocket 客户端通信回调函数]
  * @param    {[String]}    param [客户端接收到的 json串]
  * @return   {[Object]}    event [客户端返回的信息内容]
  * @Author   wangguoying
  * @DateTime 2021-01-28
  */
 function peSoceket_onMsg(param, event) {
     var paramObj = JSON.parse(param);
     var obj = JSON.parse(event.data);
     if (obj.body && obj.body != "") {
         $("#imgPic").html('<img SRC="data:image/png;base64,' + obj.body.replace(/(\r\n)|(\n)|(\r)/g, '') + '" BORDER="0" width=120 height=140>');
     }
     var ret = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "SavePhotoStr", paramObj.RegNo, obj.body);
 };

 function BPhoto_click() {
     var PAPMINo = ""
     PAPMINo = getValueById('PAPMINo')

     //保存为jpg文件
     var PatientID = tkMakeServerCall("web.DHCPE.PreIADM", "GetPatientID", PAPMINo);

     if (PatientID == "") {
         $.messager.alert("提示", "基本信息ID不能为空。", "info");
         return;
     }
     return photo_client(PAPMINo);
     var userAgent = navigator.userAgent;
     var isChrome = navigator.userAgent.indexOf('Chrome') > -1
     if (isChrome) {

         var PicHeight = 300;
         var Picwidth = 200;
         PEPhoto.FileName = PicFilePath + PAPMINo + picType; //保存图片的名称包括后缀
         if (PhotoFtpInfo == "") {
             PEPhoto.FTPFlag = "0" //是否上传到ftp服务器  0
         } else {
             var FTPArr = PhotoFtpInfo.split("^");
             PEPhoto.DBFlag = "0" //是否保存到数据库  0  1
             PEPhoto.FTPFlag = "1" //是否保存到FTP  0  1
             PEPhoto.AppName = FTPArr[4] + "/" //ftp目录
             PEPhoto.FTPString = FTPArr[0] + "^" + FTPArr[1] + "^" + FTPArr[2] + "^" + FTPArr[3] //FTP服务器
             PicHeight = PicHeight //FTPArr[5];
             Picwidth = Picwidth //FTPArr[6];
         }
         PEPhoto.PicWidth = Picwidth;
         PEPhoto.PicHeight = PicHeight;
         PEPhoto.PatientID = PatientID //PA_PatMas表的ID
         PEPhoto.ShowWin()
         InitPicture()

         /*    
         $HUI.window("#PhotoWin",{
             title:"体检拍照",
             iconCls:"icon-w-stamp",
             collapsible:false,
             minimizable:false,
             maximizable:false,
             closable:true,
             resizable:false,
             modal:true,
             width:800,
             height:600,
             content:'<iframe src="dhcpephotochrome.csp?RegNo='+PAPMINo+'" width="100%" height="100%" frameborder="0"></iframe>'
         });
         */
     } else {
         $HUI.window("#PhotoWin", {
             title: "体检拍照",
             iconCls: "icon-w-stamp",
             collapsible: false,
             minimizable: false,
             maximizable: false,
             closable: true,
             resizable: false,
             modal: true,
             width: 800,
             height: 600,
             content: '<iframe src="dhcpephoto.csp?RegNo=' + PAPMINo + '" width="100%" height="100%" frameborder="0"></iframe>'
         });
     }

 }

 function ChangeFeeTypeFuction() {
     var eSrc = window.event.srcElement;
     var IADM = getValueById("PIADM_RowId")
     var GADM = tkMakeServerCall("web.DHCPE.HISUICommon", "GetGADMByIADM", IADM);

     if ((AdmType == "PERSON") && (GADM == "")) {
         $.messager.alert("提示", "不是团体人员,不允许操作！", "info");
         return false;
     }
     var ChangePhcItemFlag = tkMakeServerCall("web.DHCPE.PreItemList", "ChangePhcItem", eSrc.id)
     if (ChangePhcItemFlag == "1") {
         $.messager.alert("提示", "不允许开药，不能转换！", "info");
         return false;
     }
     var ret = tkMakeServerCall("web.DHCPE.PreItemListEx", "ChangeFeeType", eSrc.id);
     if (ret == "0") {
         $("#PreItemList").datagrid('load', { ClassName: "web.DHCPE.Query.PreItemList", QueryName: "QueryPreItemList", AdmId: IADM, AdmType: AdmType, PreOrAdd: PreOrAdd, AddType: "Item", SelectType: "ItemSet", ShowFlag: "", Control: "", BType: "B", LocID: session['LOGON.CTLOCID'], hospId: session['LOGON.HOSPID'] });
         var TotalAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetOrdAmountHISUI", IADM, AdmType);
         var GZAmount = tkMakeServerCall("web.DHCPE.PreItemList", "IGetGZAmount", IADM, AdmType);
         var myDiv = document.getElementById("TotalFee");
         myDiv.innerText = TotalAmount;
         return false;
     }
     $.messager.alert("提示", "转换失败:" + ret, "info");

     return false;
 }

 /**
  * 打开调查问卷窗口
  * @param    {[String]}    iPIADMRowId [预约ID]
  * @Author   wangguoying
  * @DateTime 2019-04-10
  */
 function openSurveyWin(iPIADMRowId) {
     $HUI.window("#SurveyWin", {
         title: "调查问卷",
         iconCls: "icon-w-paper",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 900,
         height: 600,
         content: '<iframe src="dhchm.questiondetailset.csp?PreIADM=' + iPIADMRowId + '" width="100%" height="100%" frameborder="0"></iframe>'
     });
 }

 /**
  * 填写完调查问卷之后执行
  * @Author   wangguoying
  * @DateTime 2019-04-10
  */
 var afterSurvey = function(iPIADMRowId) {
     if (RecommendFlag == "Y") {
         openRecommendWin(iPIADMRowId);
     } else {
         //$.messager.alert("提示","预约成功!","success");
     }

 }

 /**
  * 打开推荐套餐窗口
  * @param    {[String]}    iPIADMRowId [预约ID]
  * @Author   wangguoying
  * @DateTime 2019-04-10
  */
 function openRecommendWin(iPIADMRowId) {
     $HUI.window("#RecommendWin", {
         title: "推荐套餐",
         iconCls: "icon-book",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         resizable: false,
         closable: false,
         modal: true,
         width: 600,
         height: 400,
         content: '<iframe src="dhchm.recommenditem.csp?PreIADM=' + iPIADMRowId + '" width="100%" height="100%" frameborder="0"></iframe>'
     });
 }


 /**
  * 推荐套餐之后执行
  * @Author   wangguoying
  * @DateTime 2019-04-12
  */
 var afterRecommend = function(ret, iPIADMRowId) {
     if (ret != "") {
         var UserID = session['LOGON.USERID'];
         var InsertRet = tkMakeServerCall("web.DHCPE.PreItemList", "IInsertItem", iPIADMRowId, AdmType, PreOrAdd, "", ret, UserID)
         if (InsertRet != "") {
             $.messager.alert("错误", "插入推荐套餐失败：" + InsertRet, "error");
         } else {
             $("#PreItemList").datagrid("reload");
         }
     } else {
         //$.messager.alert("提示","预约成功,请自选项目","success");
     }

 }

function BPreDate_click() {
    var ExpStr = "";
    var PIADMRowId = $("#PIADM_RowId").val();

    if (PIADMRowId == "") {
        var sexId = $("#Sex_DR_Name").combobox('getValue');
        var levelId = $("#VIPLevel").combobox('getValue');
        var pgid = $("#PGADM_DR_Name").combogrid("getValue");
        if (sexId == "" || levelId == "") {
            $.messager.alert("提示", "请先选择性别和VIP等级！", "info");
            return false;
        }
        ExpStr = sexId + "^" + levelId + "^" + pgid;
    }

    var lnk = "dhcpe.predate.select.csp?PIADM=" + PIADMRowId + "&ExtStr=" + ExpStr + "&CBFunc=SetBeginDate&WinId=SelectDateWin";



    $HUI.window("#SelectDateWin", {
        title: "号源池",
        iconCls: "icon-book",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 720,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="99%" frameborder="0"></iframe>'
    });



    //websys_lu(lnk,false,'iconCls=icon-w-clock,width=1000,height=700,hisui=true,title='+$g('预约时间'))

}

function SetBeginDate(piadm,date, time, detailId) {
    //alert(date + " " + time + " " +  detailId);
    setValueById("PETime", time)
    $("#PEDateBegin").datebox('setValue', date);
    $("#PEDateBegin").datebox("disable");
    $("#DetailID").val(detailId);
    return 0;
}

 //刷新项目 
 function BReload_click() {

     $("#PreItemList").datagrid('load', {
         ClassName: "web.DHCPE.Query.PreItemList",
         QueryName: "QueryPreItemList",
         AdmId: PreAdmId,
         AdmType: AdmType,
         PreOrAdd: PreOrAdd,
         AddType: "Item",
         SelectType: "ItemSet",
         ShowFlag: "",
         Control: "",
         BType: "B",
         LocID: session['LOGON.CTLOCID'],
         hospId: session['LOGON.HOSPID']
     });
 }

 // 获取危害因素 及 对应的接害工龄
 function GetHarmInfo() {
     // HarmInfo  HarmWorkYear  HarmWorkMonth
     var HarmInfoObj = $("input[comboname='HarmInfo']");
     var HarmWorkYearObj = $("input[numberboxname='HarmWorkYear']");
     var HarmWorkMonthObj = $("input[numberboxname='HarmWorkMonth']");

     var harmInfo = "",
         ErrInfo = "";
     $.each(HarmInfoObj, function(index, value) {
         var endanger = $(value).combotree("getValues").join(",");
         var workYear = $(HarmWorkYearObj[index]).numberbox("getValue");
         var workMonth = $(HarmWorkMonthObj[index]).numberbox("getValue");
         if (endanger != "" && workYear == "" && workMonth == "") {
             ErrInfo = "请填写危害因素对应的接害工龄！";
             $(HarmWorkYearObj[index]).numberbox({ required: true });
             $(HarmWorkMonthObj[index]).numberbox({ required: true });
             return false;
         } else if (endanger == "" && (workYear != "" || workMonth != "")) {
             ErrInfo = "请选择危害因素！";
             $(value).combotree({ required: true });
             return false;
         }
         if (endanger == "") return true;
         if (harmInfo == "") {
             harmInfo = endanger + "^" + workYear + "^" + workMonth;
         } else {
             harmInfo = harmInfo + "&" + endanger + "^" + workYear + "^" + workMonth;
         }
     });
     if (ErrInfo != "") return { code: "-1", msg: ErrInfo };
     else return { code: "0", msg: harmInfo };
 }

 // 设置危害因素 及 对应的接害工龄
 function SetHarmInfo(harmInfo) {
     if (harmInfo == "") return fasle;
     var harm = harmInfo.split("&");

     $(".DelEndangerInfo").parents("tr").remove();

     var len = harm.length;
     for (var i = 0; len > 1 && len > (i + 1); i++) {
         AddHarmInfo();
     }

     var HarmInfoObj = $("input[comboname='HarmInfo']");
     var HarmWorkYearObj = $("input[numberboxname='HarmWorkYear']");
     var HarmWorkMonthObj = $("input[numberboxname='HarmWorkMonth']");

     $.each(HarmInfoObj, function(index, value) {
         if (harm[index].split("^")[0] == "") return true;
         $(value).combotree("setValues", harm[index].split("^")[0].split(","));
         $(HarmWorkYearObj[index]).numberbox("setValue", harm[index].split("^")[1]);
         $(HarmWorkMonthObj[index]).numberbox("setValue", harm[index].split("^")[2]);
     });
 }

// 增加 危害因素及 接害工龄
function AddHarmInfo() {
    var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion"); //判断是"炫彩"还是"极简"版本？
    var inpWid = "150px", numWid = "40px", colspan = "", padding_L = "";
    if ($('#ZYBTabItem').length > 0) {
        inpWid = "207px", numWid = "61px";
        colspan = "colspan=2"
        padding_L = " style='padding-left:10px;'";
    }
    
    var AddHtml = '<tr>' +
        '   <td></td>' +
        '   <td align="right"><label>接害因素</label></td>' +
        '   <td class="zy_td_padding"><input class="hisui-combotree" type="text" name="HarmInfo" style="width:' + inpWid + ';"/></td>'

        +
        '   <td align="right" class="zy_td_padding"><label>接害工龄</label></td>' +
        '   <td ' + colspan + ' class="zy_td_padding">' +
        '       <input class="hisui-numberbox textbox" data-options="min:0, max:65" type="text" name="HarmWorkYear" style="width:' + numWid + ';"/>' +
        '       <label>年</label>' +
        '       <input class="hisui-numberbox textbox" data-options="min:0, max:11" type="text" name="HarmWorkMonth" style="width:' + numWid + ';"/>' +
        '       <label>月</label>' +
        '       <a class="hisui-linkbutton DelEndangerInfo"' + padding_L + ' iconCls="icon-cancel" plain="true" onclick="DelHarmInfo(this)">'
        '   </td>';

    //AddHtml += '<td><a class="hisui-linkbutton" iconCls="icon-cancel" plain="true" onclick="DelHarmInfo(this)"></a>';
    AddHtml += '</tr>';
    $("#OccuBaseInfo tr:eq(-2)").after(AddHtml);
    $HUI.combotree("#OccuBaseInfo tr:eq(-2) input[name='HarmInfo']", {
        url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
        checkbox: true,
        multiple: true,
        onlyLeafCheck: true
    });
    $.parser.parse("#OccuBaseInfo tr:eq(-2)");
}

 // 删除当前行 危害因素及 接害工龄
 function DelHarmInfo(target) {
     $(target).parents("tr").remove();
 }

 //复制项目
 function BCopyItem_click() {

     var PIADM = $("#PIADM_RowId").val();

     if (PIADM == "") {
         $.messager.alert("提示", "请先预约！", "info");
         return false;
     }

     $HUI.window("#CopyItemWin", {
         title: "复制项目",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 1200,
         height: 600,
         content: '<iframe src="dhcpecopyitem.hisui.csp?PreIADM=' + getValueById("PIADM_RowId") + '&AdmType=' + AdmType + '&PreOrAdd=' + PreOrAdd + '" width="100%" height="99%" frameborder="0"></iframe>'
     });

 }

 // 复查记录显示
 function SelReviewRecord() {
     var iPAPMINo = $("#PAPMINo").val();
     var iIDCard = $("#IDCard").val();
     if (iPAPMINo == "" && iIDCard == "") {
         $.messager.alert("提示", "请先输入基本信息！", "info");
         return false;
     }
     var iCardType = $("#PAPMICardType_DR_Name").combobox("getValue");


     var iVIPLevel = $("#VIPLevel").combobox("getValue");
     if (iVIPLevel == "") {
         $.messager.alert("提示", "请先选择VIP等级！", "info");
         return false;
     }

	 var VIPLevel = $("#VIPLevel").combobox('getText');
    
     // 通过登记号或证件号、VIP判断是否已有已总检过的记录

     $HUI.window("#ReviewWin", {
         title: "已完成的体检记录",
         iconCls: "icon-w-list",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: false,
         resizable: false,
         modal: true,
         width: 1200,
         height: 600,
         onClose: function() {

         },
         onBeforeClose: function() {
             var RVSelectID = $("#RVSelectID").val();
             if (RVSelectID == "NoSumRecord") {
                 $.messager.alert("提示", "该VIP等级下不存在已总检的体检记录，确定VIP等级后再重新勾选复查！", "info");
                 $("#ReCheckFlag").checkbox('setValue', false);
				 $("#RVSelectID").val("");
             } else if (RVSelectID != "") {
                 if (RVSelectID == "RVColse") $("#RVSelectID").val("");
                 Save();
                 if (RVSelectID != "RVColse") {
					if (VIPLevel == $g("职业病")) {
                     // 保存上次职业病信息
                     $cm({
                         ClassName: "web.DHCPE.OccupationalDisease",
                         MethodName: "SetOccuInfoByOri",
                         OriPreIADM: RVSelectID,
                         NewPreIADM: $("#PIADM_RowId").val()
                     }, function(ret) {
                         if (ret.code == "0") {
                             $cm({
                                 ClassName: "web.DHCPE.OccupationalDisease",
                                 MethodName: "GetPreOccuInfo",
                                 PreIADM: RVSelectID
                             }, function(jsonData) {
                                 if (jsonData.code == "0") {
                                     if (jsonData.msg != "") {
                                         setValueById("Industry", jsonData.msg.Industry);
                                         setValueById("Typeofwork", jsonData.msg.WorkType);

                                         if (jsonData.msg.OthWorkType != "") {
                                             setValueById("OthWorkType", jsonData.msg.OthWorkType);
                                             $("#OthWorkType").validatebox("setDisabled", false);
                                         } else {
                                             $("#OthWorkType").validatebox("setDisabled", true);
                                         }

                                         setValueById("ZYTypeofwork", jsonData.msg.WorkType);
                                         setValueById("WorkNo", jsonData.msg.JobNumber);
                                         setValueById("AllWorkYear", jsonData.msg.WorkAgeY);
                                         setValueById("AllWorkMonth", jsonData.msg.WorkAgeM);
                                         setValueById("Category", jsonData.msg.OMEType);
                                         SetHarmInfo(jsonData.msg.HarmInfo);
                                     }
                                 } else {
                                     $.messager.alert("提示", jsonData.msg, "info");
                                 }
                             });
                         } else {
                             $.messager.alert("提示", "职业病信息保存失败！" + ret.msg + "！请手动维护", "info");
                         }
                     });
					}
                 }
             } else {
                 $.messager.alert("提示", "复查需要选择对应复查记录！", "info");
                 return false;
             }
         },
         href: "dhcpepreiadm.review.csp?PAPMINo=" + iPAPMINo + "&IDCard=" + iIDCard + "&CardType=" + iCardType + "&VIPLevel=" + iVIPLevel + "",
         //content:"<iframe src='dhcpepreiadm.review.csp?PAPMINo=" + iPAPMINo + "&IDCard=" + iIDCard + "&CardType=" + iCardType + "&VIPLevel=" + iVIPLevel + "' width='100%' height='99%' frameborder='0'></iframe>"
     });
 }

// 极简炫彩格式修改
function ChangeHISUICss() {
    var borderColor1 = "#ddd";
    if (HISUIStyleCode == "lite") {
        borderColor1 = "#E2E2E2";
    }
    $(".inherit-border").css("border-bottom-color", borderColor1);

}
 $(init);