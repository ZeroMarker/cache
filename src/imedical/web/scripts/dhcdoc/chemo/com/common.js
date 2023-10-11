/**
 * common.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-10
 * 
 */
 
var PLObject = GlobalObj = PageLogicObj = {}

function createGMisModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        if (PLObject.v_Type=="CUR") {
		        //InitStageInfo(PLObject.v_PSID,PLObject.v_Type,PLObject.v_SelectDate);
		        InitGMis()
		    }	        
	        destroyDialog(id);
	    }
    });
}

function createComDateModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        PLObject.v_ComDateNum=0;
	        console.log(PLObject.v_ComDateNum)
	    }
    });
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function LoadBar(EpisodeID,PatientID){
    if(typeof InitPatInfoBanner=='function'){
        return InitPatInfoBanner(EpisodeID);
    }
	//dhcdoc.in.patient.banner.csp
	EpisodeID=EpisodeID||"",PatientID=PatientID||"";
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID},function(html){
		if (html!=""){
			$(".patientbar").data("patinfo",html);
			if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
			else{$(".PatInfoItem").html(reservedToHtml(html))}
			$(".PatInfoItem").find("img").eq(0).css("top",0);
			
		}else{
			$(".PatInfoItem").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});
};

function InitPatInfoHover(){
	var btnsWidth = 50;
	//if (patientListPage!="") btnsWidth = 150;
	var html = $(".patientbar").data("patinfo");
	$(".PatInfoItem").html(reservedToHtml(html)).css({height:30,overflow:'hidden',paddingRight:10});
	$(".PatInfoItem").css('width',$(".patientbar").width()-btnsWidth);
	$(".PatInfoItem").popover('destroy');
	setTimeout(function(){
		var html = $(".patientbar").data("patinfo");
		if (($(".PatInfoItem")[0].offsetHeight+13)<$(".PatInfoItem")[0].scrollHeight) {
			$(".PatInfoItem").popover({
				width:$(".PatInfoItem").width()+16,trigger:'hover',
				arrow:false,style:'patinfo',
				content:"<div class='patinfo-hover-content'>"+reservedToHtml(html)+"</div>"
			});
			$(".PatInfoItem").append('<div style="position:absolute;top:0px;right:0px;">...</div>')
		}
	},500);
};

function LoadBarOld(EpisodeID,PatientID){
	//dhcdoc.in.patient.banner.csp
	EpisodeID=EpisodeID||"",PatientID=PatientID||"";
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID},function(html){
		if (html!=""){
			$(".PatInfoItem").html(reservedToHtml(html));
			$(".PatInfoItem").find("img").eq(0).css("top",0);
			if (($(".PatInfoItem")[0].offsetWidth+150)>window.screen.width) {
				$(".PatInfoItem").append('<div style="position:absolute;top:0px;right:0px;">...</div>')
			}
			
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
				//html=reservedToHtml(html);
				layer.tips(html, '#patInfo', {
    				tips: [1, '#87CEFA'],	//#87CEFA
    				area: ['1000px', 'auto'],
    				time: 0
				});
			});
			$("#patInfo").mouseout(function(){
				//layer.closeAll()
			});
			
			
		}else{
			$(".PatInfoItem").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});
};

function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

function ClearAllList(obj) {
    for (var i = obj.options.length - 1; i >= 0; i--) obj.options[i] = null;
}

function SetFocusCell(rowid, colname) {
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(rowid + "_" + colname);
        if (obj) {
            websys_setfocus(rowid + "_" + colname);
        }
        PageLogicObj.FocusRowIndex = rowid;
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            websys_setfocus(colname);
        }
    }
}

function GetAllRowId(id) {
    var rowids = $('#'+id).getDataIDs();
    return rowids;
}

function EndEditRow(id, rowid) {
	//return false;
    //var obj = document.getElementById(rowid + "_OrderName");
	var selector = rowid + "_OrderName";
	
	var arcim = GetCellData(id,rowid,"OrderARCIMRowid");
	if (arcim == "") {
		$("#"+id).delRowData(rowid)
	}
	var obj = $("#"+id+" [id='"+selector+"']")[0];
    if (obj) {
        $("#"+id).saveRow(rowid);
    }
    
	    
}

function EditRowCommon(id, rowid, EnableOrd) {
    if ($.isNumeric(rowid) == true) {
        $('#'+id).editRow(rowid, false); //false 去掉回车保存
        if ((typeof EnableOrd != "undefined") && (EnableOrd == false)) {
            return
        }
    }
    //结束其他行编辑
    var records = $('#'+id).getGridParam("records");
    for (var i=1;i<=records;i++) {
	    if (i==rowid) {
			continue;    
		}
	    //EndEditRow(id,i)
	}
    //
 	//$('#'+id).editRow(rowid, false);
	$("#"+id).setSelection(rowid, true);
	InitRowLookUp(id,rowid);
	//$("#"+id).setSelection(rowid, false);
	 
    //
    
}

function GetNewrowid(id) {
    var rowid = "";
    var rowids = $('#'+id).getDataIDs();	//[1,2]
    if (rowids.length > 0) {
        var prerowid = rowids[rowids.length - 1];
        if (prerowid.indexOf(".") >= 0) {
	        prerowid = prerowid.split(".")[0];
        } 
        //过滤新行QP
        var OrderARCIMRowid = GetCellData(id, prerowid, "OrderARCIMRowid");
        if (OrderARCIMRowid=="")  rowid = parseInt(prerowid);
        else rowid = parseInt(prerowid) + 1; 
    } else {
        rowid = 1;
    }
    return rowid;
}

function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}

function GetCurr_time() {
    var CurrDateTime = tkMakeServerCall("DHCDoc.THPY.COM.Func","GetCurrentDateTime");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
	
    return CurrDateTime;
}

function DeleteRow(id,rowid) {
	$('#'+id).delRowData(rowid);
}

function GetAddRowid(id){
	var rowid=""
	if (rowid==""){
		var CruRow = GetPreRowId(id);
		if ((CruRow!="")&&(CheckIsClear(id,CruRow) == true)) {
			DeleteRow(CruRow);
			rowid = GetNewrowid(id);
		}else{
			rowid = GetNewrowid(id);
		}
	}
	return rowid;
}

function CheckIsClear(id,rowid) {
    var OrderARCIMRowid = GetCellData(id,rowid, "OrderARCIMRowid");
    //var OrderARCOSRowid = GetCellData(id,rowid, "OrderARCOSRowid");
    if (OrderARCIMRowid != "") {
        return false;
    } else {
        return true;
    }
}

function GetPreRowId(id,rowid) {
    var prerowid = "";
    var rowids = $('#'+id).getDataIDs();
    if ($.isNumeric(rowid) == true) {
        for (var i = rowids.length; i >= 0; i--) {
            if (rowids[i] == rowid) {
                if (i == 0) {
                    prerowid = rowids[i];
                } else {
                    prerowid = rowids[i - 1];
                }
                break;
            }
        }
    }
    if (prerowid == "") {
        if (rowids.length == 0) {
            prerowid = ""
        } else {
            prerowid = rowids[rowids.length - 1];
        }
    }
    return prerowid;
}

function Add_Order_row2(id,newDataObj) {
    var rowid = newDataObj["id"];
    $('#'+id).addRowData(rowid, newDataObj);
    return rowid;
}

function Add_Order_row(id,PLObject) {
    var rowid = "";
    var records = $('#'+id).getGridParam("records");
    if (records >= 1) {
        var prerowid = GetPreRowId(id);
        //最后一行是否有数据
        var OrderARCIMRowid = GetCellData(id, prerowid, "OrderARCIMRowid");
        if ((OrderARCIMRowid == "" || OrderARCIMRowid == null)) {
            //设置焦点
            SetFocusCell(prerowid, "OrderName");
            return false;
        }
    }
    rowid = GetNewrowid(id);
   	
    if (rowid == "" || rowid == 0) { return; }
    //设置默认值     
    var DefaultData = GetDefaultData(id,rowid,PLObject);
    DefaultData['id'] = rowid;
    
    $('#'+id).addRowData(rowid, DefaultData);
    EditRowCommon(id,rowid);
    $("#"+id).setSelection(rowid, false);
    return rowid;
}

function Delete_Order_row(id) {
    var ids = $('#'+id).jqGrid("getGridParam", "selarrrow");
	//console.log(ids)	//用主键返回的数组
    if (ids == null || ids.length == 0) {
        if (PageLogicObj.FocusRowIndex > 0) {
            //如果有焦点行,则直接删除焦点行 jqg_GroupGrid_2
            if ($("#jqg_"+id+"_" + PageLogicObj.FocusRowIndex).prop("checked") != true) {
                $("#"+id).setSelection(PageLogicObj.FocusRowIndex, true);
            }
        }
    }
    var ids = $('#'+id).jqGrid("getGridParam", "selarrrow");
    if (ids == null || ids.length == 0) {
        $.messager.alert("警告", "请选择要删除的记录","warning");
        return;
    }
    var OrdItemRowStr = "";
    $.messager.confirm('确认对话框', '确定删除选中的记录吗？', function(r){
		if (r){
		    // 退出操作;
		    var len = ids.length;
			var arcim = "",PGIId="";
	        var DeleteCount = 0;
	        for (var i = 0; i < len; i++) {
				if (arcim=="") {
					arcim = GetCellData(id,ids[i - DeleteCount],"OrderARCIMRowid");
					PGIId = GetCellData(id,ids[i - DeleteCount],"PGIId");
				}
				var result = Del_PGItem(id,ids[i - DeleteCount]);
				if (result) {
					$('#'+id).delRowData(ids[i - DeleteCount]);
					DeleteCount = DeleteCount + 1;
				} else {
					break;
				}
				
			}
			//alert(records)
			var records = $('#'+id).getGridParam("records");
			if (records == 0) {
				//$('#cb_'+id+'Order_DataGrid').prop('checked', false);
				Add_Order_row(id);
			}
			if ((arcim!="")&&(PGIId!="")) {
				Add_ChgReason(id,"DEL",arcim,"Y");	//code
			}
		}
	});
}

function ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks) {
    switch (OrderPriorRemarks) {
        case "PRN":
            OrderPriorRowid = GlobalObj.PRNOrderPriorRowid;
            break;
        case "ONE":
            OrderPriorRowid = GlobalObj.OneOrderPriorRowid;
            break;
        case "OM":
            /*if (OrderPriorRowid==GlobalObj.ShortOrderPriorRowid) {
                OrderPriorRowid=GlobalObj.OMOrderPriorRowid;
            }else{
                OrderPriorRowid=GlobalObj.OMSOrderPriorRowid;
            }*/
            if (OrderPriorRowid != GlobalObj.LongOrderPriorRowid) {
                OrderPriorRowid = GlobalObj.OMOrderPriorRowid;
            } else {
                OrderPriorRowid = GlobalObj.OMSOrderPriorRowid;
            }
            break;
        case "ZT":
            if (OrderPriorRowid != GlobalObj.LongOrderPriorRowid) {
                OrderPriorRowid = GlobalObj.OMLSZTOrderPriorRowid;
            } else {
                OrderPriorRowid = GlobalObj.OMCQZTOrderPriorRowid;
            }
            break;
        case "OUT":
            OrderPriorRowid = GlobalObj.OutOrderPriorRowid;
            break;
        default:
    }
    return OrderPriorRowid;
}

function GetDefaultData(id,rowid,PLObject) {
	//alert(PLObject.o_MObj.ShortOrderPriorRowid)
    var DfaultData = {
        OrderPriorStr: "",
        OrderPriorRowid: PLObject.o_MObj.ShortOrderPriorRowid,
        OrderPrior: PLObject.o_MObj.ShortOrderPrior,
        OrderStartDate: "",
        OrderDoc: "",
        OrderUserAdd: "",
        OrderUserDep: "",
        OrderDate: "",
        OrderBillType: "",
        OrderBillTypeRowid: "",
        OrderDIACat: "",
        OrderDIACatRowId: "",
        OrderSpeedFlowRate: "",
        OrderFlowRateUnit: "",
        OrderFlowRateUnitRowId: "",
        OrderOperationCode:"",
        OrderOperation:"",
        OrderLogDep:""
    };

    return DfaultData;
}

function GetCellData(id, rowid, colname) {
    var CellData = "";
    if ($.isNumeric(rowid) == true) {
		var idVal = rowid + "_" + colname;
		var obj = document.getElementById(rowid + "_" + colname);
		//var obj = $("#"+ id + " [id=" + idVal + "]")[0];
        if (obj) {
            if (obj.type == "select-one") {
                //CellData = $("#" + rowid + "_" + colname + " option:selected").text();
				var CellData = $(obj).find("option:selected").text();
            } else if (obj.type == "checkbox") {
                if ($(obj).prop("checked")) {
                    CellData = "Y";
                } else {
                    CellData = "N";
                }
            } else {
                CellData = $(obj).val();
            }
        } else {
            CellData = $("#"+id).getCell(rowid, colname);
        }
    } else {
		return ""
       
    }
    return CellData;
}

function SetCellData(id, rowid, colname, data) {
    if ($.isNumeric(rowid) == true) {
        //var obj = document.getElementById(rowid + "_" + colname);
		var idVal = rowid + "_" + colname;
		var obj = $("#"+ id + " [id=" + idVal + "]")[0];
        if (obj) {
            if (obj.type == "checkbox") {
                var olddata = $(obj).prop("checked");
                $(obj).prop("checked", data);
            } else {
                var olddata = $(obj).val();
                $(obj).val(data);
            }
        } else {
            $("#"+id).setCell(rowid, colname, data, "", "", true);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            $("#" + colname).val(data);
        }
    }
}

function SetColumnList(id, rowid, ColumnName, str) {
	var ColumnName_F = ColumnName;
	if (ColumnName.indexOf("_")>=0) {
		ColumnName_F = ColumnName.split("_")[0];
	}
	
    var idVal = "";
    if ($.isNumeric(rowid) == true) {
        var idVal = rowid + "_" + ColumnName_F;
    } else {
        var idVal = ColumnName_F;
    }
    if (typeof str == "undefined") { return }
	
	var obj = $("#"+ id + " [id=" + idVal + "]")[0];
    if (obj) {
        ClearAllList(obj);
        if (ColumnName == "OrderRecDep") {
            /*
            var DefaultRecLocRowid = "";
            var DefaultRecLocDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
                    var DefaultRecLocRowid = ArrData1[0];
                    var DefaultRecLocDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(id, rowid, "OrderRecDep", DefaultRecLocRowid);
            SetCellData(id ,rowid, "OrderRecDepRowid", DefaultRecLocRowid);
            SetCellData(id ,rowid, "CurrentRecLocStr", str);
            */
            var DefaultRecLocRowid = "";
            var DefaultRecLocDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
                    var DefaultRecLocRowid = ArrData1[0];
                    var DefaultRecLocDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            if (DefaultRecLocRowid=="") {
	            var ArrData1=ArrData[0].split(String.fromCharCode(1));
	            DefaultRecLocRowid=ArrData1[0];
	            DefaultRecLocDesc=ArrData1[1];
	        }
	        
            SetCellData(id,rowid, "OrderRecDep", DefaultRecLocRowid);
            SetCellData(id,rowid, "OrderRecDepRowid", DefaultRecLocRowid);
            SetCellData(id,rowid, "CurrentRecLocStr", str);
            
        }
		if (ColumnName == "OrderRecDep_Edit") {
			var OrderRecDepRowid = GetCellData(id,rowid,"OrderRecDepRowid");
            var DefaultRecLocRowid = "";
            var DefaultRecLocDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
                    var DefaultRecLocRowid = ArrData1[0];
                    var DefaultRecLocDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
			SetCellData(id ,rowid, "OrderRecDep", OrderRecDepRowid);
			SetCellData(id ,rowid, "OrderRecDepRowid", OrderRecDepRowid);
        }
		
        if (ColumnName == "OrderPackUOM") {
            var DefaultOrderPackUOM = "";
            var DefaultOrderPackUOMDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                if (ArrData1[2] == "Y") {
                    var DefaultOrderPackUOM = ArrData1[0];
                    var DefaultOrderPackUOMDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            if (DefaultOrderPackUOM != "") {
                SetCellData(id, rowid, "OrderPackUOMRowid", DefaultOrderPackUOM);
                SetCellData(id, rowid, "OrderPackUOM", DefaultOrderPackUOM);
            }
        }
		 if (ColumnName == "OrderPackUOM_Edit") {
			var OrderPackUOMRowid = GetCellData(id,rowid,"OrderPackUOMRowid");
			var DefaultOrderPackUOM = "";
			var DefaultOrderPackUOMDesc = "";
			var ArrData = str.split(String.fromCharCode(2));
			for (var i = 0; i < ArrData.length; i++) {
				var ArrData1 = ArrData[i].split(String.fromCharCode(1));
				if (ArrData1[2] == "Y") {
					var DefaultOrderPackUOM = ArrData1[0];
					var DefaultOrderPackUOMDesc = ArrData1[1];
				}
				obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
			}
			SetCellData(id, rowid, "OrderPackUOMRowid", OrderPackUOMRowid);
            SetCellData(id, rowid, "OrderPackUOM", OrderPackUOMRowid);
        }
        if (ColumnName == "OrderDoseUOM") {
            var DefaultDoseQty = "";
            var DefaultDoseQtyUOM = ""
            var DefaultDoseUOMRowid = "";
            if (str != "") {
                var ArrData = str.split(String.fromCharCode(2));
                for (var i = 0; i < ArrData.length; i++) {
                    var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                    obj.options[obj.length] = new Option(ArrData1[1], ArrData1[2]);
                    if (i == 0) {
                        var DefaultDoseQty = ArrData1[0];
                        var DefaultDoseQtyUOM = ArrData1[1];
                        var DefaultDoseUOMRowid  = ArrData1[2];
                    }
                }
            }
            SetCellData(id, rowid, "OrderDoseQty", DefaultDoseQty);
            SetCellData(id ,rowid, "OrderDoseUOM", DefaultDoseUOMRowid);
            SetCellData(id ,rowid, "OrderDoseUOMRowid", DefaultDoseUOMRowid);

        }
		if (ColumnName == "OrderDoseUOM_Edit") {
			var OrderDoseUOMRowid = GetCellData(id,rowid,"OrderDoseUOMRowid");
            var DefaultDoseQty = "";
            var DefaultDoseQtyUOM = ""
            var DefaultDoseUOMRowid = "";
            if (str != "") {
                var ArrData = str.split(String.fromCharCode(2));
                for (var i = 0; i < ArrData.length; i++) {
                    var ArrData1 = ArrData[i].split(String.fromCharCode(1));
                    obj.options[obj.length] = new Option(ArrData1[1], ArrData1[2]);
                    if (i == 0) {
                        var DefaultDoseQty = ArrData1[0];
                        var DefaultDoseQtyUOM = ArrData1[1];
                        var DefaultDoseUOMRowid  = ArrData1[2];
                    }
                }
				
            }
			SetCellData(id ,rowid, "OrderDoseUOM", OrderDoseUOMRowid);
			SetCellData(id ,rowid, "OrderDoseUOMRowid", OrderDoseUOMRowid);

        }
        if (ColumnName == "OrderLabSpec") {
            var DefaultSpecRowid = "";
            var DefaultSpecDesc = "";
            var ArrData = str.split(String.fromCharCode(2));
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(String.fromCharCode(3));
                if ((ArrData1[4] == "Y") || (ArrData.length == 1)) {
                    var DefaultSpecRowid = ArrData1[0];
                    var DefaultSpecDesc = ArrData1[1];
                }
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
            SetCellData(rowid, "OrderLabSpec", DefaultSpecRowid);
            SetCellData(rowid, "OrderLabSpecRowid", DefaultSpecRowid);
            SetCellData(rowid, "OrderLabSpecStr", str);
        }
        
        //医嘱类型
        if (ColumnName == "OrderPrior") {
            var ArrData = str.split(";");
            for (var i = 0; i < ArrData.length; i++) {
                var ArrData1 = ArrData[i].split(":");
                obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
            }
        }
		
		
		
        
        
    }
}

//获取所有数据 如果行处于编辑状态 这样得到的行数据包含标签
function GetGirdData(id) {
    var DataArry = new Array();
    var rowids = $('#'+id).getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
       /*  var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		var OrderARCOSRowid = GetCellData(rowids[i], "OrderARCOSRowid");
        if (OrderItemRowid != "" || ((OrderARCIMRowid == "")&&(OrderARCOSRowid == ""))) { continue;  }*/
        //保存行
        EndEditRow(id, rowids[i]);
        var curRowData = $("#"+id).getRowData(rowids[i]);
        DataArry[DataArry.length] = curRowData;
    }
	
    return DataArry;
}

//保存 停止编辑 99999
function Save_Order_row() {
    var rowids = $('#Order_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
        //
        if (GetEditStatus(rowids[i]) == true) {
            EndEditRow(rowids[i]);
        }
    }
}
//判断行是否在编辑状态
function GetEditStatus(id,rowid) {
    var colname = "OrderName" 
	var idVal = rowid + "_" + colname;
	var obj = $("#"+ id + " [id=" + idVal + "]")[0];
		
    if (obj) {
        return true;
    } else {
        return false;
    }
}

//获取事件的行号
function GetEventRow(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
    if (obj && obj.id.indexOf("_") > 0) {
        rowid = obj.id.split("_")[0];
    }
    return rowid
}

function SetSeqNohandler(id) {
    //获取选择行ID: GetSelRowId()
    //获取所有行ID  包含已审核  根据CheckIsItem(rowid)判断
    //此处SelTableRowAry是选中的数组,如果在后面的程序中改变选中状态也会影响数组数据,引用地址传递,所以使用重新赋值
    var SelTableRowAry = GetSelRowId(id);
    var Selrowids = SelTableRowAry.join(',').split(',');
    if (Selrowids.length <= 1) {
        return true;
    }
    var MainID = Selrowids[0];
    var tempGroupType=GetCellData(id, MainID, "GroupType"),errMsg=""
    var OrderInstr=GetCellData(id, MainID, "OrderInstr")
    var OrderInstrRowid=GetCellData(id, MainID, "OrderInstrRowid")
    var OrderFreq=GetCellData(id, MainID, "OrderFreq")
    var OrderFreqRowid=GetCellData(id, MainID, "OrderFreqRowid")
    var OrderDur=GetCellData(id, MainID, "OrderDur")
    var OrderDurRowid=GetCellData(id, MainID, "OrderDurRowid")
    var ChemoDays=GetCellData(id, MainID, "ChemoDays")
    var SyncObj = {
	    "OrderInstr":OrderInstr,
	    "OrderInstrRowid":OrderInstrRowid,
	    "OrderFreq":OrderFreq,
	    "OrderFreqRowid":OrderFreqRowid,
	    "OrderDur":OrderDur,
	    "OrderDurRowid":OrderDurRowid,
	    "ChemoDays":ChemoDays
	}
    for (var i = 1; i < Selrowids.length; i++) {
        if (Selrowids[i] == "") continue;
        var SubID = Selrowids[i];
        var GroupType = GetCellData(id, SubID, "GroupType")
        //console.log(tempGroupType+": "+GroupType+": "+SubID)
        if (tempGroupType=="") tempGroupType = GroupType
        else {
	    	if (tempGroupType!=GroupType) {
		    	errMsg = "不同组类型不允许关联！"
		    	
		    	break;
		    }    
	    }
	    
		
    }
    
    if (errMsg!="") {
	    $.messager.alert("提示",errMsg,"warning");
	    return false;
	   }
	   
    PageLogicObj.IsStartOrdSeqLink=MainID;
    SetCellData(id,MainID, "OrderMasterSeqNo", MainID);
    $("#"+id).setSelection(MainID, false);
    
    //设置关联
    var change=false;
    
    for (var i = 1; i < Selrowids.length; i++) {
        if (Selrowids[i] == "") continue;
		//设置关联
        var SubID = Selrowids[i];
        var MainVal = MainID+"."+i;
        $("#"+id).setSelection(SubID, false);
        //var GroupType = GetCellData(id, SubID, "GroupType")
        
	    
        var change = SetMasterSeqNo(id,MainID, SubID, "S",MainVal,SyncObj);
		
    }
    return change;
}

//拆关联(提供给按钮的控制)
function ClearSeqNohandler(id) {
    var Selrowids = GetSelRowId(id);
 	Selrowids = Selrowids.join(",").split(",");
    if (Selrowids.length < 1) {
        return true;
    }
    for (var i = 0; i < Selrowids.length; i++) {
        var OrderMasterSeqNo = GetCellData(id,Selrowids[i], "OrderMasterSeqNo");
        $("#"+id).setSelection(Selrowids[i], false);
        SetMasterSeqNo(id,Selrowids[i], "", "C");
    }
    return true;
}

//设置关联 传入 主医嘱ID  子医嘱ID type："S"(关联) "C"(拆关联) 2014-04-18
function SetMasterSeqNo(id,MainID, SubID, type,MainVal,SyncObj) {
    if (MainID != "") {
        if (($.isNumeric(MainID) == false)) { return false; }
        //判断主医嘱存不存在     
    }
    if (SubID != "") {
        if (($.isNumeric(SubID) == false)) { return false; }
    }
    if (type == "S") {
	    //id, rowid, colname, data
        SetCellData(id,SubID, "OrderMasterSeqNo", MainVal);
        SetCellData(id,SubID, "OrderInstr", SyncObj.OrderInstr);
        SetCellData(id,SubID, "OrderInstrRowid", SyncObj.OrderInstrRowid);
        SetCellData(id,SubID, "OrderFreq", SyncObj.OrderFreq);
        SetCellData(id,SubID, "OrderFreqRowid", SyncObj.OrderFreqRowid);
        SetCellData(id,SubID, "OrderDur", SyncObj.OrderDur);
        SetCellData(id,SubID, "OrderDurRowid", SyncObj.OrderDurRowid);
        SetCellData(id,SubID, "ChemoDays", SyncObj.ChemoDays);

    } else if (type == "C") {
        SetCellData(id,MainID, "OrderMasterSeqNo", "");
    }
    return true;
}


//设置行数据 
function SetRowData(id,rowid, dataObj, cssprop) {
    if ($.isNumeric(rowid) == false) { return; }
    if (GetEditStatus(rowid) == true) {      
        EndEditRow(id,rowid);
        var ret = $("#"+id).setRowData(rowid, dataObj, cssprop);
    } else {
        $("#"+id).setRowData(rowid, dataObj, cssprop);
    }
}

//获取选择行ID 返回数组
function GetSelRowId(id) {
    var rowids = $('#'+id).getGridParam("selarrrow");
    return rowids;
}

//根据行号获取所有关联医嘱 
function GetSeqNolist(id,rowid) {
	var rowids = [];
	var CurrentMasterSeqNo = GetCellData(id,rowid,"OrderMasterSeqNo");
	if (CurrentMasterSeqNo=="") {
		return rowids;
	}
	if (CurrentMasterSeqNo.indexOf(".")>=0) {
		CurrentMasterSeqNo = CurrentMasterSeqNo.split(".")[0];
	}
    var rowids = new Array();
    var AllRowids = $('#'+id).getDataIDs();
    for (var i = 0; i < AllRowids.length; i++) {
        var OrderMasterSeqNo = GetCellData(id, AllRowids[i],"OrderMasterSeqNo");
        if (OrderMasterSeqNo=="") continue;
        if (OrderMasterSeqNo.indexOf(".")>=0) OrderMasterSeqNo=OrderMasterSeqNo.split(".")[0];
        if (OrderMasterSeqNo==CurrentMasterSeqNo) {
	        rowids.push(AllRowids[i])
	    }
    }
    return rowids;
}

//计算理想体重
function CalcIBW(Height,Weight,Sex) {
	if ((Height=="")||(Weight=="")) {
		return ""
	}
	var IBW = 0;
	if (Height>=152) {
		if (Sex==1) {
			IBW = 50 + 2.3*((Height/2.54)-60)
		} else {
			IBW = 45.5 + 2.3*((Height/2.54)-60)	
		}
	} else {
		if (Sex==1) {
			IBW = 50 - (60-(Height/2.54))
		} else {
			IBW = 45 - (60-(Height/2.54))
		}
	}
	if (Weight>IBW) {
		IBW = IBW + 0.4 * (Weight - IBW)
	}
	
	return IBW.toFixed(2); 
}

//计算BSA
function CalcBSA(Height,Weight) {
	if ((Height=="")||(Weight=="")) {
		return "";
	}
	return (Math.sqrt((Height*Weight)/3600)).toFixed(2);  
}

//计算GFR
function CalcGFR(Age,Weight,SC,Sex) {
	if (SC=="") {
		return "";
	}
	Percent = 1;
	if (Sex == 1) {
		Percent = 1
	} else {
		Percent = 0.85
	}
  
	return (((140-Age)*Weight*88.4)/(72*SC)*Percent).toFixed(2);  
	
  
}

//计算BSA
function CalcBSADose(BSA, BSAUnit, Percent) {
   Percent = Percent||1;
  
   return (BSA*BSAUnit*Percent).toFixed(2);  
}

//计算GFR
function CalcGFRDose(AUC, GFR, Percent) {
   AUC = ParseNumber(AUC)
   GFR = ParseNumber(GFR)
   var Percent = Percent||1;
   return (AUC*(GFR+25)*Percent).toFixed(2);  
  
}

//计算AUC
function CalcAUC(Dose, GFR, Percent) {
  
   var Percent = Percent||1;
   return ((Dose/(GFR+25))).toFixed(2); 
  
}

//反推
function BackBSADose (BSADose, BSA, Percent) {
	Percent = Percent||1;
	
	return (BSADose/BSA/Percent).toFixed(2);
}

function BackGFRDose (GFRDose, GFR, Percent) {
	Percent = Percent||1;
	
	return (GFRDose/GFR/Percent).toFixed(2);
}

function debug(printVal,printDesc,mode) {
	printDesc=printDesc||"";
	mode=mode||"";
	if (mode=="") mode=0
	if (mode==1) {
		if (printDesc!="") {
			var datatype= typeof printVal
			if (datatype=="object") {
				console.log("%c "+printDesc+": ",'color:red;font-size:16px')
				console.log(printVal)
				//console.table(printVal)
			} else {
				console.log(printDesc + ": " + printVal)
			}
			
		} else {
			console.log(printVal)
		}
	} else {
		//todo...	
	}
}

function InArray (Ary,Val) {
	var mRtn=0;
	for(j = 0;j < Ary.length; j++) {
    	if (Val == Ary[j]) {
	    	mRtn = 1;
	    	break;
	    }
	}
	
	return mRtn
}

function GetSessionStr() {
    var Str = "";
    Str = session['LOGON.USERID'];
    Str += "^" + session['LOGON.GROUPID'];
    Str += "^" + session['LOGON.CTLOCID'];
    Str += "^" + session['LOGON.HOSPID'];
    Str += "^" + (session['LOGON.WARDID']||"");
    Str += "^" + session['LOGON.LANGID'];
    return Str;
}

function mPiece(s1, sep, n) {
    //Getting wanted piece, passing (string,separator,piece number)
    //First piece starts from 0
    //Split the array with the passed delimeter
    var delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
	return "";
}

function ClearAllSeclection(id) {
    var rowids = $('#'+id).getDataIDs();
    for (var i=1; i<=rowids.length; i++) {
	   var rowid = rowids[i];
	   alert(rowid+ "： " + $("#jqg_"+id+"_" + rowid).prop("checked") )
	   if ($("#jqg_"+id+"_" + rowid).prop("checked") == true) {
	        alert(rowid)
	         $("#"+id).setSelection(rowid, false);
	    }
	    
	   //$("#"+id).setSelection(rowid, false);
	   //EndEditRow(id,i)
	}
	
}


function isInteger(str) {
	if (str=="") return false;
	return /^\d+$/.test(str);
}

function isNumber(str) {
	return !isNaN(str)
}

function GetCurr_time() {
    //取当前日期和时间(服务器)
    var CurrDateTime = cspRunServerMethod(GlobalObj.GetCurrentDateTimeMethod, PageLogicObj.defaultDataCache, "1");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
    return CurrDateTime;
}

//
function ParseNumber(str) {
	if (str=="") {
		return ""
	}
	var bol = isNumber(str)
	if (!bol) {
		return ""
	}
	
	return parseFloat(str)
	
}

function searchbox(_id, _opts) {
    $HUI.searchbox('#' + _id, _opts);
    if (_opts.placeholder) {
        $('#' + _id)
            .searchbox('textbox')
            .attr('placeholder', _opts.placeholder);
    }
}
/// cell->edittype:'custom'时，需要实现其自定义对象的创建，这里只创建一个input，具体的组件实现由InitRowLookUp去实现
function CustomElement (value, options) {
    var el = document.createElement("input");
    el.type="text";
    el.value = value;
    el.style="width:inherit"
    return el;
}

/// cell->edittype:'custom'时，需要实现其自定义的对象值操作方法
function CustomValue(elem, operation, value) {
    console.log(elem.attr('id')+"."+operation)
    if ($(elem).hasClass("combobox-f")){
        if(operation === 'get') {
            return $(elem).combobox('getText');
        } else if(operation === 'set') {
            $(elem).combobox('setText',value)
        }
    }else{
        if(operation === 'get') {
            return $(elem).val();
        } else if(operation === 'set') {
            $('input',elem).val(value);
        }
    }
}
    