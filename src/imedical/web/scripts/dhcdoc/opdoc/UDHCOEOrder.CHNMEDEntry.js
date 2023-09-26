var PageLogicObj = {
	version:"V8.0",
    m_AddItemToListMethod: "LookUp",
    IsARCOSFormula:0, //是否是协定处方
    m_ARCOSRowId:"",
    m_selTabIndex:"",
    //defaultDataCache:GlobalObj.defaultDataCache,
    EntrySelRowFlag:0,
    OEORIRealTimeQuery:1,
    LookupPanelIsShow:0,
    PractiacRowStr:"",
    PrescDurFactor:1,
    PreCMPrescTypeCode:"", //上一次选择的处方类型
    CurCMPrescTypeCode:"" //当前处方类型
}
var PreCMPrescTypeDataObj={};//上一次选择的处方类型对应选择的用药频次、使用方式、用药副数、煎药方式等数据
var PrescTypeDetailDelim="!"
var FocusRowIndex=0;
var FocusGroupIndex=0;
var UpdateFlag=false;
var dw=$(window).width()-166,dh=$(window).height()-80;
function Init(){
	PageLogicObj.defaultDataCache=GlobalObj.defaultDataCache;
	InitCombox();
	InitCMOrdEntryDataGrid();
	InitEvent();
	InitPrescNotes();
	InitLayOut();
}
window.onbeforeunload=DocumentUnloadHandler;
$(window).load(function() {
	if (websys_isIE==true) {
	     var script = document.createElement('script');
	     script.type = 'text/javaScript';
	     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	     document.getElementsByTagName('head')[0].appendChild(script);
	}
	//处方类型改变时需要修改其它combobox的默认值,故初始化时需在所有元素加载完之后进行
	InitCMPrescType(GlobalObj.CMPrescTypeStrStr);
	setTimeout(function(){
		//从病历浏览复制医嘱
		if ('undefined' !== typeof CopyOeoriDataArr){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
	},500)
    if ( +GlobalObj.CMDrugAndQtySplitConfig == 0) {
	    $HUI.checkbox("#DrugAndQtyYQ").setValue(true);
	}else{
		$HUI.checkbox("#DrugAndQtySplit").setValue(true);
	}
    $('#PrescriptTypeBillList').tabs({
	  onSelect: function(title,index){
		  PrescTypeBillChange(index);
	  }
   });
   if ($("#OrderTemplate").length==0){ //布局2
		if (GlobalObj.PAAdmType=="I"){
			ResizeGridHeight();
		}else{
			var ActiveHeight=$(window).height()-300
			$('#CMOrdEntry_DataGrid').setGridHeight(parseInt(ActiveHeight));
		}
		if (GlobalObj.PAAdmType!="O"){
		   OrderTemplateClick();
	   }
	}else{
		jQuery('#Template_tabs').tabs({ onSelect: function(title, index) { RedrawFavourites(index); } });
		//个人模版
	    $('#Personal_Template_Btn').click(OEPrefClickHandler);
	    //科室模版
	    $('#Departments_Template_Btn').click(OEPrefClickHandler);
	    
        var iframeName=window.name
		if (iframeName==""){
			iframeName=window.parent.frames("oeordCNFrame").name
		}
		var XCONTEXT=session["CONTEXT"]
		if(XCONTEXT==""){
			XCONTEXT="W50007"
		}
		var escapedCTLOC="";//oeorder.entry.redrawprefs.new.csp
		lnkFav="oeorder.entry.redrawprefs.new.csp?EpisodeID="+GlobalObj.EpisodeID+"&CTLOC="+escapedCTLOC+"&XCONTEXT="+XCONTEXT+"&OEWIN="+iframeName+"&TABIDX=0";
		websys_createWindow(lnkFav+'&PREFTAB=1','TRAK_hidden');
	}
	if (GlobalObj.PracticeShowFlag>0){
    	ShowPracticeOrder();
    }
});
function PrescTypeBillChange(index){
	  var tab = $('#PrescriptTypeBillList').tabs('getSelected');
	  var index = $('#PrescriptTypeBillList').tabs('getTabIndex',tab);
	  var PrescriptTypeTemp=GlobalObj.PrescriptTypes.split("||")[index];
	  var presctypebilltypeid=PrescriptTypeTemp.split(PrescTypeDetailDelim)[4];
	  if (presctypebilltypeid!=GlobalObj.OrderBillTypeRowid){
		  var HaveEntryItem=false;
		  var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
		  for (var i=1; i<=rows; i++){
				if (HaveEntryItem==true) break;
				for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
					var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
					if ((OrderARCIMRowid!="")&&(HaveEntryItem==false)){
						HaveEntryItem=true;
					}
				}
		   }
		   if (HaveEntryItem){
				var DelCheck=dhcsys_confirm((t['NO_SAVE']),false);
				if (DelCheck==false) {
					$('#PrescriptTypeBillList').tabs('unselect',index);
					$('#PrescriptTypeBillList').tabs('select',PageLogicObj.m_selTabIndex);
					return false;
				}
				ClearClickHandler();
				$("#ScreenBillSum,#TotailBillSum,#ScreenQtySum").val(0);
				$("#PrescList").combobox('select','');
				PageLogicObj.IsARCOSFormula=0;
			}
			GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
			PageLogicObj.m_selTabIndex=index;
	  }
}
function InitCMPrescType(CMPrescTypeStrStr){
	var CMPrescTypeKWArr=new Array();
	var selectKWId="";
	var ArrData = CMPrescTypeStrStr.split(String.fromCharCode(2));
	for (var i = 0; i < ArrData.length; i++) {
		var ArrData1 = ArrData[i].split(String.fromCharCode(1))
		var value=ArrData1[0];
		var desc=ArrData1[1];
		var CMPrescTypeCode=mPiece(value,"#",0);
		var IPDefaultCMPrescType=mPiece(value,"#",13);
		var OPDefaultCMPrescType=mPiece(value,"#",14);
		if (i==0) {
			selectKWId=CMPrescTypeCode;
		}
		if ((GlobalObj.PAAdmType=="I")&&(IPDefaultCMPrescType=="1")){
			selectKWId=CMPrescTypeCode;
		}
		if ((GlobalObj.PAAdmType!="I")&&(OPDefaultCMPrescType=="1")){
			selectKWId=CMPrescTypeCode;
		}
		CMPrescTypeKWArr.push({"text":desc, "id":CMPrescTypeCode, "value":value});
	}
   $("#CMPrescTypeKW").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:CMPrescTypeKWArr,
	    onClick:function(v){
		    PageLogicObj.PreCMPrescTypeCode=PageLogicObj.CurCMPrescTypeCode;
		    //记录上一次处方相关信息,用以切换处方类型失败时还原默认
		    GetPreCMPrescTypeDataObj();
		    PageLogicObj.CurCMPrescTypeCode=v.id;
		    CMPrescTypeChangeHandler();
		}
	});
	$("#CMPrescTypeKW").keywords('select',selectKWId);
	PageLogicObj.CurCMPrescTypeCode=selectKWId;
	setTimeout(function(){
	    if (GlobalObj.StoreUnSaveData=="1"){
			var FieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
			var UserUnSaveData = $.cm({
				ClassName:"web.DHCDocOrderEntry",
				MethodName:"GetUserCMUnSaveData",
				dataType:"text",
				Name:FieldName
			},false);
			if (UserUnSaveData!=""){AddUnsaveDataToList(UserUnSaveData);}
		}
	},500)
}
function InitEvent(){
	$HUI.checkbox("#DrugAndQtyYQ,#DrugAndQtySplit",{
        onCheckChange:function(e,value){
	       DrugAndQtyEntryModeChange(e,value);
        }
    });
    $HUI.checkbox("#PrescCookDecoction",{
        onCheckChange:function(e,value){
	       PrescCookDecoctionClick(e,value);
        }
    });
    $HUI.checkbox("#CMOrderOpenForAllHosp",{
        onCheckChange:function(e,value){
	       CMOrderOpenForAllHospClick(e,value);
        }
    });
    //双击列头事件
    jQuery('#CMOrdEntry_DataGrid').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick",headerDblClick);
    $("#Add_Order_btn").popover({placement:'top-right',content:'增加',trigger:'hover'});
	$('#Add_Order_btn').click(function (){
		if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { return false;}
		Add_CMOrdEntry_row();
	});
	$('#Delete_Order_btn').click(Delete_CMOrdEntry_row);
	$('#New').click(NewClickHandler);
	$('#Clear').click(ClearClickHandler);
	$('#SaveToArcos').click(SaveToArcos_Click);
	$('#Update').click(UpdateClickHandler);
	$('#MoveUp_btn').click(function(){OrdVerticalMove("MoveUp_btn");});
	$('#MoveDown_btn').click(function(){OrdVerticalMove("MoveDown_btn");});
	$('#MoveLeft_btn').click(function(){OrdHorizontalMove("MoveLeft_btn");});
	$('#MoveRight_Btn').click(function(){OrdHorizontalMove("MoveRight_Btn");});
	$('#Order_copy_btn').click(OrdercopyClick);
	$('#Add_TemplOrder_btn').click(MultiTemplOrdEntry);
	$("#Add_TemplOrder_btn").popover({placement:'top-right',content:'添加模板医嘱',trigger:'hover'});
	//$('#OrderTemplate_Btn').click(OrderTemplateClick);
	$('#CardBill').click(CardBillClick);
	$('#StopPrescBtn').click(StopPrescClickHandler);
	//添加临床路径医嘱
	$('#Add_CPWOrd').click(AddCPWOrdClickHandler);
	$('#ordEntryType_change_Btn').click(function(){
		DocumentUnloadHandler();
		window.parent.argobj.CONTEXT="WNewOrderEntry";
		window.parent.LoadOrdTemplTree(window.parent.GetOrdTempTypeTabSel(),0);
		window.parent.LoadOrdEntryiFrame("WNewOrderEntry");
	    
	});
	$("#OrdTemplMan").click(OrdTemplManClick);
	$("#YDTS").click(YDTS_Click);
	//实习生医嘱审核列表
    $('#PracticeDocOrder').click(ShowPracticeOrder);
	
	InitPrescriptTypeBillList();
	InitBtnDisplay();
	//OrderTemplateClick
	document.onkeydown = Doc_OnKeyDown;
	
	 $('body').click(function(e){
		 var activeId=document.activeElement.id;
        if ((activeId=="")&&(activeId.indexOf("OrderName")<0)&&(activeId.indexOf("OrderDoseQty")<0)&&(activeId.indexOf("OrderPhSpecInstr")<0)){
	        FocusRowIndex=0;
			FocusGroupIndex=0;
	    }
    })
}
function Doc_OnKeyDown(e){
	if (GlobalObj.warning != "") {
		$(".messager-button a").click(); //自动关闭上一个alert弹框
        $.messager.alert("警告",GlobalObj.warning);
        return false;
    }
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        if (event.keyCode == 83){ //保存医嘱
            UpdateClickHandler();
        }
        return false;
    }
}
function InitCombox(){
	//用药副数
	$HUI.combobox('#PrescDuration',{      
    	valueField:'PHCDURowid',   
    	textField:'PHCDUDesc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescDurationJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpDuration&Desc=&ResultSetType=array",
    	onSelect:function(record){
	    	PageLogicObj.PrescDurFactor=record.PHCDUFactor;
			PrescDurationLookupSelect(record);
		}
	});
	//使用方式
	$HUI.combobox('#PrescInstruction',{      
    	valueField:'HIDDEN',   
    	textField:'Desc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescInstructionJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpInstr&Desc=&ResultSetType=array",
    	onSelect:function(){
	    	PrescInstrLookUpSelect();
		}
	});
	//用药频次
	$HUI.combobox('#PrescFrequence',{      
    	valueField:'PHCFRRowid',   
    	textField:'PHCFRDesc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescFrequenceJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpFrequence&Desc=&ResultSetType=array",
	});
	//医嘱类型
	$HUI.combobox('#PrescPrior',{      
    	valueField:'HIDDEN',   
    	textField:'Desc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescPriorJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpOrderPrior&EpisodeType="+GlobalObj.PAAdmType+"&ResultSetType=array",
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#PrescPrior");
			var Data=sbox.getData();
			for (var i=0;i<Data.length;i++){
				if (GlobalObj.PAAdmType=="I"){
					var cbox = $HUI.combobox("#AddLongOrderList", {
						valueField: 'value',
						textField: 'desc', 
						data: JSON.parse(GlobalObj.AddLongOrderJson),
				   });
					if (Data[i].HIDDEN==GlobalObj.OneOrderPriorRowid){
						sbox.select(Data[i].HIDDEN);
						break;
					}
				}else{
					if (Data[i].HIDDEN==GlobalObj.ShortOrderPriorRowid){
						sbox.select(Data[i].HIDDEN);
						break;
					}
				}
			}
		},
		onSelect:function(record){
			//医嘱类型非取药医嘱,不能选择长期医嘱
			if (record.HIDDEN!=GlobalObj.OneOrderPriorRowid){
				$("#AddLongOrderList").combobox('select','').combobox("disable");
			}else{
				if (GlobalObj.CurrentDischargeStatus!="B") {
					$("#AddLongOrderList").combobox("enable");
				}
			}
		}
	});
	//一次用量
	var cbox = $HUI.combobox("#PrescOrderQty", {
		valueField: 'Code',
		textField: 'Desc'
    });
    //接收科室
    var cbox = $HUI.combobox("#RecLoc", {
		valueField: 'id',
		textField: 'desc'
    });
    //煎药方式是
	$HUI.combobox('#CookModelist',{      
    	valueField:'RowID',   
    	textField:'Desc',
    	data: JSON.parse(GlobalObj.CookModeJson),
    	onSelect:function(record){
			if (record) {
				var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
				var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
				var DetailsArr=CMPrescTypeDetails.split("#");    
				var CMRecLocStr=DetailsArr[6];
				var OpenHospCMRecLocStr=DetailsArr[15];
				if ($("#CMOrderOpenForAllHosp").checkbox('getValue')) {
					CMRecLocStr=OpenHospCMRecLocStr;
					if (record.OpenHospCookModeReclocStr!=""){
						CMRecLocStr=CMRecLocStr+"!"+record.OpenHospCookModeReclocStr;
					}
				}else{
					if (record.CookModeReclocStr!=""){
						 CMRecLocStr=CMRecLocStr+"!"+record.CookModeReclocStr
					}
				}
				CMRecLocStr=CMRecLocStr.replace(/[!]/g, String.fromCharCode(2))
				CMRecLocStr=CMRecLocStr.replace(/[@]/g, String.fromCharCode(1))
				SetRecLoc(CMRecLocStr);
			}
		}
	});
    var PrescListArr=new Array();
    var ArrData = GlobalObj.PrescList.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]=="") continue;
        var value=ArrData1[0]+"^"+ArrData1[2];
		PrescListArr.push({"value":value, "desc":ArrData1[1]});
    }
    var cbox=$HUI.combobox("#PrescList", {
		valueField: 'value',
		textField: 'desc',
		data:PrescListArr,
		onSelect:function(record){
			if (record!=undefined){
				PrescListChange(record.value);
			}
		},formatter: function(row){
            var opts = $(this).combobox('options');
            var Data=row[opts.valueField]
            var Flag=Data.split("^")[1];
            if(Flag=='1'){
                return row[opts.textField];
            }else if(Flag=="2"){
	            //已缴费
	        	return '<div style=\'background:#F9D44E;margin-right:5px;\'>'+row[opts.textField]+'<\/div>';    
	        }else if(Flag=="3"){
		        //非本次就诊处方
	        	return '<div style=\'background:#21BA45;margin-right:5px;\'>'+row[opts.textField]+'<\/div>';    
	        }else if(Flag=='4'){
		        //本次已停止
		    	return '<div style=\'background:#FF6356;margin-right:5px;\'>'+row[opts.textField]+'<\/div>'; 
			}
		}
    });
    if (GlobalObj.PAAdmType=="I"){
	   if (GlobalObj.CurrentDischargeStatus=="B") {
		   $("#AddLongOrderList").combobox('select','').combobox("disable");
	   }
   }
}
function InitCMOrdEntryDataGrid(){
	$("#CMOrdEntry_DataGrid").jqGrid({
		width:dw+144,
        height:dw-818,
        url:'opdoc.request.query.grid.csp',
		datatype: "json",
		//editurl:'oeorder.oplistcustom.new.request.csp?action=test',
		shrinkToFit: false,
		autoScroll: false,
		mtype:'POST',
		emptyrecords:'没有数据',
		viewrecords:true,
		loadtext:'数据加载中...',
		multiselect:false,//多选
		multiboxonly:false,
		rowNum:10, //每页显示多少数据
		loadonce:false, //请求一次数据  本地分页
		viewrecords: true,
		rownumbers:false,
		loadui:'enable',//disable禁用ajax执行提示；enable默认，当执行ajax请求时的提示； block启用Loading提示，但是阻止其他操作
		loadError:function(xhr,status,error){
			alert("diagnosentry.js-err:"+status+","+error);
		},
		colNames:ListConfigObj.colNames,			
		colModel:ListConfigObj.colModel,
		jsonReader: {
                rows:"rows",
                records:"total",
                repeatitems: false,
                id: "Id"
        },
		prmNames:{
			page:"page",//表示请求页码的参数名称
			rows:"rows",//表示请求行数的参数名称
			sort:"sidx",//表示用于排序的列名的参数名称
			order:"sord",//表示采用的排序方式的参数名称
			search:"_search",//表示是否是搜索请求的参数名称
			nd:"nd",//表示已经发送请求的次数的参数名称
			id:"id",//表示当在编辑数据模块中发送数据时，使用的id的名称
			oper:"oper",//operation参数名称（我暂时还没用到）
			editoper:"edit",//当在edit模式中提交数据时，操作的名称request.getParameter("oper") 得到edit
			addoper:"add",//当在add模式中提交数据时，操作的名称request.getParameter("oper") 得到add
			deloper:"del",//当在delete模式中提交数据时，操作的名称request.getParameter("oper") 得到del
			subgridid:"id",//当点击以载入数据到子表时，传递的数据名称
			npage:null,
			totalrows:"totalrows" //表示需从Server得到总共多少行数据的参数名称，参见jqGrid选项中的rowTotal
		},
		ondblClickRow:function(rowid,iRow,iCol,e){
			EditRow(rowid)				
		},
		onCellSelect:function(rowid,iCol,cellcontent,e){
		},
		onClickRow:function(rowIndex, rowData){
		},
		onSelectRow:function(rowid,status){	
		},
		beforeSelectRow:function(){	
			return true;//false 禁止选择行操作
		},
		onRightClickRow:function(rowid,iRow,iCol,e){
		},
		formatCell: function (rowid, cellname, value, iRow, iCol){
		},
		gridComplete:function(){
		},
		loadComplete:function(){
			var hiscolArr=new Array();
			if(GlobalObj.ViewGroupSum<4){
				for (var i=4;i>GlobalObj.ViewGroupSum;i--){
					var OrderName="OrderName"+i+"";
					var OrderDoseQty="OrderDoseQty"+i+"";
					var OrderPhSpecInstr="OrderPhSpecInstr"+i+"";
					var OrderDoseUOM="OrderDoseUOM"+i+"";
					var OrderCoverMainIns="OrderCoverMainIns"+i+"";
					hiscolArr.push(OrderName);
					hiscolArr.push(OrderDoseQty);
					hiscolArr.push(OrderDoseUOM);
					hiscolArr.push(OrderPhSpecInstr);
					hiscolArr.push(OrderCoverMainIns);
				}
			}
			$('#CMOrdEntry_DataGrid').setGridParam().hideCol(hiscolArr).trigger("reloadGrid");
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			if(records==0){
				Add_CMOrdEntry_row();
			}
		}
    });
}
function Add_CMOrdEntry_row(){
	if ($("#Add_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
	var rowid="";
	rowid=GetNewrowid();
	if(rowid=="" || rowid==0){return;}	
	var DefaultData={};
	$('#CMOrdEntry_DataGrid').addRowData(rowid,DefaultData);
	$('#CMOrdEntry_DataGrid').editRow(rowid, false);
	InitOrderNameLookup(rowid);
	//设置焦点
	SetFocusColumn("OrderName1",rowid);
	return rowid;
}
//获取新增行ID
function GetNewrowid(){
	var rowid="";
	var rowids=$('#CMOrdEntry_DataGrid').getDataIDs();
	if(rowids.length>0){	
		var prerowid=rowids[rowids.length-1];	
		if(prerowid.indexOf(".") != -1){
			rowid=parseInt(prerowid.split(".")[0])+1;
		}else{
			rowid=parseInt(prerowid)+1;
		}		
	}else{
		rowid=1;
	}	
	return rowid;
}
var ItemzLookupGrid;
function xItem_lookuphandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var Row=GetEventRow(e);
	FocusRowIndex=Row
	FocusGroupIndex=GetFocusGroupIndex(Id);
	if (MoveFouce(key,FocusRowIndex,FocusGroupIndex,"OrderName")){
		return websys_cancel();
	}
	var OrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        PageLogicObj.IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (PageLogicObj.IsARCOSFormula=="1") return false;
    }else{
    	if ((PageLogicObj.IsARCOSFormula=="1")&& (GlobalObj.FormulaCanAppendItem=="0")) return false;
    }
    return true;
    var OrderName=$(obj).val();
    OrderName=$.trim(OrderName);
    //如果录入框清空,或焦点在输入框内是按ESC键则自动隐藏查询框
    if (ItemzLookupGrid && ((key == 27) || (OrderName == ""))) {
        ItemzLookupGrid.hide();
    }
    if(OrderName=="") return;
    //回车事件处理,光标在输入框的位置,如果是选择记录行(PageLogicObj.EntrySelRowFlag==1)则不弹出查询框
    if (key == 13) {
        if (PageLogicObj.EntrySelRowFlag==0) {
            xItem_lookuphandlerX(e,Id, OrderName);
        }else{
            PageLogicObj.EntrySelRowFlag=0;
        }
    }
    if ((type == 'dblclick')||((OrderName.length>1)&&(PageLogicObj.OEORIRealTimeQuery==1)&&(key>64 && key<91))) {
        xItem_lookuphandlerX(e,Id, OrderName);
    }
}
function xItem_lookuphandlerX(e,Id, OrderName){
	var obj=websys_getSrcElement(e);
	var CurLogonDep=session['LOGON.CTLOCID']; 
    var GroupID=session['LOGON.GROUPID'];
	var catID=""
	var subCatID="";
	var P5="0"; 
	var LogonDep=""
	var OrderPriorRowid="";
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	var P6=CMPrescTypeCode; 
	var P7="";
	var P8=GlobalObj.EpisodeID;
    var P9="",P10="";
	var OrdCatGrp="";
	if (ItemzLookupGrid&&ItemzLookupGrid.store) {
		ItemzLookupGrid.searchAndShow([OrderName,GroupID,catID,subCatID,P5,P6,P7,GlobalObj.EpisodeID,P9,P10,'',OrdCatGrp]);
	}else {
		ItemzLookupGrid = new dhcc.icare.Lookup({
			lookupListComponetId: 1872,
			lookupPage: "医嘱项选择",
			lookupName: Id,
			listClassName: 'web.DHCDocOrderEntryCM',	
			listQueryName: 'LookUpItem',
			resizeColumn:true,
			isCombo: true,
			listProperties: [function() { return $(obj).val(); },GroupID,catID,subCatID,P5,P6,P7,GlobalObj.EpisodeID,P9,P10,'',OrdCatGrp], 
			listeners:{'selectRow': OrderItemLookupSelect},
			pageSize: 20
		});
	}
	return websys_cancel();
}
function OrderItemLookupSelect(txt,callBackFun){
	//因医嘱套录入时AddCopyItemToList内也要判断诊断,故此处不在调用
	var txt=txt;
	var adata=txt.split("^");
	var iordertype=adata[3];
	if (iordertype=="ARCOS") {
		var icode=adata[1];
		ClearGroupData(FocusRowIndex,FocusGroupIndex);
		setTimeout(eval("OSItemListOpen("+icode+",'','YES','')"),100);
		callBackFun(true);
	}else{
		new Promise(function(resolve,rejected){
			//判断是否存在诊断
			var adata=txt.split("^");
			var isubcatcode=adata[5];
			CheckDiagnose(isubcatcode,resolve);
		}).then(function(rtn){
			return new Promise(function(resolve,rejected){
				if (!rtn) {
					$("#"+FocusRowIndex+"_OrderName"+FocusGroupIndex).lookup('setText',"");
			    	resolve(false);
				}else{
					PageLogicObj.EntrySelRowFlag=1;
					var adata=txt.split("^");
					var icode=adata[1];
					SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID","");
				    var Para="";
				    var OrderPhSpecInstr=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr");
				    var OrdParamsArr=new Array();
					OrdParamsArr[OrdParamsArr.length]={
						OrderARCIMRowid:icode,
						ParamS:Para,
						OrderPhSpecInstr:OrderPhSpecInstr
					};
					AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
				}
			})
		}).then(function(returnValue){
			return new Promise(function(resolve,rejected){
				if (returnValue==false) {
					ClearGroupData(FocusRowIndex,FocusGroupIndex);
				}else{
					SetScreenSum();
					var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
					if (FocusGroupIndex==GlobalObj.ViewGroupSum){
						var cbox=$HUI.checkbox("#DrugAndQtyYQ");
						if (!cbox.getValue()){
							if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
							FocusGroupIndex=1;
							FocusRowIndex=eval(FocusRowIndex)+1;
							SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
						}
					}
				}
				resolve(returnValue);
			})
		}).then(function(rtn){
			callBackFun(rtn);
		})
	}
}
function OSItemListOpen(ARCOSRowid,OSdesc,del,itemtext,OrdRowIdString) {
	if (ARCOSRowid!="") {
		new Promise(function(resolve,rejected){
			CheckDiagnose("R",resolve);
		}).then(function(rtn){
			return new Promise(function(resolve,rejected){
				if (!rtn) return;
				PageLogicObj.m_ARCOSRowId=ARCOSRowid;
			    PageLogicObj.IsARCOSFormula = $.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:ARCOSRowid
				},false);
				if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
					var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
					var GroupList=[];
					for(var i=1;i<=rows;i++){
						for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
						   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
						   if (OrderARCIMRowid!=""){
							   GroupList.push(i+"^"+j);
						   }
						}
					}
					if (GroupList.length>0){
			        	$.messager.alert("提示","协定处方不允许和普通药品混开!","info",function(){
			            	for (var i=0;i<GroupList.length;i++) {
			                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
			                }
			                FocusRowIndex=1;
			                FocusGroupIndex=1;
			                resolve();
			            });
			        }else{
			            resolve();
			        }
				}else{
					resolve();
				}
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				if ((PageLogicObj.IsARCOSFormula=="1")||(GlobalObj.CMMedNotOpenARCOS=="1")){
					ARCOSChangePrescType(ARCOSRowid,(function(ARCOSRowid){
						return function(){
							var ret=tkMakeServerCall("web.DHCDocOrderCommon","SetARCOSItemDirect",'AddCopyItemToList',ARCOSRowid,session['LOGON.HOSPID'],GlobalObj.EpisodeID);
						}
					})(ARCOSRowid));
					
				}else{
					//自动切换处方类型中可能有弹窗，这里的医嘱套弹出需要用回调处理-tanjishan202006
					ARCOSChangePrescType(ARCOSRowid,(function(ARCOSRowid){
						return function(){
							websys_showModal({
								url:"doc.arcositemlist.hui.csp?EpisodeID=" + GlobalObj.EpisodeID + "&ARCOSRowid=" + ARCOSRowid,
								title:'草药医嘱套录入',
								width:1160,height:592,
								AddCopyItemToList:AddCopyItemToList
							});
						}
					})(ARCOSRowid));
				}
			})
		})
	}
}
function ClearGroupData(Rowindex,GroupNo){
	SetCellData(Rowindex,GroupNo,"OrderName",'');
	SetCellData(Rowindex,GroupNo,"OrderDoseQty",'');
	SetCellData(Rowindex,GroupNo,"OrderPhSpecInstr",'');
	SetCellData(Rowindex,GroupNo,"OrderPrice",'');
	SetCellData(Rowindex,GroupNo,"OrderARCIMID",'');
	SetCellData(Rowindex,GroupNo,"OrderItemID",'');
	SetCellData(Rowindex,GroupNo,"OrderSum",'');
	SetCellData(Rowindex,GroupNo,"OrderHiddenPara",'');
	SetCellData(Rowindex,GroupNo,"OrderDoseUOM",'');
	$("#"+Rowindex+"_OrderCoverMainIns"+GroupNo+"").prop("checked",false);
}	
function AddItemToList(RowIndex,GroupIndex,OrdParams,callBackFun) {
	SetTimeLog("AddItemToList","start");
	//如果按登录科室取接收科室?就把登录科室传进去
	var LogonDep="";
    if ($("#FindByLogDep").checkbox('getValue')){
	    FindRecLocByLogonLoc=1;
	    LogonDep=session['LOGON.CTLOCID']
	}else{
		FindRecLocByLogonLoc=0;
	}
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
	var CMPrescTypeCode=DetailsArr[0];
	var FocusObj=GetNewFocusIndex();
	RowIndex=FocusObj.FocusRowIndex;
   	GroupIndex=FocusObj.FocusGroupIndex;
	var BaseParam = {
		///单条医嘱信息-后台会重置这部分数据
		OrderARCIMRowid:"",
		PrescTypeCode:CMPrescTypeCode,
		RelocRowID:$('#RecLoc').combobox('getValue'),
		PrescDurFactor:GetDurFactor(),
		OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
		ITMRowId:"",
		rowid:RowIndex+"^"+GroupIndex,
		///全局变量
		Adm:GlobalObj.EpisodeID,
		LogonDep:LogonDep,
		OrderOpenForAllHosp:$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0, 
		SessionStr:GetSessionStr(),
		OrderARCOSRowid:"",
		RowIndex:RowIndex,
		GroupIndex:GroupIndex,
		OrderPriorRowid:$('#PrescPrior').combobox('getValue')
	}
	var ItemOrdsJson=GetItemOrds();
	//需要绑定到行上的医嘱
	var UserOptionsArr=new Array();
	var NeedAddItemCongeriesArr=new Array();
	new Promise(function(resolve,rejected){
		SetTimeLog("GetItemCongeries","start");
		GetItemCongeries(OrdParams,BaseParam,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesArr,resolve);
	}).then(function(NeedAddItemCongeriesObj){
		SetTimeLog("GetItemCongeries","end");
		FocusRowIndex=FocusObj.FocusRowIndex;
   		FocusGroupIndex=FocusObj.FocusGroupIndex;
		if (NeedAddItemCongeriesObj.length==0){
			SetFocusColumn("OrderName"+GroupIndex,RowIndex);
			if (callBackFun) callBackFun(false);
			return;
		}
		var ObjAdd=AddItemCongeriesToRow(NeedAddItemCongeriesObj);
		if (ObjAdd==true){
			var cbox=$HUI.checkbox("#DrugAndQtyYQ");
			if (cbox.getValue()){
				SetFocusColumn("OrderDoseQty"+GroupIndex,RowIndex);
			}else{
				if (GroupIndex==GlobalObj.ViewGroupSum){
					var NewRowIndex=eval(RowIndex)+1;
					var NewGroupIndex=1;
				}else{
					var NewRowIndex=RowIndex;
					var NewGroupIndex=eval(GroupIndex)+1;
				}
				SetFocusColumn("OrderName"+NewGroupIndex,NewRowIndex);
			}
		}
		if (callBackFun) callBackFun(ObjAdd);
	})
	//将对象集合添加到行上
	function AddItemCongeriesToRow(NeedAddItemCongeriesObj){
		if (+FocusGroupIndex==0) FocusGroupIndex=1;
		if (+FocusRowIndex==0) FocusRowIndex=1;
		if (+RowIndex==0) RowIndex=FocusRowIndex;
   		if (+GroupIndex==0) GroupIndex=FocusGroupIndex;
		var ParamObj={};
		for (var i=0,Length=NeedAddItemCongeriesObj.length;i<Length;i++) {
			ParamObj={};
			ParamObj=NeedAddItemCongeriesObj[i];
			//保存行数据
			var returnValue=AddItemDataToRow(RowIndex,GroupIndex,ParamObj);
			if (returnValue==true) {
				if (i<(Length-1)) {
					if (FocusGroupIndex==GlobalObj.ViewGroupSum){
						var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
						if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
						FocusGroupIndex=1;
						GroupIndex=1;
						FocusRowIndex=eval(FocusRowIndex)+1;
						RowIndex=FocusRowIndex;
					}else{
						FocusGroupIndex=eval(FocusGroupIndex)+1;
						GroupIndex=FocusGroupIndex;
					}
				}
			}
		}
		return true;
	}
	function GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesArr,callBackFun){
		var NeedAddItemCongeriesObj=new Array();
		if (NeedAddItemCongeriesArr.length==0) {
			var PreNeedAddItemCongeriesObj=new Array();
		}else{
			var PreNeedAddItemCongeriesObj=NeedAddItemCongeriesArr;
		}
		var OrdCongeriesJson=JSON.stringify(OrdCongeriesObj);
		var BaseParamJson=JSON.stringify(BaseParamObj);
		var UserOptionsJson=JSON.stringify(UserOptionsArr);
		var ItemCongeries = cspRunServerMethod(GlobalObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson,UserOptionsJson);
		var ItemCongeriesObj=eval("("+ItemCongeries+")");
		var RecursionFlag=false,Sum=0;
		if (PreNeedAddItemCongeriesObj.length>0){
			//第二次交互后结果只需要处理需要添加的串
			for (var i=0;i<ItemCongeriesObj.length;i++){
				var ItemToListDetailObj=ItemCongeriesObj[i];
				if (ItemToListDetailObj.ErrCode<0) continue;
				if ($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==true) continue;
				var PreItemToListDetailObj=PreNeedAddItemCongeriesObj[i];
				if (PreItemToListDetailObj.PreSuccessFlag==false) continue;
				NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
			}
			callBackFun(NeedAddItemCongeriesObj);
		}else{
			new Promise(function(resolve,rejected){
				(function(callBackExecFun){
					function loop(i){
						new Promise(function(resolve,rejected){
							var ItemToListDetailObj=ItemCongeriesObj[i];
							if ($.isEmptyObject(ItemToListDetailObj)) {
								resolve();
							}
							///注意:js中对象都是指针型
							///校验后台获取的行数据是否可用或是否需要修改
							$.extend(ItemToListDetailObj, {ItemCongeriesObj:ItemCongeriesObj,callBackFun:resolve});
							CheckItemCongeries(ItemToListDetailObj);
						}).then(function(CheckBeforeAddObj){
							var ItemToListDetailObj=ItemCongeriesObj[i];
							if (typeof CheckBeforeAddObj!="undefined"){
								if (CheckBeforeAddObj.UserOptionObj.length>0){
									var CellPos=ItemToListDetailObj.OrdListInfo.RowIndex+"^"+ItemToListDetailObj.OrdListInfo.GroupIndex;
									UserOptionsArr.push({rowid:CellPos,UserOption:CheckBeforeAddObj.UserOptionObj});
									RecursionFlag=true;
								}
								//协定处方不符合录入条件即刻退出循环
								if ((CheckBeforeAddObj.SuccessFlag==false)&&(PageLogicObj.IsARCOSFormula==1)&&(ItemToListDetailObj.OrdListInfo.IsARCOSFormula==1)){
									$.messager.alert("提示","存在不符合录入条件的医嘱,不能使用此协定处方医嘱套录入医嘱!","info",function(){
										NeedAddItemCongeriesObj=[];
										callBackFun(NeedAddItemCongeriesObj);
									})
									return;
								}
								//费用控制
								var OrderPriorRowid = $('#PrescPrior').combobox('getValue');
								var OrderPrice=ItemToListDetailObj.OrdListInfo.OrderPrice;
								if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid) && (parseFloat(OrderPrice) != 0)) {
									Sum=parseFloat(Sum)+parseFloat(ItemToListDetailObj.OrdListInfo.OrderSum);
								}
								if ((CheckBeforeAddObj.SuccessFlag==true)&&($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==false)){
									NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
								}
							}
							i++;
							if ( i < ItemCongeriesObj.length ) {
								 loop(i);
							}else{
								if (RecursionFlag==true){
									GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesObj,callBackFun);
									return;
								}else{
									callBackExecFun();
								}
							}
						})
					}
					loop(0);
				})(resolve); //此处的resolve是指callBackFun(NeedAddItemCongeriesObj)
			}).then(function(){
				if (Sum>0) {
					if (!CheckDeposit(Sum, "")) {
						NeedAddItemCongeriesObj=[];
					}
				}
				SetTimeLog("AddItemToList", "GetItemCongeries over");
				callBackFun(NeedAddItemCongeriesObj);
			});
		}
	}
	function GetItemOrds(){
		var ItemOrdsObj={
			Length:0,
			ItemOrds:[]	//行对象集合
		}
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    	for (var i=1; i<=rows; i++){
			for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
				var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				if ((OrderDoseQty=="")||(!isNumber(OrderDoseQty))){
					OrderDoseQty=0;
				}
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				if (OrderARCIMRowid!=""){
					var ItemOrd={
						OrderARCIMRowid:OrderARCIMRowid,
						OrderDoseQty:OrderDoseQty,
						OrderHiddenPara:OrderHiddenPara,
						Row:i,
						Group:j
					}
					ItemOrdsObj.ItemOrds.push(ItemOrd);
					ItemOrdsObj.Length=ItemOrdsObj.Length+1;
				}
			}
		}
		var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
		return ItemOrdsJson;
	}
}
function OrderDoseQtykeyuphandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		var obj=websys_getSrcElement(e);
		FocusGroupIndex=GetFocusGroupIndex(obj.id);
		var Row=GetEventRow(e);
		MoveFouce(keycode,Row,FocusGroupIndex,"OrderDoseQty")
		return websys_cancel();
	}catch(e) {};
}
function OrderDoseQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		// || ((keycode > 95) && (keycode < 106))
		if ((keycode == 8) || (keycode == 9) || (keycode == 46)|| (keycode == 110) || (keycode == 13) || ((keycode > 47) && (keycode < 58))) {
			var obj=websys_getSrcElement(e);
			var OrderDoseQty=obj.value;
			FocusGroupIndex=GetFocusGroupIndex(obj.id);
			var Row=GetEventRow(e);
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			var OrderARCIMRowid=GetCellData(Row,FocusGroupIndex,"OrderARCIMID");
			
			if ((keycode == 46)|| (keycode == 110)){
		       if (OrderARCIMRowid!=""){
			       var SubCatID = tkMakeServerCall("web.DHCDocOrderEntry","GetARCItemSubCatIDBroker",'','',OrderARCIMRowid);
			       var AllowEntryDecimalItemCatStr = "^" + GlobalObj.AllowEntryDecimalItemCat + "^";
				   if ((AllowEntryDecimalItemCatStr.indexOf("^" + SubCatID + "^")) == -1) {
					   return websys_cancel();
				   }
			    } 
		    } 
		    if ((keycode==13)||(keycode==9)){
			    SetScreenSum();
			    if ((OrderDoseQty!="")&&(OrderDoseQty!="0")&&(OrderARCIMRowid!="")){
					if (GlobalObj.HospitalCode=="SCDXHXYY"){
						if (FocusGroupIndex==GlobalObj.ViewGroupSum){
							if ((PageLogicObj.IsARCOSFormula==0)||(GlobalObj.FormulaCanAppendItem=="1")){
								var NextRow=parseInt(Row)+1;
								if (records==NextRow) {Add_CMOrdEntry_row();}
							}
						}
						SetFocusColumn("OrderPhSpecInstr"+FocusGroupIndex,Row);
					}else{
						if ((PageLogicObj.IsARCOSFormula==0)||(GlobalObj.FormulaCanAppendItem=="1")){
							if (FocusGroupIndex==GlobalObj.ViewGroupSum){
								if (records==Row) {Add_CMOrdEntry_row();}
								FocusGroupIndex=1;
								Row=eval(Row)+1;
							}else{
								FocusGroupIndex=eval(FocusGroupIndex)+1;
							}
							var cbox=$HUI.checkbox("#DrugAndQtyYQ");
							if (cbox.getValue()){
								SetFocusColumn("OrderName"+FocusGroupIndex,Row);
							}else{
								SetFocusColumn("OrderDoseQty"+FocusGroupIndex,Row);
							}
						}
					}
				}
				return websys_cancel();
		    }
		}else{
			return websys_cancel();	
		}
	}catch(e) {}
}
function OrderDoseQtychangehandler(e){
	try {
		var obj=websys_getSrcElement(e);
		var Sum=obj.value
		var Id=obj.id;
		FocusGroupIndex=GetFocusGroupIndex(Id);
		var OrderDoseQty=obj.value;
		if (!isNumber(OrderDoseQty)){
			OrderDoseQty=0;
		}
		var Row=GetEventRow(e);
		var OrderARCIMRowid=GetCellData(Row,FocusGroupIndex,"OrderARCIMID");
		new Promise(function(resolve,rejected){
			CheckProtocolPackSum(FocusGroupIndex,Row,resolve);
		}).then(function(Rtn){
			return new Promise(function(resolve,rejected){
				if (Rtn==false) return;
				CheckINCIPackSum(FocusGroupIndex,Row,0,resolve);
			})
		}).then(function(INCIPackCombStr){
			if (INCIPackCombStr == "") return; 
			var OrderSum=0;
		    if ((OrderDoseQty!="")&&(OrderARCIMRowid!="")){
				var PrescDurationFactor=1;
				var Price=$("#"+Row+"_OrderPrice"+FocusGroupIndex+"").val();
				OrderSum=parseFloat(OrderDoseQty)*PrescDurationFactor*parseFloat(Price);
		    }
			$("#"+Row+"_OrderSum"+FocusGroupIndex+"").val(OrderSum);
		    SetScreenSum();
		})
	}catch(e) {dhcsys_alert(e.message)}
}
function CheckProtocolPackSum(GroupIndex,Row,callBackFun) {
	var e=$("#"+Row+"_OrderDoseQty"+GroupIndex+"");
	if (!e) callBackFun(true);
	var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
	var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
	var RecLoc=$('#RecLoc').combobox('getValue'); 
	//判断下的数量是不是由药房系数组合
	var rtn = $.cm({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"CheckProtocolPackSum",
		dataType:"text",
		OrderARCIMRowid:OrderARCIMRowid, 
		SumQty:Sum,
		RecLocDr:RecLoc
	},false);
	var rtnArr=rtn.split("^");
	if (rtnArr[0]!="0"){
		$.messager.alert("提示",rtnArr[1],"info",function(){
			$("#"+Row+"_OrderDoseQty"+GroupIndex+"").focus();
			callBackFun(false);
		});
		return false;
	}else{
		callBackFun(true);
	}
	
}
function OrderPhSpecInstrchangehandler(e){
}
function Columnfocushandler(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var Row=GetEventRow(e);
	if (Row==undefined) return;
	FocusRowIndex=Row
	FocusGroupIndex=GetFocusGroupIndex(Id);
}
function SetFocusColumn(ColName,Row){
	var obj=$("#"+Row+"_"+ColName+"");
	if(obj){
		websys_setfocus(Row+"_"+ColName);
	}
}
function SetScreenSum(){
	var ScreenQtySum=0,ColArrIndex=0;;
	var ColArr=[],OrderItemArr=[];
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			var OrderItemRowid=GetCellData(i,j,"OrderItemID");
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				var Price=GetCellData(i,j,"OrderPrice");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				ScreenQtySum=ScreenQtySum+parseFloat(OrderDoseQty);
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				var OrderItemSum=OrderHiddenPara.split(String.fromCharCode(3))[12];
				OrderItemArr.push(i+"^"+j+"^"+OrderItemSum);
				var colPromis=new Promise(function(resolve,rejected){
					CheckINCIPackSum(j, i,"1",resolve)
				}).then(function(INCIPackCombStr){
					if (INCIPackCombStr!=""){
						var OrderItemSum=tkMakeServerCall("web.DHCSTINTERFACE","GetInciListPrice",INCIPackCombStr,session['LOGON.HOSPID'])
					}else{
						var OrderItemSum=OrderItemArr[ColArrIndex].split("^")[2];
					}
					ColArrIndex++;
					var SumObj={
						amount:parseFloat(OrderItemSum) //,*parseFloat(OrderDoseQty)
					};
					return SumObj;
				})
				ColArr.push(colPromis);
			}
		}
	}
	Promise.all(ColArr)
	.then(function(SumObj){
		var amount=0;
		for (var i=0;i<SumObj.length;i++) {
			amount=amount+parseFloat(SumObj[i].amount);
		}
		var PrescDurationFactor=GetDurFactor();
		var TotalToBillSum=parseFloat(GlobalObj.ToBillSum)+parseFloat(amount);
		TotalToBillSum=TotalToBillSum.toFixed(2);
		$("#ScreenBillSum").val(amount.toFixed(2));
		$("#ScreenQtySum").val(ScreenQtySum.toFixed(2));
		if (PrescDurationFactor!=""){	
			var totalbill=(amount*100*PrescDurationFactor/100); //注意在js里有时候数字显示会有无限循环的小数，只有先乘以100再除以100可以解决此问题。
			totalbill=totalbill.toFixed(2);
			$("#TotailBillSum").val(totalbill);
		}else{
			$("#TotailBillSum").val(amount);
		}
	});
}
function GetEventRow(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	if (!Id){return;}
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1].split("_")[0];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	return Row
}
function GetFocusGroupIndex(objId){
	if (!objId){return;}
	var arrId=objId.split("z");
	var ColName=arrId[0];
	var start=ColName.length-1;
	GroupIndex=+ColName.substring(start,start+1);
	if (GroupIndex==0) GroupIndex=1;
	return GroupIndex;
}
function CMPrescTypeChangeHandler(){
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var CMPrescTypeCode=DetailsArr[0];
    var FreqStr=DetailsArr[1];
    var FormFreqRowid=mPiece(FreqStr, "!", 0);
    var InstrStr=DetailsArr[2];
    var FormInstrRowid=mPiece(InstrStr, "!", 0);
    var DurStr=DetailsArr[3];
    var FormDurRowid=mPiece(DurStr, "!", 0);
    var DefaultQtyStr=DetailsArr[4];
    var DefaultQtyID=mPiece(DefaultQtyStr, "!", 1);
    var CMRecLocStr=DetailsArr[6];
    CMRecLocStr=CMRecLocStr.replace(/[!]/g, String.fromCharCode(2))
    CMRecLocStr=CMRecLocStr.replace(/[@]/g, String.fromCharCode(1))
    var CNMedCookReclocStr=DetailsArr[7];
    var CNMedCookModeFeeItem=DetailsArr[10];
    var NotAllowChangeCook=DetailsArr[12];
    var CheckChange=1;
	var sbox=$HUI.checkbox("#PrescCookDecoction") //代煎checkbox
	var PrescCookDVal=sbox.getValue();
	sbox.enable(); //此处需先设置checkbox是非禁用状态,否则禁用状态下修改checkbox的选中状态不会调用onCheckChange事件
	///这里会触发PrescCookDecoctionClick事件,延迟切换接受科室,并自动切换医嘱类型	
	if ((CNMedCookModeFeeItem!="")||(CNMedCookReclocStr!="")){
		if (!PrescCookDVal) sbox.setValue(true);
		else  CheckChange=0; 
	}else{
		if (PrescCookDVal) sbox.setValue(false);
		else  CheckChange=0; 
	}
	if (NotAllowChangeCook=="1"){
		sbox.disable();
	}else{
		sbox.enable();
	}
	/// 需判断代煎是否是可编辑状态，如是不可编辑状态，则不能触发PrescCookDecoctionClick事件
	//var DisabledFlag=$("#PrescCookDecoction").prop("disabled");
	if (CheckChange==0){ //((DisabledFlag)||
		setTimeout(function(){
			SetPrescAppenItemQty();
		})
	}
	var sbox = $HUI.combobox("#PrescFrequence");
	if ($.hisui.indexOfArray(sbox.getData(),"PHCFRRowid",FormFreqRowid)<0) FormFreqRowid="";
		sbox.select(FormFreqRowid);
	var sbox = $HUI.combobox("#PrescInstruction");
	if ($.hisui.indexOfArray(sbox.getData(),"HIDDEN",FormInstrRowid)<0) FormInstrRowid="";
		sbox.select(FormInstrRowid);
	var sbox = $HUI.combobox("#PrescDuration");
		//sbox.select(FormDurRowid); //select会触发PrescCookDecoctionClick,进而触发AutoConvertPrescForm事件,导致AutoConvertPrescForm事件重复调用
	sbox.setValue(FormDurRowid); 
	setTimeout(function(){
		var sbox = $HUI.combobox("#CookModelist");
		sbox.select(DetailsArr[18]); 
	})
	var DurFactor = $.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetDurationFactor",
		dataType:"text",
		DurationRowid:FormDurRowid
	},false);
	PageLogicObj.PrescDurFactor=DurFactor; 
	$('#PrescOrderQty').combobox('select',DefaultQtyID);
    //CheckCNMedByPrescForm();
    return;
}

///对当前行内的医嘱项做处方类型转换
function AutoConvertPrescForm(ConvertPrescObj){
	if (typeof ConvertPrescObj == "undefined") ConvertPrescObj={};
	var OrderItemStr="";
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
	var OrderItem="",FirstOrderItemCatRowId="";
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
		   if (OrderARCIMRowid!=""){
			    var OrderName=GetCellData(i,j,"OrderName");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr");
				//var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
				OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                var OtherItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 3);
                if (("^"+CNItemCatStr+"^").indexOf("^"+OtherItemCatRowid+"^")<0){
                	if (OrderItemStr==""){
	                	OrderItemStr=OrderItem
	                }else{
		            	OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem
		            }
                }
                if (FirstOrderItemCatRowId=="") FirstOrderItemCatRowId=OtherItemCatRowid;
		   }
	    }
	}
	if (OrderItemStr==""){
		return true;
	}
	var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
	var ConvertInfo=$.cm({
		ClassName:"web.DHCDocOrderEntryCM",
		MethodName:"AutoConvertPrescForm",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderItemStr:OrderItemStr,
		PrescTypeCode:SelPrescTypeCode,
		OrderRecDepRowid:OrderRecDepRowid
	},false);
	var ErrInfo=ConvertInfo.split(String.fromCharCode(2))[0];
	var ConvertOrderItemStr=ConvertInfo.split(String.fromCharCode(2))[1];
	if (ConvertOrderItemStr==""){
		CheckCNMedByPrescForm();
		return;
	}
	$.extend(ConvertPrescObj, { ConvertOrderItemStr: ConvertOrderItemStr});
	
	new Promise(function(resolve,rejected){
		if (ErrInfo!="") {
			$.messager.confirm('提示', "监测到转化处方类型出现异常:"+ErrInfo+",是否确认转换?", function(r){
				if (!r) {
					var CMPrescTypeCode=PageLogicObj.PreCMPrescTypeCode;
					$("#CMPrescTypeKW").keywords('select',PageLogicObj.PreCMPrescTypeCode);
					setTimeout(function(){
						//重新设置未切换前的默认值
						SetPreCMPrescTypeData(CMPrescTypeCode);
					},1000)
					return;
				}
				resolve();
			});
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ConvertOrderItemStr=ConvertPrescObj.ConvertOrderItemStr;
			if (ConvertOrderItemStr.indexOf(String.fromCharCode(3))>=0){
				var ConvertOrderItemStrarry=ConvertOrderItemStr.split(String.fromCharCode(3))
				var ConvertOrderitemlist=ConvertOrderItemStrarry[0];
				var JasoDataConvertOrder=ConvertOrderItemStrarry[1];
				if ($("#ConvertOrderItem").length>0){
					return false;
				}
				var $code ="<div id='kw'></div>" ;
				var buttons=[{
						text:"确定",
						iconCls:'icon-w-save',
						handler:function(){
							ConvertCurrentorderhandle(ConvertOrderitemlist);
						}
					},{
						text:'关闭',
						iconCls:'icon-w-close',
						handler:function(){
			   				destroyDialog("ConvertOrderItem");
			   				var CMPrescTypeCode=PageLogicObj.PreCMPrescTypeCode;
			   				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
			   				setTimeout(function(){
								//重新设置未切换前的默认值
								SetPreCMPrescTypeData(CMPrescTypeCode);
							},1000)
						}
					}]
				$("body").append("<div id='"+"ConvertOrderItem"+"' class='hisui-dialog'></div>");
				$("#ConvertOrderItem").dialog({
			        title: "处方类型转换",
			        width: dw,
			        height: dh,
			        cache: false,
			        iconCls: "icon-w-edit",
			        collapsible: false,
			        minimizable:false,
			        maximizable: false,
			        resizable: false,
			        modal: true,
			        closed: false,
			        closable: false,
			        content:$code,
			        buttons:buttons
			    });
				 $("#kw").keywords({
					singleSelect:false,
		            onClick:function(v){
			            var id=v.id;
			            if (!$("#"+id).hasClass("selected")) return;
			            var row=id.split("-").slice(1,id.split("-").length).join("-");
			            var NewStr=$("#kw").keywords('getSelected')
			            for (i=0;i<NewStr.length;i++){
				            var newId=NewStr[i].id;
				            var newRow=newId.split("-").slice(1,newId.split("-").length).join("-");
				            if ((newRow == row)&&(newId!=id)) {
					            $("#kw").keywords('switchById',newId);
					        }
				        }
			        },
		        	items:eval("("+JasoDataConvertOrder+")")
				 })
			}else{
				resolve();
			}
		})
	}).then(function(){
		/*return new Promise(function(resolve,rejected){
			var OrdParamsArr=new Array();
			var ConvertOrderItemStr=ConvertPrescObj.ConvertOrderItemStr;
			var ConvertOrderItemArr=ConvertOrderItemStr.split(String.fromCharCode(1));
			var FocusRowIndex=1,FocusGroupIndex=1;
			for (var i=0,Length=ConvertOrderItemArr.length;i<Length;i++){
				var ParmArr=ConvertOrderItemArr[i].split("^");
				var NewOrderARCIMRowid=ParmArr[0];
				var NewOrderDoseQty=ParmArr[1];
				var OrderPhSpecInstr=ParmArr[2];
				var Row=ParmArr[3];
				var ColName=ParmArr[4];
				if ((Row=="")||(ColName=="")){
					continue;
				}
				if ((Row!=FocusRowIndex)||(ColName!=FocusGroupIndex)){
					ClearGroupData(Row,ColName);
				}
				///转化失败，清除掉这个单元格
				if (NewOrderARCIMRowid==""){
					//存在转换失败的情况下，清除掉医嘱套记录
					PageLogicObj.m_ARCOSRowId="";
					ClearGroupData(Row,ColName);
					ChangeRowStyle1(Row,ColName,false);
					continue;
				}
				var Para=NewOrderDoseQty+"^"+"^"+OrderPhSpecInstr+"^"+"";
				
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:NewOrderARCIMRowid,
					ParamS:Para
				};
			}
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})*/
		return new Promise(function(resolve,rejected){
			(function(callBackExecFun){
				FocusRowIndex=1,FocusGroupIndex=1;
				var Row="",ColName="";
				function loop(i){
					var ConvertOrderItemStr=ConvertPrescObj.ConvertOrderItemStr;
					var ConvertOrderItemArr=ConvertOrderItemStr.split(String.fromCharCode(1));
					new Promise(function(resolve,rejected){
						var OrdParamsArr=new Array();
						var ParmArr=ConvertOrderItemArr[i].split("^");
						var NewOrderARCIMRowid=ParmArr[0];
						var NewOrderDoseQty=ParmArr[1];
						var OrderPhSpecInstr=ParmArr[2];
						Row=ParmArr[3];
						ColName=ParmArr[4];
						if ((Row=="")||(ColName=="")){
							resolve();
						}else if (NewOrderARCIMRowid==""){
							//存在转换失败的情况下，清除掉医嘱套记录
							PageLogicObj.m_ARCOSRowId="";
							ClearGroupData(Row,ColName);
							ChangeRowStyle1(Row,ColName,false);
							resolve();
						}else{
							//if ((Row!=FocusRowIndex)||(ColName!=FocusGroupIndex)){
								ClearGroupData(Row,ColName);
							//}
							var Para=NewOrderDoseQty+"^"+"^"+OrderPhSpecInstr+"^"+"";
							OrdParamsArr[OrdParamsArr.length]={
								OrderARCIMRowid:NewOrderARCIMRowid,
								ParamS:Para
							};
							AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
						}
					}).then(function(rtnValue){
						if (rtnValue==false){
							PageLogicObj.m_ARCOSRowId="";
							ClearGroupData(Row,ColName);
						}else{
							FocusGroupIndex=FocusGroupIndex+1
							if (FocusGroupIndex>GlobalObj.ViewGroupSum){
								FocusRowIndex=FocusRowIndex+1
								FocusGroupIndex=1
							}
						}
						i++;
						if ( i < ConvertOrderItemArr.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		})
	}).then(function(){
		if((PageLogicObj.IsARCOSFormula=="1")&&(PageLogicObj.m_ARCOSRowId!="")){
			PageLogicObj.IsARCOSFormula= $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"IsARCOSFormula",
				dataType:"text",
				ARCOSRowid:PageLogicObj.m_ARCOSRowId
			},false);
		}else{
			PageLogicObj.IsARCOSFormula="0";
		}
		PageLogicObj.m_AddItemToListMethod = "LookUp";
		SetScreenSum();
	})
}

function ConvertCurrentorderhandle(ConvertOrderItemStr){
	var NewStr=$("#kw").keywords('getSelected');
	var NewCovertCurrent=""
	for (i=0;i<NewStr.length;i++){
		var Convertorder=NewStr[i].value;
		if (NewCovertCurrent==""){ 
			NewCovertCurrent=Convertorder;
		}else{ 
			NewCovertCurrent=NewCovertCurrent+String.fromCharCode(1)+Convertorder ;
		}
	}
	if (NewCovertCurrent==""){
		$.messager.alert("提示","请至少选择一条记录!");  
		return false;
	}else{
		if ($(".kw-section").length>NewCovertCurrent.split(String.fromCharCode(1)).length){
			$.messager.alert("提示","每条医嘱请至少选择一条转换记录!");  
			return false;
		}
	}
	if (ConvertOrderItemStr!=""){
		ConvertOrderItemStr=ConvertOrderItemStr+String.fromCharCode(1)+NewCovertCurrent;
	}else{
		ConvertOrderItemStr=NewCovertCurrent;
	}
	var ConvertOrderItemArr=ConvertOrderItemStr.split(String.fromCharCode(1));
	FocusRowIndex=1,FocusGroupIndex=1
	var OrdParamsArr=new Array();
	for (var i=0,Length=ConvertOrderItemArr.length;i<Length;i++){
		var ParmArr=ConvertOrderItemArr[i].split("^");
		var NewOrderARCIMRowid=ParmArr[0];
		var NewOrderDoseQty=ParmArr[1];
		var OrderPhSpecInstr=ParmArr[2];
		var Row=ParmArr[3];
		var ColName=ParmArr[4];
		if ((Row=="")||(ColName=="")){
			continue;
		}
		//if ((Row!=FocusRowIndex)||(ColName!=FocusGroupIndex)){
			ClearGroupData(Row,ColName);
		//}
		///转化失败，清除掉这个单元格
		if (NewOrderARCIMRowid==""){
			//存在转换失败的情况下，清除掉医嘱套记录
			PageLogicObj.m_ARCOSRowId="";
			ClearGroupData(Row,ColName);
			ChangeRowStyle1(Row,ColName,false);
			continue;
		}
		var Para=NewOrderDoseQty+"^"+"^"+OrderPhSpecInstr+"^"+"";
		OrdParamsArr[OrdParamsArr.length]={
			OrderARCIMRowid:NewOrderARCIMRowid,
			ParamS:Para
		};
	}
	new Promise(function(resolve,rejected){
		AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve); 
	}).then(function(rtnValue){
		if (rtnValue==false) {
			ClearGroupData(FocusRowIndex,FocusGroupIndex);
		}else{
			if((PageLogicObj.IsARCOSFormula=="1")&&(PageLogicObj.m_ARCOSRowId!="")){
				PageLogicObj.IsARCOSFormula= $.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:PageLogicObj.m_ARCOSRowId
				},false);
			}else{
				PageLogicObj.IsARCOSFormula="0";
			}
			PageLogicObj.m_AddItemToListMethod = "LookUp";
			SetScreenSum();
		}
		destroyDialog("ConvertOrderItem");
	})
}
///判断当前处方类型和列表中的药品类型是否一致
function CheckCNMedByPrescForm(){
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
    new Promise(function(resolve,rejected){
		CheckCNMedSameDrugForm(CNItemCatStr,"Y","","Y",resolve);
	}).then(function(Paramsobj){
		 if (!Paramsobj.ret) {
		    //协定处方应该要维护单独的处方类型才对吧
	        if (dhcsys_confirm(t['IsNeedNewPresc'])) {
	            if (PageLogicObj.m_AddItemToListMethod ==""){
	                ClearList();
	                 FocusRowIndex = 1;
	                 FocusGroupIndex = 1;
	                 PageLogicObj.m_AddItemToListMethod = "LookUp";
	                 SetScreenSum();
	            }else{
	                ClearList();
	            }
	            $("#PrescList").combobox('select','');
	            
	            var SessionFieldName = "UserUnSaveDataCM" + GlobalObj.EpisodeID;
	            $.cm({
					ClassName:"web.DHCDocOrderEntry",
					MethodName:"SetUserCMUnSaveData",
					dataType:"text",
					wantreturnval:0,
					Name:SessionFieldName, 
					Value:""
				},false);
				PageLogicObj.m_ARCOSRowId="";
				PageLogicObj.IsARCOSFormula=0;
	            ClearClickHandler();
	        } else {
	            var ItemCatRowid=Paramsobj.ItemCatRowid;
	            var PrescTypeIndex=GetCNMedPrescTypeIndex(ItemCatRowid);
	            $("#CMPrescTypeKW").keywords('select',PrescTypeIndex);
	            resolve(false);
	        }
		}else{
			resolve(true);
		}
	}).then(function(){
		
	})
}
function CheckCNMedSameDrugForm(CNItemCatStr,CheckAllFlag,idesc,AlertFlag,callBackFun) {
	var ReturnObj={ ret: true,ItemCatRowid:""};
	new Promise(function(resolve,rejected){
		if (CNItemCatStr == ""){
			resolve();
		}else{
			var CurrCellPos = FocusRowIndex + "^" + FocusGroupIndex;
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records"); 
			(function(callBackExecFun){
				function loop(i){
					var Row=i;
					new Promise(function(resolve,rejected){
						(function(callBackExecFunExc){
							function loopCol(j){
								new Promise(function(resolve,rejected){
									var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
								    var OrderName=GetCellData(i,j,"OrderName");
								    var CellPos = i + "^" + j;
								    if ((OrderARCIMRowid != "") && ((CellPos != CurrCellPos) || (CheckAllFlag == "Y"))) {
									    var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                						var OtherItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 3);
                						if (("^"+CNItemCatStr+"^").indexOf("^"+OtherItemCatRowid+"^")<0){
	                						if (AlertFlag=="Y"){
								                if (idesc == "") {
									                var AlertMag=OrderName + ",不同处方类型不可同时下";
							                    } else {
								                    var AlertMag=OrderName + "," + "与录入药品(" + idesc + ")" + "的处方类型不一致!";
							                    }
							                    $.messager.alert("提示",AlertMag,"info",function(){
							                        $.extend(ReturnObj, { ret: false,ItemCatRowid:OtherItemCatRowid});
							                        resolve();
							                    });
							                    return;
							                }
	                					}
									}
									resolve();
								}).then(function(){
									j++;
									if ( j <= GlobalObj.ViewGroupSum ) {
										 loopCol(j);
									}else{
										callBackExecFunExc();
									}
								})
							}
							loopCol(0);
						})(resolve);
					}).then(function(){
						i++;
						if ( i <= rows ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}
	}).then(function(){
		callBackFun(ReturnObj);
	})
}
function SetPrescAppenItemQty(){
	var PrescCookDecoctionFlag = 0;
	var sbox=$HUI.checkbox("#PrescCookDecoction"); //代煎checkbox
	if (sbox.getValue()){ 
		PrescCookDecoctionFlag = 1;
	}
	if ($("#CMOrderOpenForAllHosp").length==1){
		var CMOrderOpenForAllHospFlag=$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0;
	}else{
		var CMOrderOpenForAllHospFlag=0;
	}
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");    
    var CMRecLocStr=DetailsArr[6];
    var CNMedCookReclocStr=DetailsArr[7];
    var OpenHospCMRecLocStr=DetailsArr[15];
    var OpenHospCNMedCookReclocStr=DetailsArr[16];
    var RecLocStr="";
    if (CMOrderOpenForAllHospFlag==1) {
	    if ((PrescCookDecoctionFlag==1)&&(OpenHospCNMedCookReclocStr!="")){
	        RecLocStr=OpenHospCNMedCookReclocStr;
	    }else{
	        RecLocStr=OpenHospCMRecLocStr;
	    }
	}else{
	    if ((PrescCookDecoctionFlag==1)&&(CNMedCookReclocStr!="")){
	        RecLocStr=CNMedCookReclocStr;
	    }else{
	        RecLocStr=CMRecLocStr;
	    }
    }
    var CookMode=$('#CookModelist').combobox('getValue'); 
    var CookModelist=$('#CookModelist').combobox('getData'); 
    var CookIndex=$.hisui.indexOfArray(CookModelist,"RowID",CookMode);
    if (CookIndex>=0) {
	    var OpenHospCookModeReclocStr=CookModelist[CookIndex].OpenHospCookModeReclocStr;
	    var CookModeReclocStr=CookModelist[CookIndex].CookModeReclocStr;
	    if (CMOrderOpenForAllHospFlag==1) {
		    if (OpenHospCookModeReclocStr!="") RecLocStr=RecLocStr+"!"+OpenHospCookModeReclocStr;
		}else{
			if (CookModeReclocStr!="") RecLocStr=RecLocStr+"!"+CookModeReclocStr;
		}
	}
    RecLocStr=RecLocStr.replace(/[!]/g, String.fromCharCode(2))
    RecLocStr=RecLocStr.replace(/[@]/g, String.fromCharCode(1))
    SetRecLoc(RecLocStr);
    
    
    ///切换处方类型会触发SetPrescAppenItemQty，
    ///在这里进行处方类型转换，保证获取到正确的接受科室
    AutoConvertPrescForm();
    var CNMedAppendItemQtyCalcu=DetailsArr[8];
    var CNMedAppendItem=DetailsArr[11];
    if ((CNMedAppendItem == "")||(PrescCookDecoctionFlag==0)) {
	     $("#PrescAppenItemQty,#CPrescAppenItemQty").hide();
	     $("#PrescAppenItemQty").val(0);
	}else{
	    $("#PrescAppenItemQty,#CPrescAppenItemQty").show();
		var PrescDurationFactor = 0;
		if (CNMedAppendItemQtyCalcu == 1) {
			PrescDurationFactor=1;
		}
		$("#PrescAppenItemQty").val(PrescDurationFactor);
	}
}
function mPiece(s1,sep,n) {
    delimArray = s1.split(sep);
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}
function ResetPrescOrderQty(OrderQtyTextOrValue){
    var OrderInstrRowid = $HUI.combobox("#PrescInstruction").getValue();
    var jsonData=$.cm({
	    ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
	    QueryName:"FindInstrLinkOrderQty",
	    InstrucRowId:OrderInstrRowid,
	    page:1,  
		rows:200
	},false);
	$HUI.combobox("#PrescOrderQty",{
		data:jsonData.rows,
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#PrescOrderQty");
			if (OrderQtyTextOrValue==""){
				if (jsonData.rows[0]) sbox.select(jsonData.rows[0].Code);
			}else{
				//sbox.select(OrderQtyTextOrValue);
				var find=0
				for(var i=0;i<jsonData.rows.length;i++){
					if(jsonData.rows[i].Code==OrderQtyTextOrValue){
						find=1
						sbox.select(OrderQtyTextOrValue);
						break;	
					}
				}
				if(find==0){
					sbox.select(''); //jsonData.rows[0].Code	
				}
			}
		}
	})
}
function SetRecLoc(CMRecLocStr) {
	var defLocId="";
	var RecLocStrArr=new Array();
	var ArrData = CMRecLocStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        var id=ArrData1[0];
		var desc=ArrData1[1];
		if ((ArrData1[2] == "Y")&&(defLocId=="")) { defLocId=id;}
		if ($.hisui.indexOfArray(RecLocStrArr,"id",id)<0) {
			RecLocStrArr.push({"id":id, "desc":desc});
		}
    }
    $HUI.combobox("#RecLoc",{
		data:RecLocStrArr,
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#RecLoc");
			if (defLocId==""){
				defLocId=RecLocStrArr[0].id;
			}
			sbox.select(defLocId);
		}
	});
}
function PrescDurationLookupSelect(value){
	//SetPrescAppenItemQty();
    SetScreenSum();
}
function PrescListChange(value){
	//PrescList_changehandler
	ClearClickHandler();
	var selPrescNo=value.split("^")[0];
	$.m({
	    ClassName:"web.UDHCPrescript",
	    MethodName:"GetPrescListDate",
	    PrescNo:selPrescNo
	},function(PrescListDate){
		if (PrescListDate=="") return false;
		var PrescListArr=PrescListDate.split(String.fromCharCode(12));
		var PrescListArr1=PrescListArr[1].split("^");
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==PrescListArr1[14]){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
		var TempArr = PrescListArr1[0].split(String.fromCharCode(2)); 
		var sbox = $HUI.combobox("#PrescDuration");
			sbox.select(TempArr[1]);
		var TempArr = PrescListArr1[1].split(String.fromCharCode(2));
		var sbox = $HUI.combobox("#PrescInstruction");
			sbox.select(TempArr[1]);
		ResetPrescOrderQty(PrescListArr1[5]);
		var TempArr = PrescListArr1[4].split(String.fromCharCode(2));
		var sbox = $HUI.combobox("#PrescFrequence");
			sbox.select(TempArr[1]);
		var cbox=$HUI.checkbox("#PrescCookDecoction") //代煎checkbox
		if ((PrescListArr1[2]=="02")||(PrescListArr1[2]=="代煎")){
			cbox.setValue(true);
		}else{
			cbox.setValue(false);
		}
		var sbox = $HUI.combobox("#RecLoc");
			sbox.select(PrescListArr1[3]);
		if (selPrescNo.indexOf("I")<0){
			var sbox = $HUI.combobox("#PrescPrior");
				sbox.select(PrescListArr1[6]);
		}
		$('#PrescOrderQty').combobox('setText',PrescListArr1[5]);
		$("#PrescAppenItemQty").val(PrescListArr1[8]);
		$("#PrescNotes").val(PrescListArr1[9]);
		$("#PrescEmergency").val(PrescListArr1[10]);
		if (PrescListArr1[10]=="Y"){
			$("#PrescUrgent").checkbox('setValue',true);
			}else{
			$("#PrescUrgent").checkbox('setValue',false);	
			}
		$("#StartDate").val(PrescListArr1[11]);
		$("#EndDate").val(PrescListArr1[12]);
		PageLogicObj.m_ARCOSRowId=PrescListArr1[13];
		$("#ARCOSRowId").val(PrescListArr1[13]);
		SetPrescAppenItemQty();
		if (PrescListArr[0] != "") {
			var ARCIMARCOSRowid=PrescListArr1[13];
		    var ParaArr = PrescListArr[0].split(String.fromCharCode(2));
            AddCopyItemToList(ParaArr);
		}
	});
}
function PrescCookDecoctionClick(e,value){
	setTimeout(function(){
		SetPrescAppenItemQty();
	})
}
function DrugAndQtyEntryModeChange(e,value){
   var DrugAndQtySplit = 0;
   var id=e.target.id;
   if (id=="DrugAndQtyYQ"){
       if (value){
           $HUI.checkbox("#DrugAndQtySplit").setValue(false);
       }else{
	       $HUI.checkbox("#DrugAndQtySplit").setValue(true);
	       DrugAndQtySplit=1;
	   }
   }else{
       if (value){
           $HUI.checkbox("#DrugAndQtyYQ").setValue(false);
           DrugAndQtySplit=1;
       }else{
	       $HUI.checkbox("#DrugAndQtyYQ").setValue(true);
	   }
   }
   $.m({
	    ClassName:"web.DHCDocConfig",
	    MethodName:"SaveConfig1",
	    Node:"CMDrugAndQtySplit",
	    Node1:session['LOGON.USERID'], 
	    NodeValue:DrugAndQtySplit
	},function(val){
	});
}
function ClearClickHandler(){
	
	deleteallrow()
	Add_CMOrdEntry_row();
	/*
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
			ChangeRowStyle1(i,j,false);
		}
	}
	*/
	PageLogicObj.IsARCOSFormula=0;
	PageLogicObj.m_ARCOSRowId="";
	SetFocusColumn("OrderName1",1);
	var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"SetUserCMUnSaveData",
		dataType:'text',
		wantreturnval:0,
		Name:SessionFieldName, 
		Value:""
	},false);
	PageLogicObj.PractiacRowStr=""
	SetScreenSum();
}


function deleteallrow(){
	var rowids = $('#CMOrdEntry_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
      var rowid=rowids[i]
      $('#CMOrdEntry_DataGrid').delRowData(rowid);
    }
}
function checkIsExistOtherOrd(){
	var Count=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
			if (OrderARCIMRowid!=""){
				Count++;
			}
			ChangeRowStyle1(i,j,true);
		}
	}
	return Count;
}
function ChangeRowStyle1(Row,Col,disabled){
    if(disabled){
		if (GlobalObj.FormulaCanAppendItem=="0"){
			$("input[id*='_OrderName']").attr("readonly","readonly");
			if (GlobalObj.FormulaCanChangeDose=="0") {
				$("input[id*='_OrderDoseQty']").attr("readonly","readonly");
			}
		}else{
			$("#"+Row+"_OrderName"+Col).attr("readonly","readonly")
	        if (GlobalObj.FormulaCanChangeDose=="0") {
				$("#"+Row+"_OrderDoseQty"+Col).attr("readonly","readonly")
			}
		}
    }else{
	    if (GlobalObj.FormulaCanAppendItem=="0"){
			$("input[id*='_OrderName']").removeAttr("readonly");
			$("input[id*='_OrderDoseQty']").removeAttr("readonly");
		}else{
	        $("#"+Row+"_OrderName"+Col).removeAttr("readonly");
	        $("#"+Row+"_OrderDoseQty"+Col).removeAttr("readonly");
		}
    }
    
    
}
function DisableDeleteButton(Disable){
    var delObj = document.getElementById("Delete");
    if ((delObj) && (Disable == "1")) {
        delObj.disabled = true;
        delObj.onclick = "";
        if (tsc['Update']) { websys_sckeys[tsc['Delete']] = ""; }
    }
    if ((delObj) && (Disable == "0")) {
        delObj.disabled = false;
        delObj.onclick = DeleteClickHandler;
        if (tsc['Delete']) { websys_sckeys[tsc['Delete']] = DeleteClickHandler; }
    }
}
function AddCopyItemToList(ParaArr){
	SetTimeLog("AddCopyItemToList","start");
	var OrderARCOSRowid="";
	var OrdParamsArr=new Array();
	new Promise(function(resolve,rejected){
		CheckDiagnose("R",resolve);
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return;
			//将多列医嘱信息合并到一个对象里面
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var Para1Str=ParaArr[i];
						var para1Arr = Para1Str.split("!")
						var Para = para1Arr[2];
						OrderARCOSRowid = Para.split("^")[6];
						if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
							OrderARCOSRowid="";
						}
						CheckFormulaCanAppendItem(OrderARCOSRowid,resolve);
					}).then(function(rtn){
						return new Promise(function(resolve,rejected){
							if (rtn) {
								Para1Str=ParaArr[i];
								para1Arr = Para1Str.split("!")
								icode = para1Arr[0];
								seqno = para1Arr[1];
								Para = para1Arr[2];
								var ItemOrderType = para1Arr[3];
								OrderARCOSRowid = Para.split("^")[6]; //para1Arr[8];
								if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
									OrderARCOSRowid="";
								}
								if (OrderARCOSRowid!=""){
									PageLogicObj.IsARCOSFormula = $.cm({
										ClassName:"web.UDHCPrescript",
										MethodName:"IsARCOSFormula",
										dataType:"text",
										ARCOSRowid:OrderARCOSRowid
									},false);
									PageLogicObj.m_ARCOSRowId=OrderARCOSRowid;
								}
								var ITMRowId=mPiece(Para, "^", 13);
								OrdParamsArr[OrdParamsArr.length]={
									OrderARCIMRowid:icode,
									ParamS:Para,
									OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
									ITMRowId:ITMRowId
								};
								resolve();
							}else if(OrdParamsArr.length>0){
								callBackExecFun();
							}
						})
					}).then(function(){
						i++;
						if ( i < ParaArr.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
					var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
					var GroupList=[];
					for(var i=1;i<=rows;i++){
						for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
						   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
						   if (OrderARCIMRowid!=""){
							   GroupList.push(i+"^"+j);
						   }
						}
					}
					if (GroupList.length>0){
			        	$.messager.alert("提示","协定处方不允许和普通药品混开!","info",function(){
			            	for (var i=0;i<GroupList.length;i++) {
			                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
			                }
			                FocusRowIndex=1;
			                FocusGroupIndex=1;
			                resolve();
			            });
			        }else{
			            resolve();
			        }
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})
	}).then(function(RtnObj){
		if (RtnObj==true){
			setTimeout(function(){ 
				SetScreenSum();
		     }, 100); 
		}else{
			PageLogicObj.IsARCOSFormula=0;
		}
	})
}
function FindNullCell(){
	var amount=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1; i<=rows; i++){
		var Row=i;
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
			var OrderItemRowid=$("#"+i+"_OrderItemID"+j+"").val(); 
			if ((OrderARCIMRowid=="")&&(OrderItemRowid=="")){
				var FocusCellName="OrderName"+j+"z"+i;
				FocusRowIndex=i;
				FocusGroupIndex=j;
  			    return true;
			}
		}
	}
	FocusRowIndex=Add_CMOrdEntry_row()
	FocusGroupIndex=1;
	return true;
}
function NewClickHandler(){
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
			ChangeRowStyle1(i,j,false); 
		}
	}
	var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"SetUserCMUnSaveData",
		dataType:'text',
		wantreturnval:0,
		Name:SessionFieldName, 
		Value:""
	},false);
	//ReloadFrame();
	ReloadFrameData();
	SetScreenSum();
}
function ReloadFrame() {
	window.location.reload();
}
function headerDblClick(){
	if(GlobalObj.lookupListComponetId != ""){	
		$.m({
		    ClassName:"web.SSGroup",
		    MethodName:"GetAllowWebColumnManager",
		    Id:session['LOGON.GROUPID']
		},function(flag){
			if (flag==1) websys_lu('../csp/websys.component.customiselayout.csp?ID='+GlobalObj.lookupListComponetId+'&CONTEXT=K'+GlobalObj.ListColSetCls+'.'+GlobalObj.ListColSetMth+'.'+GlobalObj.XCONTEXT+"&GETCONFIG=1"+"&DHCICARE=2",false);
		});
	}
}
function Delete_CMOrdEntry_row(){
	if ($("#Delete_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
	if ((FocusGroupIndex==0)||(FocusRowIndex==0)){
		$.messager.alert("提示","请选择要删除的记录");  
		return false;
	}
	var OrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        PageLogicObj.IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (PageLogicObj.IsARCOSFormula=="1"){
	        var OrderName = $("#"+FocusRowIndex+"_OrderName"+FocusGroupIndex+"").val(); 
	        $.messager.alert("提示",OrderName+"属于协定处方内的医嘱,不能清除!");
	        return false;
	    }
    }
    $.messager.confirm('确认对话框', '确定删除选中的记录吗？', function(r){
		if (r){
		    if((FocusGroupIndex!=0)&&(FocusRowIndex!=0)){
				ClearGroupData(FocusRowIndex,FocusGroupIndex);
			}
			SetScreenSum(); //删除后同步计算金额
			return websys_cancel();	
		}
	});
}
///保存为医嘱套
var ARCOSArcIMRowIdStr="";
function SaveToArcos_Click(){
	ARCOSArcIMRowIdStr=GetArcimStr()
	if (ARCOSArcIMRowIdStr==""){
		$.messager.alert("提示", "没有需要保存为医嘱套的医嘱!");
		return false;
	}
	UDHCOEOrderDescSetLink();
}
function SaveItemToARCOS(RtnStr){
	CloseDialog("CMARCOSMan");
	if (RtnStr=="") return false;
	var ArcosRowid=RtnStr.split("^")[0];
	if (ArcosRowid!=""){
		AddTOArcosARCIM(ArcosRowid,ARCOSArcIMRowIdStr);
	}else{
		$.messager.alert("提示", "保存失败!");
		return false;
	}
}
function GetArcimStr(){
	var ArcimStr="",OrderItem="";
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
		   if (OrderARCIMRowid!=""){
				var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
				var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                var PHCDoseUOMRowid=OrderHiddenPara.split(String.fromCharCode(3))[10];
			    OrderItem=OrderARCIMRowid+String.fromCharCode(1)+OrderDoseQty+String.fromCharCode(1)+OrderPhSpecInstr+String.fromCharCode(1)+PHCDoseUOMRowid;
				if (ArcimStr==""){
					ArcimStr=OrderItem
				}else{
					ArcimStr=ArcimStr+"^"+OrderItem
				}
		   }
	    }
	}
	return ArcimStr;
}
///插入医嘱套名称
function UDHCOEOrderDescSetLink(){
	websys_showModal({
		url:"udhcfavitem.edit.new.csp?TDis=1&CMFlag=Y",
		title:'医嘱套维护',
		width:screen.availWidth-100,height:screen.availHeight-200,
		SaveItemToARCOS:SaveItemToARCOS
	});
}
///对应的医嘱套医嘱保存
function AddTOArcosARCIM(Arcosrowid,ArcimStr){
     if(Arcosrowid==""){return false;}
     var ArcimStrArray=ArcimStr.split("^");
     for (var i=0;i<ArcimStrArray.length;i++){
	     var OrderARCIMRowid=mPiece(ArcimStrArray[i],String.fromCharCode(1),0);
	     var OrderDoseQty=mPiece(ArcimStrArray[i],String.fromCharCode(1),1);
	     var OrderPhSpecInstr=mPiece(ArcimStrArray[i],String.fromCharCode(1),2);
	     var PHCDoseUOMRowid=mPiece(ArcimStrArray[i],String.fromCharCode(1),3);
	     var ret = $.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertItem",
			dataType:"text",
			ARCOSRowid:Arcosrowid, ARCIMRowid:OrderARCIMRowid, 
			ItemQty:"", ItemDoseQty:OrderDoseQty, 
			ItemDoseUOMID:PHCDoseUOMRowid, ItemFrequenceID:"", 
			ItemDurationID:"", ItemInstructionID:"", 
			ItmLinkDoctor:"", remark:OrderPhSpecInstr, DHCDocOrderTypeID:"", 
			SampleId:"", ARCOSItemNO:"", OrderPriorRemarksDR:"", DHCDocOrderRecLoc:"", ExpStr:""
		},false);
	 }
	 $.messager.popover({msg: '保存成功！',type:'success'});
	 return false;	
}
function UpdateClickHandler() {
	if ($("#Update").hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn("Update",true);
	if (typeof UpdateObj == "undefined") UpdateObj={};
	$.extend(UpdateObj, { UpdateFlag: false});
	new Promise(function(resolve,rejected){
		if (GlobalObj.HLYYInterface==1){
			try{
				HYLLUpdateClick_HLYY(resolve);
			}catch(e){
				$.messager.confirm('确认对话框', "合理用药系统异常:"+e.message+"<br/>请联系信息科!若确认审核医嘱请点击【确定】", function(r){
					if (r) {
						resolve(true);
					}else{
						DisableBtn("Update",false);
					}
				})
			}
		}else{
			resolve(true);
		}
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) {
				DisableBtn("Update",false);
				return false;
			}
			GetOrderDataOnAdd(resolve);
		})
	}).then(function(OrderItemStr){
		return new Promise(function(resolve,rejected){
			if (OrderItemStr=="") {
				$.messager.alert("提示", t['NO_NewOrders']);
				DisableBtn("Update",false);
				return false;
			}
			$.extend(UpdateObj, { OrderItemStr: OrderItemStr});
			//电子签名
			$.extend(UpdateObj, { ContainerName: "",caIsPass:0});
			var CAInit = $.cm({
				ClassName:"web.DHCDocSignVerify",
				MethodName:"GetCAServiceStatus",
				dataType:"text",
				LocID:session['LOGON.CTLOCID'], UserID:session['LOGON.USERID']
			},false);
			if (CAInit==1){  
				if (GlobalObj.IsCAWin=="") {
					$.messager.alert("提示","请先插入KEY!","info",function(){
						DisableBtn("Update",false);
					});
					return false;
				}
				//todo此处需要基础平台修改弹出方式
				//判断当前key是否是登陆时候的key
		        var resultObj = dhcsys_getcacert();
		        result = resultObj.ContainerName;
		        if ((result == "") || (result == "undefined") || (result == null)) {
			        $.messager.alert("提示","请检查KEY信息是否正确");
		            return false;
		        }
		        $.extend(UpdateObj, { ContainerName: result,caIsPass:1});
		        resolve();
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//保存前的后台审核,对于医嘱录入非必须前端处理的判断逻辑可以在此处理
			CheckBeforeSaveToServer(UpdateObj.OrderItemStr,resolve);
		})
	}).then(function(ret){
		return new Promise(function(resolve,rejected){
			if (ret.SuccessFlag == false) {
		        DisableBtn("Update",false);
		        return websys_cancel();
		    }
		    if (ret.isAfterCheckLoadDataFlag== true){
				return new Promise(function(resolve,rejected){
					GetOrderDataOnAdd(resolve);
				}).then(function(OrderItemStr){
					if (OrderItemStr == "") {
					    $.messager.alert("提示", t['NO_NewOrders']);
					    DisableBtn("Update",false);
					    return websys_cancel();
				    }
					$.extend(UpdateObj, { OrderItemStr: OrderItemStr});
					resolve();
				})
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//需要签名密码
			if (GlobalObj.CMOrdDirectSave=="1"){ 
				ShowInputPinNum(resolve);
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			// 实习生审核医嘱
		    if (GlobalObj.practiceFlag=="1"){
			    var UpdatePracticeRtn=InsertPriceAdd();
				if (UpdatePracticeRtn){
				    DisableBtn("Update",false);
				    NewClickHandler();
				    AfterUpdate();
		    		return true;
				}else{
					DisableBtn("Update",false);
				    return false
				}
			    return;
			}
			var OEOrdItemIDs=SaveOrderItems(UpdateObj.OrderItemStr);
			if (OEOrdItemIDs=="100") {
				$.messager.alert("提示",t['Fail_SaveOrder'],"info",function(){
					DisableBtn("Update",false);
				});
				return false;
			}
			$.extend(UpdateObj, { OEOrdItemIDs: OEOrdItemIDs});
			if (UpdateObj.caIsPass==1) SaveCASign(UpdateObj.ContainerName, OEOrdItemIDs, "A");
			//已在保存医嘱时后台调用,此处无须重复调用
			//录入医嘱的时候判断到达状态;若未到达则置为到达
			$.extend(UpdateObj, { ExistFlag: 0,StopPrescNo:"",UpdateFlag:true});
			if (GlobalObj.PAAdmType!="I"){
				////审核时提示，是否要删除原处方
				var selVal=$('#PrescList').combobox("getValue");
				if (selVal!=""){
					var PrescNo=selVal.split("^")[0];
					if (PrescNo!=""){
						var rtn = $.cm({
							ClassName:"web.UDHCPrescript",
							MethodName:"CheckStopPrescNo",
							dataType:"text",
							PrescNo:PrescNo, UserID:session['LOGON.USERID'],EpisodeID:GlobalObj.EpisodeID
						},false);
						var rtnArr=rtn.split("^")
						if (rtnArr[0]==0){
							$.extend(UpdateObj, { StopPrescNo: PrescNo});
						}
					}
				}
			}
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (UpdateObj.StopPrescNo!=""){
				$.messager.confirm('提示', UpdateObj.StopPrescNo+"-是否停止原处方号？", function(r){
					if (r){
					    StopPrescList(UpdateObj.StopPrescNo,function(){
								$.extend(UpdateObj, { ExistFlag: 1});
								resolve();
						});
					}else{
						resolve();
					}
				});
			}else{
				resolve();
			}
		})
	}).then(function(){
		DisableBtn("Update",false);
		//选择诊断处方关联信息
		OpenSelectDia(GlobalObj.EpisodeID,UpdateObj.OEOrdItemIDs);
		if (UpdateObj.ExistFlag==0) {
			if (GlobalObj.StoreUnSaveData==1) NewClickHandler();
			SaveOrderToEMR();
		}
	})
	function ShowInputPinNum(callBackFun){
		$.messager.prompt('提示', '请输入密码', function(PinNumber){
			if ((PinNumber!="")&&(PinNumber!=undefined)){
				var ret = $.cm({
					ClassName:"web.DHCOEOrdItem",
					MethodName:"PinNumberValid",
					dataType:"text",
					UserID:session['LOGON.USERID'], PinNumber:PinNumber
				},false);
				if (ret == "-4") {
					$.messager.alert("提示",t['Wrong_PinNumber'],"info",function(){
						ShowInputPinNum(callBackFun);
					});
	                return false;
	            }else{
		            callBackFun();
		        }
			}
			if (PinNumber==""){
				$.messager.alert("提示","请输入密码!","info",function(){
					ShowInputPinNum(callBackFun);
				});
				return false;
			}
			if (PinNumber==undefined){
				DisableBtn("Update",false);
				return false;
			}
	    });
	    $(".messager-input").focus();
	    $(".messager-input")[0].type="password";
	}
}
function StopPrescList(StopPrescNo,callBackFun){
	var CAObj={
		ContainerName:"",
		caIsPass:""
	}
	new Promise(function(resolve,rejected){
		//电子签名
		var CAInit = $.cm({
			ClassName:"web.DHCDocSignVerify",
			MethodName:"GetCAServiceStatus",
			dataType:"text",
			LocID:session['LOGON.CTLOCID'], UserID:session['LOGON.USERID']
		},false);
		if (CAInit==1){  
			if (GlobalObj.IsCAWin=="") {
				$.messager.alert("提示","请先插入KEY");
				return false;
			}
			//todo 此处需要基础平台配合修改弹框模式
			//判断当前key是否是登陆时候的key
	        var resultObj = dhcsys_getcacert();
	        result = resultObj.ContainerName;
	        if ((result == "") || (result == "undefined") || (result == null)) {
		        $.messager.alert("提示","请检查KEY信息是否正确");
	            return false;
	        }
	        $.extend(CAObj, { ContainerName: result,caIsPass:1});
	        resolve();
		}else{
			resolve(CAObj);
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var rtn = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"StopPrescNo",
				dataType:"text",
				PrescNo:StopPrescNo,UserID:session['LOGON.USERID']
			},false);
			var rtnArr=rtn.split("^")
			if (rtnArr[0]!=0){
				var Message=rtnArr[1];
				switch(rtnArr[1])
				{
					case "-1" :
						Message="用户不是医护人员!";
						break;
					case "-2" :
						Message="Paid医嘱不能停止";
						break;
					case "-4" :
						Message="签名密码错误";
						break;
					case "-5" :
						Message="原医嘱不是核实状态";
						break;
					case "-300":
						Message="已执行医嘱，不可以停!";
						break;
					case "-200":
						Message="停止医嘱存在已经收费的医嘱,请重新选择!";
						break;
					default:
					 Message="其它错误"; 
				}
				$.messager.alert("提示","停止失败："+Message+rtnArr[1],"info",function(){
					if (callBackFun) callBackFun();
				})
			}else{
				var StopOrdList=rtnArr[1];
				$.messager.popover({msg: '停止成功!',type:'success'});
				//$.messager.alert("提示","停止成功!","info",function(){
					if (CAObj.caIsPass==1) var ret=SaveCASign(CAObj.ContainerName,StopOrdList,"S");
					if (callBackFun) callBackFun();
					NewClickHandler();
					SaveOrderToEMR();
				//});
			}
		})
	})
}
function SaveCASign(ContainerName,OrdList,OperationType) {    
    try{
	  if (ContainerName=="") return false;
	  //1.批量认证
		var CASignOrdStr="";
		var TempIDs=OrdList.split("^");
			var IDsLen=TempIDs.length;
			for (var k=0;k<IDsLen;k++) {
				if (OperationType=="A") {
					var TempNewOrdDR = TempIDs[k].split("*");
					if (TempNewOrdDR.length < 2) continue;
				    var newOrdIdDR = TempNewOrdDR[1];
				}
				if (OperationType=="S") {
					var TempNewOrdDR=TempIDs[k].split("&");
					if (TempNewOrdDR.length <=0) continue;
					var newOrdIdDR=TempNewOrdDR[0];
				}
				if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
				else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;		
		  }
		var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
		var CASignOrdArr=CASignOrdStr.split("^");
		for (var count=0;count<CASignOrdArr.length;count++) {
		    var CASignOrdId=CASignOrdArr[count];
			var OEORIItemXML = $.cm({
				ClassName:"web.DHCDocSignVerify",
				MethodName:"GetOEORIItemXML",
				dataType:"text",
				newOrdIdDR:CASignOrdId,
				OperationType:OperationType
			},false);
			var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
			for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
				if (OEORIItemXMLArr[ordcount]=="")continue;
			var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
			var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
				var OEORIItemXMLHash=HashData(OEORIItemXML);
				if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
				else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
				var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
				if(SignedOrdStr=="") SignedOrdStr=SignedData;
				else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
				if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
			} 
		}
		if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
		if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
		//获取客户端证书
	    var varCert = GetSignCert(ContainerName);
	    var varCertCode=GetUniqueID(varCert);
	    if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
	    	var ret = $.cm({
				ClassName:"web.DHCDocSignVerify",
				MethodName:"InsertBatchSignRecord",
				dataType:"text",
				CurrOrderItemStr:CASignOrdValStr,
				UserID:session['LOGON.USERID'],
				OperationType:OperationType,
				OrdItemsHashVal:SignOrdHashStr,
				MainSignCertCode:varCertCode,
				MainSignValue:SignedOrdStr,
				ExpStr:""
			},false);
			if (ret!="0") {$.messager.alert("提示","数字签名没成功!");return false;}
		}else{
		   $.messager.alert("提示","数字签名错误");
		   return false;
	    } 
		return true;
	}catch(e){alert(e.message);return false;}
}
function SaveOrderItems(OrderItemStr){
	var DoctorRowid=GlobalObj.LogonDoctorID;
    var UserAddRowid=session['LOGON.USERID'];
    var UserAddDepRowid=session['LOGON.CTLOCID']; 
    var ret = $.m({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"SaveOrderItemsCM",
		Adm:GlobalObj.EpisodeID,
		OrdItemStr:OrderItemStr,
		User:UserAddRowid,
		Loc:UserAddDepRowid,
		Doc:DoctorRowid
	},false);
	return ret;
}
function GetOrderDataOnAdd(CallBackFun){
	var OrderItemStr="",OrderItemArr=new Array();
	var PrescDurFactor=GetDurFactor();
	var ColArr=[];
	var ColArrIndex=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
		   if (OrderARCIMRowid!=""){
			   	var OrderName=GetCellData(i,j,"OrderName");
			    var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
			    var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text(); //GetCellData(i,j,"OrderPhSpecInstr");
			    var OrderPrice=GetCellData(i,j,"OrderPrice");
			    var OrderItemSum=GetCellData(i,j,"OrderSum");
				OrderQtySum=parseFloat(OrderDoseQty)*parseFloat(PrescDurFactor);
				OrderQtySum=OrderQtySum.toFixed(4);
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
                var PHCDoseUOMRowid=OrderHiddenPara.split(String.fromCharCode(3))[10];
                var OrderDoseUOMRowid=PHCDoseUOMRowid;
                if (OrderDoseQty==""){OrderDoseUOMRowid=""};
                var INCIPackCombStr="";
                var cellPosi=i+";"+j; //单元格位置
                var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns");
				var OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderPhSpecInstr +"^"+""+"^"+ARCIMARCOSRowid+"^"+INCIPackCombStr+"^"+cellPosi+"^"+OrderHiddenPara+"^"+OrderCoverMainIns+"^^^^";
                OrderItemArr.push(OrderItem);
                var colPromis=new Promise(function(resolve,rejected){
					CheckINCIPackSum(j,Row,"0",resolve)
				}).then(function(INCIPackCombStr){
					var OrderItem=OrderItemArr[ColArrIndex];
					var tmpOrderItemArr=OrderItem.split("^");
					var cellPosi=tmpOrderItemArr[7];
					var cellPosiArr=cellPosi.split(";");
					var OrderDoseQty=GetCellData(cellPosiArr[0],cellPosiArr[1],"OrderDoseQty");
					tmpOrderItemArr[1]=OrderDoseQty;
					tmpOrderItemArr[6]=INCIPackCombStr;
					ColArrIndex=ColArrIndex+1;
					return tmpOrderItemArr.join("^");
				})
                ColArr.push(colPromis);
		   }
	    }
	}
	Promise.all(ColArr)
	.then(function(OrderItemObj){
		//处方信息相关
		var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
		var PrescDurRowid=$('#PrescDuration').combobox("getValue");
		var PrescDurFactor=GetDurFactor();
		var PrescInstrRowid=$('#PrescInstruction').combobox("getValue");
		var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
		var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
	    var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
	    var PrescCookDecoction="N";
	    //var cbox=$HUI.checkbox("#PrescCookDecoction");
	    //if (cbox.getValue()) PrescCookDecoction="Y"; //是否代煎
        var PrescNotes=$('#PrescNotes').val();
        var PrescEmergency=$("#PrescUrgent").checkbox('getValue')?"Y":"N"; //是否加急
        var PrescStartDate="",PrescStartTime="",ARCOSRowId="";
		//开始日期,如果是出院/死亡后费用调整,开始日期必须是出院日期时间
		if (GlobalObj.CurrentDischargeStatus=="B") {
			PrescStartDate=GlobalObj.DischargeDate;
			PrescStartTime=GlobalObj.DischargeTime;
		}else{
			PrescStartDate="";
		}
		var AddLongOrder="";
		if (GlobalObj.PAAdmType=="I"){
			AddLongOrder=$('#AddLongOrderList').combobox('getValue');
			if (!AddLongOrder) AddLongOrder="";
		}
		var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
		var DetailsArr=CMPrescTypeDetails.split("#");
		var CMPrescTypeCode=DetailsArr[0];		
		var IPCookModeFeeNoAutoAdd=DetailsArr[9];
	    var CNMedCookModeFeeItemRowid=DetailsArr[10];
	    var CNMedAppendItem=DetailsArr[11];
	    var CMPrescTypeLinkFeeStr=DetailsArr[17];
	    var PrescAppenItemQty=$('#PrescAppenItemQty').val();
	    var PrescCookDecoction=$('#CookModelist').combobox('getValue');
	    var EmConsultItm=GlobalObj.EmConsultItm;	///会诊子表ID
	    
		var PrescStr=OrderPriorRowid+"^"+PrescDurRowid+"^"+PrescInstrRowid+"^"+PrescFreqRowid+"^"+PrescCookDecoction+"^"+PrescOrderQty+"^"+OrderRecDepRowid+"^"+GlobalObj.OrderBillTypeRowid+"^"+PrescNotes+"^"+PrescEmergency+"^"+PrescStartDate+"^"+PrescStartTime+"^"+PageLogicObj.m_ARCOSRowId;					
		var PrescWeight=GetPrescWeight();
		var PrescStr=PrescStr+"^"+PrescWeight+"^"+AddLongOrder+"^"+CMPrescTypeCode+"^"+PageLogicObj.PractiacRowStr+"^"+PrescAppenItemQty+"^"+GlobalObj.AntCVID+"^"+EmConsultItm;
		//处方医嘱明细
		var OrderItemStr="";
		for (var i=0;i<OrderItemObj.length;i++) {
			if (OrderItemObj[i]=="") continue;
			if (OrderItemStr=="") {
				OrderItemStr=OrderItemObj[i];
			}else{
				OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItemObj[i];
			}
		}
		if (OrderItemStr=="") {
			CallBackFun("");
			return;
		}
		//材料费 
		if ((OrderItemStr!="")&&(CNMedAppendItem!="")){
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			if (PrescAppenItemQty==""){PrescAppenItemQty=0}
			if (PrescAppenItemQty!=0){
				var OrderItem=CNMedAppendItem+"^"+PrescAppenItemQty + "^" + "" + "^" + "" +"^"+""+"^^^^^^^^^CMPTAM";
				OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem;
			}
		}
		//代煎费--已弃用
		/*if ((GlobalObj.PAAdmType!="I")||((GlobalObj.PAAdmType=="I")&&(IPCookModeFeeNoAutoAdd=="1"))){
			if ((OrderItemStr!="")&&(CNMedCookModeFeeItemRowid!="")){
				if (PrescCookDecoction=="Y") {
					var OrderItem=CNMedCookModeFeeItemRowid + "^" + "1" + "^" + "" + "^" + ""+"^"+"1"+"^"+"";
					OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem;
				}
			}
		}*/
		
		//处方类型关联其他费用列表 
		if (CMPrescTypeLinkFeeStr!=""){
			for (var i=0;i<CMPrescTypeLinkFeeStr.split("^").length;i++){
				var OrderItem=CMPrescTypeLinkFeeStr.split("^")[i] + "^" + "1" + "^" + "" + "^" + ""+"^"+""+"^^^^^^^^^CMPTAOF";
				OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem;
			}
		}
		if (OrderItemStr!=""){OrderItemStr=PrescStr+String.fromCharCode(2)+OrderItemStr};
		CallBackFun(OrderItemStr);
	})
}
function CheckBeforeUpdate(){
	if (GlobalObj.PAAdmType=="E"){
 		var warning=tkMakeServerCall("web.DHCDocViewDataInit","GetOrdEntryWarning",GlobalObj.EpisodeID)
 		if (warning!="") {
	 		$.messager.alert("提示",warning);
	 		return false;
	 	}
	}	
	var XYPrescCount=0;
	var ZCYPrescCount=0;
	var CYPrescCount=0;
	var NewRows=0;
	var CNOrderDur="";
	var FindCNMedCl=false;
	var NeedCheckDeposit=false;         //检查押金余额
	var Amount=0;
	var FindSelfCookPHSpecInstr=false;  //找到只能自煎的用法
    try{
		var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
		if (!CheckComboValue("RecLoc","id")) return false;
				
		var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
		if (!CheckComboValue("PrescInstruction","HIDDEN")) return false;
			
		var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
		if (!CheckComboValue("PrescFrequence","PHCFRRowid")) return false;
		
		var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
		if (!CheckComboValue("PrescDuration","PHCDURowid")) return false;
		var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
		if (PrescOrderQty==""){
			dhcsys_alert("一次用量为空");
			return false;
		}
		var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
		var PrescAppenItemQty=$('#PrescAppenItemQty').val();
		if (PrescAppenItemQty!=""){
			if (!isNumber(PrescAppenItemQty)){
				dhcsys_alert(PrescAppenItemDesc+t['Not_Number']);
				return false;
			}
			if(+PrescAppenItemQty<0){
	            dhcsys_alert("药箅子数不能为负!");
                return false;
            }
		}else{
			PrescAppenItemQty=0;
	    }
	    var PrescDurFactor=GetDurFactor();
		//加工方式限定规则(项目用)
		var myrtn=CheckPrescBound();
		if (!myrtn) return false;
		//只能自煎的用法字符串,因为暂时不具有通用性(北京中医院需求),只在message定义,以"^"为隔符
		var SelfCookPHSpecInstr=t['SelfCookPHSpecInstr'];
		var AllowEntryDecimalItemCatStr = "^" + GlobalObj.AllowEntryDecimalItemCat + "^";
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
        for (var i=1; i<=rows; i++){
	        var Row=i;
			for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
				var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val();
				if (OrderARCIMRowid!=""){
					var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
					var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();  
					var OrderPrice=$("#"+i+"_OrderPrice"+j+"").val(); 
					var OrderItemSum=$("#"+i+"_OrderSum"+j+"").val(); 
					var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").val(); 
					Amount=Amount+parseFloat(OrderItemSum);
					if (OrderDoseQty==""){
						dhcsys_alert(OrderName+t['NO_DoseQty']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					if ((!isNumber(OrderDoseQty))||(parseFloat(OrderDoseQty)==0)){
						dhcsys_alert(OrderName+t['Not_Number']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					if (OrderDoseQty < 0) {
						dhcsys_alert(OrderName + "数量不能为负!");
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
                        return false;
                    }
                    if (+OrderDoseQty > 9999) {
	                    dhcsys_alert(OrderName + "数量不能超过9999!");
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
                        return false;
	                }
                    var SubCatID = tkMakeServerCall("web.DHCDocOrderEntry","GetARCItemSubCatIDBroker",'','',OrderARCIMRowid);
				    if (((AllowEntryDecimalItemCatStr.indexOf("^" + SubCatID + "^")) == -1)&&(OrderDoseQty.indexOf(".")>=0)) {
					    dhcsys_alert(OrderName + "数量不能是小数!");
                        return false;
				    }
                    if ((OrderPrice == "") || (OrderPrice < 0)) {
	                    dhcsys_alert(OrderName + "价格无效,不允许审核");
                        return false;
                    }
                    var CheckforlocStr=$.cm({
						ClassName:"web.DHCSTINTERFACE",
						MethodName:"GetIncilQtyList",
						dataType:"text",
						ArcID:OrderARCIMRowid,
						recLoc:OrderRecDepRowid
					},false);
					var OrderRecDep=$("#RecLoc").combobox('getText'); 
					if (CheckforlocStr==""){dhcsys_alert(OrderName+"在"+OrderRecDep+"没有可用库存");return false;}
                   var INCIPackCombStr =CheckINCIPackSum(j, Row,"0");
					if (INCIPackCombStr==""){dhcsys_alert("请选择合适的组合数");return false;}
					var Check = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckStockEnoughByInc",
						dataType:"text",
						INCIPackCombStr:INCIPackCombStr,
						RecLoc:OrderRecDepRowid,
						EpisodeType:"",ExpStr:"",DurFactor:PrescDurFactor
					},false);
					if (Check=='0') {
						dhcsys_alert(OrderName+t['QTY_NOTENOUGH']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					/*Qty=parseFloat(OrderDoseQty)*parseFloat(PrescDurFactor);
					var Check = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckStockEnough",
						dataType:"text",
						arcim:OrderARCIMRowid,
						Qty:Qty,
						RecLoc:OrderRecDepRowid,
						EpisodeType:"",ExpStr:""
					},false);
					if (Check=='0') {
						$.messager.alert("提示",OrderName+t['QTY_NOTENOUGH'],"info",function(){
							FocusRowIndex=i;
							FocusGroupIndex=j;
							SetFocusColumn("OrderDoseQty"+j,Row);
						});
						return false;
					}*/
					if (CheckDurationPackQty(j,Row)==false){
						SetFocusColumn("OrderDoseQty"+j,Row);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						return false;
					}
					//判断医嘱项中的门急诊限制
					var CheckArcimTypeStr = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckArcimType",
						dataType:"text",
						ArcimRowid:OrderARCIMRowid, AdmID:GlobalObj.EpisodeID, AdmTypeIN:""
					},false);
  					if (CheckArcimTypeStr!=""){dhcsys_alert(OrderName+CheckArcimTypeStr);return false;}
					if ((SelfCookPHSpecInstr!="")&&(OrderPhSpecInstr!="")){
						SelfCookPHSpecInstr="!"+SelfCookPHSpecInstr+"!";
						OrderPhSpecInstr="!"+OrderPhSpecInstr+"!";
						if (SelfCookPHSpecInstr.indexOf(OrderPhSpecInstr)!=-1) {FindSelfCookPHSpecInstr=true;}
					}
					if (CheckProtocolPackSum(j,Row)==false) {
						SetFocusColumn("OrderDoseQty"+j,Row);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						return false;
					}
					NewRows=NewRows+1;
					//如果只开了自备药医嘱或零价格医嘱则不用判断欠费
					if ((OrderPriorRowid!=GlobalObj.OMOrderPriorRowid)&&(OrderPriorRowid!=GlobalObj.OMSOrderPriorRowid)&&(parseFloat(OrderPrice)!=0)) {NeedCheckDeposit=true}
				}
			}
		}
		if (NeedCheckDeposit){
			var amount=$("#ScreenBillSum").val();
			if (!CheckDeposit(amount,"")){
				return false;
			}
	    }
		Amount=Amount.toFixed(2);
		if (!CheckBillTypeSum(Amount)){
			var PrescCheck=dhcsys_confirm(t['EXCEED_ADMAMOUNT'],true);
			if (PrescCheck==false){return false;}
		}
		//如果找到须自煎的用法,就将处方改为自煎处方  项目用
		if (FindSelfCookPHSpecInstr){
			var CookModeCode=$('#CookMode').val();
			if ((CookModeCode!="01") &&(GlobalObj.PAAdmType!="I")){
				dhcsys_alert(t['FindSelfCookPHSpecInstr']);
				return false;
			}
		}
		if (NewRows==0){
			dhcsys_alert(t['NO_NewOrders']);
			return false;
		}
		///医保用药控制 TODO 医保控费是否需要更新
		//var ret=CheckInsuCostControl()
		//if (!ret){return false;}
		return true;
	}catch(e){dhcsys_alert(e.message);return false;}
}
function CheckPrescBound(){
	var PrescWeight = GetPrescWeight();
    if (PrescWeight==""){
        dhcsys_alert("没有新开处方!")
        return false;
    }
    var PrescCookDecoction=$("#PrescCookDecoction").checkbox('getValue')?'Y':'';
	//var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	var PrescCookModeDesc=CMPrescTypeKWSel[0].text; //$("#CMPrescType").combobox('getText');
	// 加工方式限定规则
	if (PrescCookDecoction=="Y"){
		var CookModePrescBound = $.cm({
			ClassName:"web.DHCDocOrderEntryCM",
			MethodName:"GetPrescBound",
			dataType:"text",
			PrescTypeCode:CMPrescTypeCode
		},false);
		if (CookModePrescBound!=""){
			var PrescBoundArray=CookModePrescBound.split("^");
			var UomDesc=PrescBoundArray[0];
			var PrescQtyStt=PrescBoundArray[1];
			var PrescQtyEnd=PrescBoundArray[2];
			if (UomDesc=="100G") {
				PrescQtyStt=PrescQtyStt*100;
				PrescQtyEnd=PrescQtyEnd*100;
				if (parseFloat(PrescWeight)<parseFloat(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescWeight)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}else if(UomDesc=="G") {
				if (parseFloat(PrescWeight)<parseFloat(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescWeight)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}else if (UomDesc==t['Dose']){
				if (parseInt(PrescDurFactor)<parseInt(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Dose']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescDurFactor)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Dose']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}
		}	
	}
	return true;
}
function CheckBillTypeSum(Amount){
	if ((GlobalObj.PAAdmType!="O")||(Amount===0)) {return true}	
	//只有在门诊时才存在PrescBillType TAB页
	//旧版一直是空?
	var PrescLimitSum="" //GetPrescLimitSum();
	if (GlobalObj.CheckBillTypeSumMethod!=""){
		var retDetail = $.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"CheckBillTypeSum",
			dataType:"text",
			PAADMRowid:GlobalObj.EpisodeID,
			InsType:GlobalObj.OrderBillTypeRowid,
			PrescLimitSum:PrescLimitSum,
			Amount:Amount,
			PrescLimitType:""
		},false);
		if (retDetail==1) {return false}
	}
	return true
}
function CheckDeposit(amount,arcim){
	if (+amount==0) return true;
    if (GlobalObj.VisitStatus=="P") return true;
    if (GlobalObj.NotDoCheckDeposit==1) return true;
    if (GlobalObj.SupplementMode==1){return true;}
    if ((GlobalObj.PAAdmType != "I") && (GlobalObj.GetStayStatusFlag != 1) && (GlobalObj.GetStayStatusFlag != 2)) { return true }
    
	//CheckIPDeposit 是否进行欠费控制  1控制 0 不控制
	//CheckIPLocDeposit 科室是否进行欠费控制  1 不控制 0控制
	if ((GlobalObj.CheckIPDeposit=="1")&&(GlobalObj.CheckIPLocDeposit=="0")){
		var retDetail = $.cm({
			ClassName:"web.UDHCJFARREARSMANAGE",
			MethodName:"CheckArrears",
			dataType:"text",
			adm:GlobalObj.EpisodeID, str:amount, flag:"OE", loginLocId:""
		},false);
		if (retDetail!=0) {
			var retArray=retDetail.split("^");
			if (retArray[4]=='C'){
				var AlertAmount=retArray[0];
				if (AlertAmount<0) {
					AlertAmount="-"+FormateNumber(AlertAmount.split("-")[1]);
				}else{
					AlertAmount=FormateNumber(AlertAmount);
				}
				if (retArray[5]=='N'){
					dhcsys_alert(t['ExceedDeposit']+AlertAmount);
					return false;
				}else{
					if (arcim!=""){
						var retDetail = $.cm({
							ClassName:"web.UDHCJFARREARSMANAGE",
							MethodName:"CheckOrderE",
							dataType:"text",
							rowid:retArray[2], arcim:arcim, ExecFlag:""
						},false);
						if (retDetail==0){
							dhcsys_alert(t['ExceedDeposit']+AlertAmount);
							return false;
						}
					}
				}
			}
		}
	}
	return true;
}
function CheckDurationPackQty(Column,Row) {
  //if (GlobalObj.PAAdmType!="O") return true;
  var OrderName=GetCellData(Row,Column,"OrderName");
  var OrderHiddenPara=GetCellData(Row,Column,"OrderHiddenPara");
  var OrderMaxQty=mPiece(OrderHiddenPara,String.fromCharCode(3),1);
  var OrderMaxDurFactor=mPiece(OrderHiddenPara,String.fromCharCode(3),0);
  var WarningUseQty=mPiece(OrderHiddenPara,String.fromCharCode(3),8);
  var OrderDoseQty=GetCellData(Row,Column,"OrderDoseQty");
  if ((WarningUseQty>0)&&(parseFloat(OrderDoseQty)>parseFloat(WarningUseQty))) {
	dhcsys_alert(OrderName+"超过药品的极限用量限定:"+WarningUseQty);
	return false;
  }
  if ((OrderMaxQty>0)&&(parseFloat(OrderDoseQty)>parseFloat(OrderMaxQty))) {
  	var ret=dhcsys_confirm(OrderName+t['MedMaxQty']+OrderMaxQty,false);
  	if (ret==false) {return false;}
  }
  if (OrderMaxDurFactor==0) {return true;}
  return true;
}
//垂直移动
function OrdVerticalMove(id){
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn(id,true);
	if(id=="MoveUp_btn"){
		var ListGroupTo=FocusGroupIndex;
		var FocusRowIndexTo=parseInt(FocusRowIndex)-1;
		if(FocusRowIndexTo==0){
			$.messager.alert("提示","不能往上移动!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
	}else{
		var ListGroupTo=FocusGroupIndex;
		var FocusRowIndexTo=parseInt(FocusRowIndex)+1;
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if(FocusRowIndex==rows){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { 
				DisableBtn(id,false);
				return false;
			}
			Add_CMOrdEntry_row();
		}
		
	}
	ChangeCellData(FocusRowIndexTo,ListGroupTo);
	DisableBtn(id,false);
}
//水平移动
function OrdHorizontalMove(id){
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn(id,true);
	if(id=="MoveLeft_btn"){
		var ListGroupTo=parseInt(FocusGroupIndex)-1;
		if(ListGroupTo==0){
			$.messager.alert("提示","不能往左移动!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
		var FocusRowIndexTo=FocusRowIndex;
	}else{
		var ListGroupTo=parseInt(FocusGroupIndex)+1;
		if(ListGroupTo>GlobalObj.ViewGroupSum){
			$.messager.alert("提示","不能往右移动!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
		var FocusRowIndexTo=FocusRowIndex;
	}
	ChangeCellData(FocusRowIndexTo,ListGroupTo);
	DisableBtn(id,false);
}
function ChangeCellData(FocusRowIndexTo,ListGroupTo){
	//交换信息 
	var ListToOrderName=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderName");
	var ListToOrderDoseQty=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseQty");
	var ListToOrderPrice=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderPrice");
	var ListToOrderARCIMID=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderARCIMID");
	var ListToOrderPhSpecInstr=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderPhSpecInstr");
	var ListToOrderHiddenPara=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara");
	var ListToOrderSum=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderSum");
	var ListToOrderDoseUOM=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseUOM");
	var ListToOrderCoverMainIns=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderCoverMainIns");
	//被交换信息
	
	var ListFromOrderName=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderName");
	var ListFromOrderDoseQty=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseQty");
	var ListFromOrderPrice=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderPrice");
	var ListFromOrderARCIMID=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID");
	var ListFromOrderPhSpecInstr=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr");
	var ListFromOrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	var ListFromOrderSum=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderSum");
	var ListFromOrderDoseUOM=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseUOM");
	var ListFromOrderCoverMainIns=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderCoverMainIns");
	
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderName",ListFromOrderName);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseQty",ListFromOrderDoseQty);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderPrice",ListFromOrderPrice);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderARCIMID",ListFromOrderARCIMID);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderPhSpecInstr",ListFromOrderPhSpecInstr);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara",ListFromOrderHiddenPara);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderSum",ListFromOrderSum);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseUOM",ListFromOrderDoseUOM);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderCoverMainIns",ListFromOrderCoverMainIns);
	/*
	var select_id=FocusRowIndexTo+"_OrderPhSpecInstr"+ListGroupTo;
	if (ListFromOrderPhSpecInstr!=""){
		$("#"+select_id).val(ListFromOrderPhSpecInstr);
	}*/

	SetCellData(FocusRowIndex,GroupIndex,"OrderName",ListToOrderName);
	SetCellData(FocusRowIndex,GroupIndex,"OrderDoseQty",ListToOrderDoseQty);
	SetCellData(FocusRowIndex,GroupIndex,"OrderPrice",ListToOrderPrice);
	SetCellData(FocusRowIndex,GroupIndex,"OrderARCIMID",ListToOrderARCIMID);
	SetCellData(FocusRowIndex,GroupIndex,"OrderPhSpecInstr",ListToOrderPhSpecInstr);
	SetCellData(FocusRowIndex,GroupIndex,"OrderHiddenPara",ListToOrderHiddenPara);
	SetCellData(FocusRowIndex,GroupIndex,"OrderSum",ListToOrderSum);
	SetCellData(FocusRowIndex,GroupIndex,"OrderDoseUOM",ListToOrderDoseUOM);
	SetCellData(FocusRowIndex,GroupIndex,"OrderCoverMainIns",ListToOrderCoverMainIns);
	/*var select_id=FocusRowIndex+"_OrderPhSpecInstr"+GroupIndex;
	if (ListToOrderPhSpecInstr!=""){
		$("#"+select_id+" option[value='"+ListToOrderPhSpecInstr+"']").attr("selected", "selected");
	}*/
	
	var OrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        var IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (IsARCOSFormula=="1"){
	        ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,true);
	    }else{
		    ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,false);
		}
    }else{
	    ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,false);
	}
	var OrderHiddenPara=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        var  IsARCOSFormula= $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (IsARCOSFormula=="1"){
	        ChangeRowStyle1(FocusRowIndexTo,ListGroupTo,true);
	    }else{
		    ChangeRowStyle1(FocusRowIndexTo,ListGroupTo,false);
		}
    }else{
	    ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,false);
	}
    
	FocusRowIndex=FocusRowIndexTo;
	FocusGroupIndex=ListGroupTo;
	SetFocusColumn("OrderName"+ListGroupTo,FocusRowIndexTo);
}
function OrdercopyClick(){
	websys_showModal({
		url:'opdoc.oeorder.cmpresclist.csp?EpisodeID='+GlobalObj.EpisodeID,
		title:'草药医嘱复制',
		width:1160,height:592,
		AddCopyItemToListFromQuery:AddCopyItemToListFromQuery
	});
}
//草药处方复制
function AddCopyItemToListFromQuery(ParaArr){
	var OrdParamsArr=new Array();
	new Promise(function(resolve,rejected){
		CheckDiagnose("",resolve);
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return;
			//将多列医嘱信息合并到一个对象里面
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var Para1Str=ParaArr[i];
						var para1Arr = Para1Str.split("!")
						var ArcimARCOSRowId=para1Arr[5];
						if ((typeof ArcimARCOSRowId == "undefined") || (ArcimARCOSRowId == "undefined")) {
							ArcimARCOSRowId="";
						}
						CheckFormulaCanAppendItem(ArcimARCOSRowId,resolve);
					}).then(function(rtn){
						return new Promise(function(resolve,rejected){
							if (rtn) {
								var Para1Str=ParaArr[i];
								var para1Arr = Para1Str.split("!")
								var icode = para1Arr[0];
								var doseqty = para1Arr[1];
								var doseuomrowid=para1Arr[2];
								var PhSpecInstr=para1Arr[3];
								var ArcimARCOSRowId=para1Arr[5];
								if ((typeof ArcimARCOSRowId == "undefined") || (ArcimARCOSRowId == "undefined")) {
									ArcimARCOSRowId="";
								}
								if (ArcimARCOSRowId!=""){
									PageLogicObj.IsARCOSFormula = $.cm({
										ClassName:"web.UDHCPrescript",
										MethodName:"IsARCOSFormula",
										dataType:"text",
										ARCOSRowid:ArcimARCOSRowId
									},false);
									PageLogicObj.m_ARCOSRowId=ArcimARCOSRowId;
								}
								var Para=doseqty+String.fromCharCode(1)+""+String.fromCharCode(1)+doseuomrowid;
								Para=Para+"^^^^^^"+ArcimARCOSRowId+"^^^"+PhSpecInstr+"^^^^";
								OrdParamsArr[OrdParamsArr.length]={
									OrderARCIMRowid:icode,
									ParamS:Para,
									OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
									ITMRowId:""
								};
								resolve();
							}else if(OrdParamsArr.length>0){
								callBackExecFun();
							}
						})
					}).then(function(){
						i++;
						if ( i < ParaArr.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
					var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
					var GroupList=[];
					for(var i=1;i<=rows;i++){
						for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
						   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
						   if (OrderARCIMRowid!=""){
							   GroupList.push(i+"^"+j);
						   }
						}
					}
					if (GroupList.length>0){
			        	$.messager.alert("提示","协定处方不允许和普通药品混开!","info",function(){
			            	for (var i=0;i<GroupList.length;i++) {
			                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
			                }
			                FocusRowIndex=1;
			                FocusGroupIndex=1;
			                resolve();
			            });
			        }else{
			            resolve();
			        }
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})
	}).then(function(RtnObj){
		if (RtnObj==true){
			setTimeout(function(){ 
				SetScreenSum();
		     }, 100); 
		}else{
			PageLogicObj.IsARCOSFormula=0;
		}
	})
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
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
	$("body").remove("#"+id); //移除存在的Dialog
	$("#"+id).dialog('destroy');
}
function CloseDialog(id){
	$('#'+id).dialog('close');
}
function AddUnsaveDataToList(UnsaveData){
	if (UnsaveData=="") return;
	var UnsaveArr=UnsaveData.split(String.fromCharCode(12));
	var UnsaveArr1=UnsaveArr[1].split("^");
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	if (CMPrescTypeCode!=UnsaveArr1[12]) {
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==UnsaveArr1[12]){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
	}
	
		
	var sbox = $HUI.combobox("#PrescDuration");
		sbox.select(UnsaveArr1[0]);
		
	var sbox = $HUI.combobox("#PrescInstruction");
		sbox.select(UnsaveArr1[1]);
	
	var sbox = $HUI.combobox("#RecLoc");
		sbox.select(UnsaveArr1[2]);
		
	var sbox = $HUI.combobox("#PrescFrequence");
		sbox.select(UnsaveArr1[3]);
	/*
	var sbox = $HUI.combobox("#PrescOrderQty");
		sbox.select(UnsaveArr1[4]);
	*/
	var sbox = $HUI.combobox("#PrescPrior");
		sbox.select(UnsaveArr1[5]);
	$('#PrescOrderQty').combobox('setText',UnsaveArr1[4]);
	$("#PrescAppenItemQty").val(UnsaveArr1[6]);
	$("#PrescNotes").val(UnsaveArr1[7]);
	$("#PrescEmergency").val(UnsaveArr1[8]);
	$("#StartDate").val(UnsaveArr1[9]);
	$("#EndDate").val(UnsaveArr1[10]);
	PageLogicObj.m_ARCOSRowId=UnsaveArr1[11];
	//$("#ARCOSRowId").val(UnsaveArr1[11]);
	PageLogicObj.IsARCOSFormula=UnsaveArr1[13];
	if (PageLogicObj.IsARCOSFormula==1){
        checkIsExistOtherOrd();
        DisableDeleteButton(1);
    }
    $("#CookModelist").combobox('select',UnsaveArr1[15]);
    $("#PrescUrgent").checkbox('setValue',UnsaveArr1[14]=="Y"?true:false);
	var UnsaveArr=UnsaveArr[0].split(String.fromCharCode(2));
	for (var j=0;j<UnsaveArr.length;j++) {
		FindNullCell();
	    if (UnsaveArr[j]=="") continue;
		var OrderARCIMID=mPiece(UnsaveArr[j],"^",0);
		var OrderName=mPiece(UnsaveArr[j],"^",1);
		var OrderDoseQty=mPiece(UnsaveArr[j],"^",2);
		var OrderPhSpecInstr=mPiece(UnsaveArr[j],"^",3);
		var OrderPrice=mPiece(UnsaveArr[j],"^",4); 
		var OrderSum=mPiece(UnsaveArr[j],"^",5); 
		var OrderHiddenPara=mPiece(UnsaveArr[j],"^",6);
		var PHCDoseUOMDesc=mPiece(OrderHiddenPara,String.fromCharCode(3),9);
		var OrderCoverMainIns=mPiece(UnsaveArr[j],"^",7);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderName",OrderName);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseQty",OrderDoseQty);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID",OrderARCIMID);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPrice",OrderPrice);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara",OrderHiddenPara);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderSum",OrderSum);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseUOM",PHCDoseUOMDesc);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr",OrderPhSpecInstr);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderCoverMainIns",OrderCoverMainIns);
		//var select_id=FocusRowIndex+"_OrderPhSpecInstr"+FocusGroupIndex
		//$("#"+select_id+" option[value='"+OrderPhSpecInstr+"']").attr("selected", "selected");
	}
	SetScreenSum();
}
function CardBillClick(){
	var EpisodeID = GlobalObj.EpisodeID;
    var PatientID = GlobalObj.PatientID;
    if (EpisodeID == "") { $.messager.alert("提示", "缺少患者信息"); return; }
    var CardNo = GlobalObj.PatDefCardNo;
    var groupDR = session['LOGON.GROUPID'];
    var ctLocDR = session['LOGON.CTLOCID'];
    var hospDR = session['LOGON.HOSPID'];
    var expStr = groupDR + "^" + ctLocDR + "^" + hospDR;
    var mode = tkMakeServerCall("web.udhcOPBillIF", "GetCheckOutMode", expStr);
    if (mode == 1) {
	    if (CardNo==""){
		    $.messager.alert("提示", "该患者无对应卡信息,不能进行预扣费!");
		    return;
		}
	    $.messager.confirm('提示', '是否确认扣费?', function(r){
			if (r){
			    var insType = GlobalObj.OrderBillTypeRowid;
		        var oeoriIDStr = "";
		        var guser = session['LOGON.USERID'];
		        var groupDR = session['LOGON.GROUPID'];
		        var locDR = session['LOGON.CTLOCID'];
		        var hospDR = session['LOGON.HOSPID'];
		        var rtn = checkOut(CardNo, PatientID, EpisodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR);
		        CardBillAfterReload();
			}
		});
        return;
    }
 	var CardTypeValue = GlobalObj.CardBillCardTypeValue;
 	var CardTypeRowId = (CardTypeValue != "") ? CardTypeValue.split("^")[0] : "";
 	var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" + EpisodeID + "&SelectPatRowId=" + PatientID + "&CardTypeRowId=" + CardTypeRowId;
	websys_showModal({
		url: url,
		title: '预扣费',
		iconCls: 'icon-w-inv',
		width: '97%',
		height: '85%',
		onClose: function() {
			CardBillAfterReload();
		}
	});
}
function CardBillAfterReload(){
    if (GlobalObj.PAAdmType!="I"){
	    if (parent.refreshBar){
        	parent.refreshBar();
        }else if(parent.parent.refreshBar){
	        parent.parent.refreshBar();
	    }else{
        	parent.parent.opdoc.patinfobar.view.InitPatInfo(GlobalObj.EpisodeID);
        }
    }
}
function DocumentUnloadHandler(e){
  if (GlobalObj.StoreUnSaveData!="1"){return}
  try{
	var Str="";
		var UnsaveData="";
		if (!UpdateFlag) {
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					var OrderARCIMID=GetCellData(i,j,"OrderARCIMID");
				    if (OrderARCIMID!=""){
					    var OrderName=GetCellData(i,j,"OrderName");
					    var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
					    var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr");
					    var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
					    var OrderPrice=GetCellData(i,j,"OrderPrice");
					    var OrderOrderSum=GetCellData(i,j,"OrderSum");
					    var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns");
						Str=OrderARCIMID+"^"+OrderName+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+OrderPrice+"^"+OrderOrderSum+"^"+OrderHiddenPara+"^"+OrderCoverMainIns;
						if (UnsaveData==""){UnsaveData=Str}else{UnsaveData=UnsaveData+String.fromCharCode(2)+Str;}
				    }
				}
			}
			//if (UnsaveData=="") return ;
			var PrescDurationID=$("#PrescDuration").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceID=$('#PrescFrequence').combobox('getValue');
			var RecLoc=$('#RecLoc').combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText');
			var PrescPrior=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			var PrescNotes=$('#PrescNotes').val();
			//var CMPrescTypeSel=$("#CMPrescType").combobox('getValue');
			//var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
			var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
			var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
			var CMPrescTypeSel=CMPrescTypeDetails;
		    var DetailsArr=CMPrescTypeDetails.split("#");
		    var SelPrescTypeCode=DetailsArr[0];
			var PrescEmergency="N";
			var StartDate="";
			var EndDate="";
			var ARCOSRowId=PageLogicObj.m_ARCOSRowId; //$('#ARCOSRowId').val();
			var PrescUrgent=$("#PrescUrgent").checkbox('getValue')?"Y":"N"; //是否加急	
			var CookMode=$('#CookModelist').combobox('getValue');					
			Str = PrescDurationID + "^" + PrescInstructionID + "^" + RecLoc + "^" + PrescFrequenceID + "^" + PrescOrderQty + "^" + PrescPrior + "^" + PrescAppenItemQty + "^" + PrescNotes + "^" + PrescEmergency + "^" + StartDate + "^" + EndDate + "^" + ARCOSRowId + "^" + SelPrescTypeCode + "^"+ PageLogicObj.IsARCOSFormula+"^"+PrescUrgent+"^"+CookMode;
			if (UnsaveData!="") UnsaveData=UnsaveData+String.fromCharCode(12)+Str;
		}           
		var UserID=session['LOGON.USERID'];
		var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
		$.cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"SetUserCMUnSaveData",
			dataType:'text',
			wantreturnval:0,
			Name:SessionFieldName, 
			Value:UnsaveData
		},false);
	} catch(e) {dhcsys_alert(e.message);}
}
function isNumber(objStr){
	 strRef = "-1234567890.";
	 for (i=0;i<objStr.length;i++) {
	  tempChar= objStr.substring(i,i+1);
	  if (strRef.indexOf(tempChar,0)==-1) {return false;}
	 }
	 return true;
}
function ServerObj() {
	var PrescDoseQty=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<5; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid!=""){
				var OrderName=GetCellData(i,j,"OrderName");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				PrescDoseQty=parseFloat(PrescDoseQty)+parseFloat(OrderDoseQty);
			}
		}
	}
	var PrescDur=$('#PrescDuration').val();
	var PrescDurFactor=mPiece(PrescDur,"^",1)
	var PrescSumQty=PrescDoseQty*PrescDurFactor;
	return PrescSumQty;
}
function CheckPrescItemAndCount(ItemDesc,ArcimRowid,ARCIMDetail){
	var BillGrpDesc=mPiece(ARCIMDetail,"^",0);
	var FormDesc=mPiece(ARCIMDetail,"^",1);
	var ItemCatRowid=mPiece(ARCIMDetail,"^",2);
	var GenericName=mPiece(ARCIMDetail,"^",3);
	var PrescCheck=CheckDupOrderItem(ArcimRowid,GenericName);
	if (PrescCheck=="1"){
		dhcsys_alert(ItemDesc+t['SAME_PrescORDERITEM']);
	    return false;
	}else if((PrescCheck=="2")&&(GlobalObj.CheckPrescItemAndCount=="1")){
		dhcsys_alert(GenericName+"已存在相同通用名【"+GenericName+"】的医嘱,一张处方不允许重复!");
	    return false;
	}
	//此处旧版未起作用,请按照项目具体需求做相应修改
	/*var PrescCheck=CheckPrescriptItem(ItemCatRowid);
	if (PrescCheck==false){
		$.messager.alert("提示",ItemDesc+t['LIMIT_PRESCITEM']);
		return false;
	}*/
	return true;
}
function CheckDupOrderItem(ARCIMRowid,GenericName){
	var CurrCellPos=FocusRowIndex+"^"+FocusGroupIndex;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			var CellPos=i+"^"+j;
			if (OrderARCIMRowid!=""){
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				var OrderGenericName=OrderHiddenPara.split(String.fromCharCode(3))[11];
				if ((ARCIMRowid==OrderARCIMRowid)&&(CellPos!=CurrCellPos)){return 1;}
				if ((GenericName==OrderGenericName)&&(CellPos!=CurrCellPos)){return 2;}
			}
		}
	}	
	/*草药应该不用判断历史医嘱 此处旧版代码屏蔽 如新版需要判断再做修改
	var CheckSameOrderItem=document.getElementById('FindSameOrderItem');
	if (CheckSameOrderItem) {
		var encmeth=CheckSameOrderItem.value;
		var obj=document.getElementById('EpisodeID');
	var PAADMRowid=obj.value;
	//$.messager.alert("提示","PAADMRowid"+PAADMRowid+"ARCIMRowid:"+ARCIMRowid);
		var retDetail=cspRunServerMethod(encmeth,PAADMRowid, ARCIMRowid);
	  if (retDetail==1) return true;
	}
	*/
	return "";
}
function GetSessionStr() {
    var Str = "";
    Str = session['LOGON.USERID'];
    Str += "^" + session['LOGON.GROUPID'];
    Str += "^" + session['LOGON.CTLOCID'];
    Str += "^" + session['LOGON.HOSPID'];
    Str += "^" + session['LOGON.WARDID'];
    Str += "^" + session['LOGON.LANGID'];
    return Str;
}
function BaseValidCheck(ParamObj) {
    if (ParamObj.OrderItemInValid == 1) {
        dhcsys_alert(ParamObj.idesc + t['ItemInValid']);
        return false;
    }
    if (ParamObj.OrderAuthInValid == 0) {
        dhcsys_alert(ParamObj.idesc + t['NOT_ORDERED']);
        return false;
    }
    if (ParamObj.ireclocstr == "") {
        dhcsys_alert(ParamObj.idesc + t['NO_RECLOC']);
        return false;
    }
    if (ParamObj.AlertAuditSpecialItem != 0) {
        var NeedInsuAudit = dhcsys_confirm(ParamObj.idesc + t['NeedInsuAudit']);
        if (NeedInsuAudit == false) return false;
    }
    if (ParamObj.ASCheckFlag == 1) {
        dhcsys_alert(t['ASCheck1'] + ParamObj.idesc + t['ASCheck2'] + ParamObj.ASCheckSex + t['ASCheck3'] + ParamObj.ASCheckAgeRange);
        return false;
    }
    //判断医嘱项中的门急诊限制
    if (ParamObj.CheckArcimTypeStr!=""){
        dhcsys_alert(ParamObj.idesc + ParamObj.CheckArcimTypeStr);
        return false;
    }
    return true;
}
function CheckItemPoison(ItemDesc, PHPoisonCode) {
    //开毒麻药品判断身份证号是否存在，若不存在，输入保存
    if ((PHPoisonCode == 'J2') || (PHPoisonCode == 'J1') || (PHPoisonCode == 'DX') || (PHPoisonCode == 'MZ')) {
	    var PrescPrior=$('#PrescPrior').combobox('getValue');
	    if ((PrescPrior==GlobalObj.OutOrderPriorRowid)&&(GlobalObj.OutPriorAllowPoisonDrug==0)){
		    dhcsys_alert(ItemDesc + "出院带药不允许开精神毒麻类药品!")
        	return false;
		}
    	var IDCardNo = $.cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"FindPAPMIID",
			dataType:"text",
			PatientID:GlobalObj.PatientID
		},false);
        if (IDCardNo == '') {
            var lnk = "dhcdoccheckpoison.csp?PatID=" + GlobalObj.EpisodeID;
            var retval = window.showModalDialog(lnk, "", "dialogwidth:575px;dialogheight:180px;status:no;center:1;resizable:no");
            if (retval) {
	            var rtn = $.cm({
					ClassName:"web.DHCDocCheckPoison",
					MethodName:"UpdateAgencyInfo",
					dataType:"text",
					EpisodeID:GlobalObj.EpisodeID,
					PatInfo:retval
				},false)
                if (rtn == "-100") {
                    dhcsys_alert(ItemDesc + t['POISONSAVE_FAILED'])
                    return false;
                }
            } else {
                dhcsys_alert(ItemDesc + t['POISON_ALERT'])
                return false;
            }
        }
    }
    if ((PHPoisonCode == 'DBTHZJ') || (PHPoisonCode == 'TLJS')) {
        dhcsys_alert(ItemDesc + t['POISON_SPORT_ALERT'])
        return true;
    }
    return true;
}
function CheckPHInteractWith(CurrDrugItemRowid) {
    if (CurrDrugItemRowid == "") return false;
    var OrderDrugItemRowid;
    var OrderDrugItemRowidStr = "";
    var CurrCellPos = FocusRowIndex + "^" + FocusGroupIndex;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			var CellPos=i+"^"+j;
			if ((OrderARCIMRowid != "") && (CellPos != CurrCellPos)) {
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				OtherDrugItemRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2)
				if (OrderDrugItemRowidStr == "") {
                    OrderDrugItemRowidStr = OtherDrugItemRowid;
                } else {
                    OrderDrugItemRowidStr = OrderDrugItemRowidStr + "^" + OtherDrugItemRowid;
                }
			}
		}
	}	
    if (OrderDrugItemRowidStr != "") {
    	var ret = $.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"CheckPHInteractWith",
			dataType:"text",
			DrgItemRowid:CurrDrugItemRowid, 
			OtherDrgItemRowids:OrderDrugItemRowidStr
		},false);
        var Find = mPiece(ret, "^", 0);
        var DrugItemDesc = mPiece(ret, "^", 1);
        if (Find == "1") {
            dhcsys_alert(t['InteractWith'] + ":" + DrugItemDesc);
            return true;
        }
    }
    return false
}
//判断子类与所选的处方类型是否相符
function AtuoSelectPrescTypeList(OrderItemCatRowid, idesc){
    var ArcimStr=GetArcimStr();
    //var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
    var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
    var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
    if (("^"+CNItemCatStr+"^").indexOf("^"+OrderItemCatRowid+"^")<0){
        var PrescTypeIndex=GetCNMedPrescTypeIndex(OrderItemCatRowid);
        /*var sbox=$HUI.combobox("#CMPrescType")
        var CMPrescTypeData = sbox.getData();
		var PrescType= CMPrescTypeData[PrescTypeIndex].desc;*/
		var PrescType="";
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==PrescTypeIndex){
				PrescType=Data[i].text;
				break;
			}
		}
        if (ArcimStr==""){
            var conflag = dhcsys_confirm(idesc + "为"+PrescType+"药品,是否确认录入"+PrescType+"处方?");
            if (conflag) {
                $("#CMPrescTypeKW").keywords('select',PrescTypeIndex);
            }else{
                return false;
            }
            return true;
        }else{
            dhcsys_alert(idesc + "为"+PrescType+"药品,不允许录入");
            return false;
        }
    }
    return true;
}
///获取该子类应归属的处方类型
function GetCNMedPrescTypeIndex(OrderItemCatRowid){
    var PrescTypeIndex="";
    //var sbox = $HUI.combobox("#CMPrescType");
	//var Data=sbox.getData();
	var Data=$("#CMPrescTypeKW").keywords('options').items;
	for (var j=0;j<Data.length;j++){
		var CNItemCatStr=Data[j].value.split("#")[5];
		if (("^"+CNItemCatStr+"^").indexOf("^"+OrderItemCatRowid+"^")>=0){
            //var PrescTypeIndex=j;
            var PrescTypeIndex=Data[j].id;
            break;
        }
	}
    return PrescTypeIndex;
}
function CheckConflict(ARCIMRowid, idesc) {
    //十八反十九畏判断
    var ARCIMRowidNextAll = ""
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid != "") {
				if (ARCIMRowidNextAll == "") ARCIMRowidNextAll = OrderARCIMRowid;
                else ARCIMRowidNextAll = ARCIMRowidNextAll + "^" + OrderARCIMRowid;
			}
		}
	}	
	var CheckCMLimitFlag = $.cm({
		ClassName:"web.DHCDocOrderEntryCM",
		MethodName:"GetCMLimitInfo",
		dataType:"text",
		ARCIMRowId:ARCIMRowid, ARCIMRowIdNextALL:ARCIMRowidNextAll
	},false);
    if (CheckCMLimitFlag != "") {
        var rtn = dhcsys_confirm(idesc + " " + CheckCMLimitFlag + ",是否确定录入?")
        if (!rtn) {
            SetFocusColumn("OrderName" + FocusGroupIndex, FocusRowIndex);
            return false;
        }
    }else{
	    var ret = $.cm({
			ClassName:"web.DHCDocOrderEntryCM",
			MethodName:"CheckConflict",
			dataType:"text",
			EpisodeID:GlobalObj.EpisodeID, ArcimRowid:ARCIMRowid
		},false);
        var CheckConflict=mPiece(ret,"^",0)
        var ConflictInfo=mPiece(ret,"^",1)
        if (CheckConflict=="Y")  {
            dhcsys_alert(idesc+ConflictInfo+"互斥!"); //$.messager.
        }
	}
    return true;
}
function CheckComboValue(id,CombValue)
{
	var NodeName=$.trim($("#"+id).parent().prev().text());
	var Value=$("#"+id).combobox('getValue');
	if(Value=="") {
		$.messager.alert('提示',NodeName+' 不能为空,请重新选择');
		return false;
	}
	var DataArr=$("#"+id).combobox('getData');
	var i=0;
	for(i=0;i<DataArr.length;i++){
		var cmd="var val=DataArr[i]."+CombValue;
		eval(cmd);
		if(val==Value) break;
	}
	if(i<DataArr.length) return true;
	$.messager.alert('提示',NodeName+' 值无效,请重新选择!',"info",function(){
		$('#'+id).next('span').find('input').focus();
	});
	return false;
}
function GetPrescWeight() {
    var PrescDoseQty = 0;
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
    for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
		   if (OrderARCIMRowid!=""){
			   var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
			   PrescDoseQty = parseFloat(PrescDoseQty) + parseFloat(OrderDoseQty);
		   }
		}
	}
    var PrescDurFactor = GetDurFactor();
    var PrescSumQty = PrescDoseQty * PrescDurFactor;
    return PrescSumQty;
}
function GetDurFactor(){
	var DurationRowid=$('#PrescDuration').combobox("getValue");
	if (DurationRowid=="") return "1";
	return PageLogicObj.PrescDurFactor;
}
function SaveOrderToEMR() {
    if (GlobalObj.PAAdmType == "I") {
        return true;
    }
	var OrdList = tkMakeServerCall("EMRservice.BL.opInterface", "getOeordXH", GlobalObj.EpisodeID,"CHMED")
    //\r\n+1.0(编号-依次递增)+医嘱名称+剂量+单位+频次+疗程+(第二条，后边一次类推N条）\r\n+2.0+医嘱名称+剂量+单位+频次+疗程
    if ((typeof(parent.invokeChartFun) === 'function')||(typeof(parent.parent.invokeChartFun) === 'function')) {
	    if (typeof(parent.invokeChartFun) === 'function'){
		    parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeordCN", OrdList, "", GlobalObj.EpisodeID);
		}else{
			parent.parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeordCN", OrdList, "", GlobalObj.EpisodeID);
		}
        
    }
    return OrdList
}
function ClearList() {
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
		}
	}
	SetFocusColumn("OrderName1", 1)
}
function StopPrescClickHandler(){
	var selVal=$('#PrescList').combobox("getValue");
	if (selVal!=""){
		var PrescNo=selVal.split("^")[0];
		if (PrescNo!=""){
			var rtn = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"CheckStopPrescNo",
				dataType:"text",
				PrescNo:PrescNo, UserID:session['LOGON.USERID'],EpisodeID:GlobalObj.EpisodeID
			},false);
			var rtnArr=rtn.split("^")
			if (rtnArr[0]!=0){
				$.messager.alert("提示",PrescNo + " 不允许停止:" + rtnArr[1]);
        		return false;
			}
			StopPrescList(PrescNo);
		}else{
			$.messager.alert("提示","请在处方列表中，选择有效的处方记录!");
			return false;
		}
	}else{
		$.messager.alert("提示","请在处方列表中，选择有效的处方记录!");
		return false;
	}
}
function addSelectedFav(value,callBackFun) {
	if (GlobalObj.warning != "") {
        $.messager.alert("警告",GlobalObj.warning);
        return false;
    }
	new Promise(function(resolve,rejected){
		CheckFormulaCanAppendItem("",resolve);
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return false;
			var newselary=value.split("^");
			if (newselary[0].split(String.fromCharCode(4))[0]=="ARCOS") {
				var osid = newselary[0].split(String.fromCharCode(4))[2];
				setTimeout(eval("OSItemListOpen("+osid+",'','YES','')"),100);
				if (callBackFun) callBackFun();
				return;
			}
			//判断是否存在诊断
			CheckDiagnose("",resolve);
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return false;
			var findcell = FindNullCell();
	        if (!findcell) return false;
	        ClearGroupData(FocusRowIndex, FocusGroupIndex);
		    var newselary=value.split("^");
		    for (var i = 0; i < newselary.length; i++) {
		        var itemid = newselary[i].split(String.fromCharCode(4))[2];
		        var Para="",OrderPhSpecInstr="";
			    var PhSpecInstr=newselary[i].split(String.fromCharCode(4))[15]; //GetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr");
				if (PhSpecInstr!="") {
					$("#"+FocusRowIndex+"_OrderPhSpecInstr"+FocusGroupIndex+" option").each(function(){
						if (PhSpecInstr==$(this).text()) {
							OrderPhSpecInstr=$(this).val();
							return;
						}
					})
				}
			    var OrdParamsArr=new Array();
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:itemid,
					ParamS:Para,
					OrderPhSpecInstr:OrderPhSpecInstr
				};
			}
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve); //icode,Para
		})
	}).then(function(ret){
		if (ret==false) {
			ClearGroupData(FocusRowIndex,FocusGroupIndex);
		}else{
			SetScreenSum();
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			if (FocusGroupIndex==GlobalObj.ViewGroupSum){
				var cbox=$HUI.checkbox("#DrugAndQtyYQ");
				if (!cbox.getValue()){
					if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
					FocusGroupIndex=1;
					FocusRowIndex=eval(FocusRowIndex)+1;
					SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
				}
			}
		}
		if (callBackFun) callBackFun();
	})
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function CheckDiagnose(ordertype,callBackFun) {
	new Promise(function(resolve,rejected){
		if ((GlobalObj.PAADMMotherAdmId!="")||(GlobalObj.PAAdmType=="H")) resolve(true);
		var NeedDiagnosFlag = 1;NoDiagnosMsg="";
	    if (GlobalObj.CMOrdNeedTCMDiag == 1){
		    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetCMMRDiagnoseCount", GlobalObj.mradm);
		    GlobalObj.MRDiagnoseCount = Ret;
		    NoDiagnosMsg="没有中医诊断,请先录入!";
		}else{
			//新门诊病历界面,录入诊断或删除诊断后未刷新医嘱录入界面,导致诊断数据取的错误
	    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
	    	GlobalObj.MRDiagnoseCount = Ret;
	    	NoDiagnosMsg="没有诊断,请先录入!";
		}
		if ((GlobalObj.MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)&&(GlobalObj.OrderLimit!=1)) {
			$.messager.alert("提示",NoDiagnosMsg,"info",function(){
				var iframeName = window.name
		        if (iframeName == "") {
		            iframeName = window.parent.frames("oeordFrame").name
		        }
		        if ((iframeName == "oeordFrame")||(GlobalObj.CareProvType != "DOCTOR")) {
		            resolve(false);
		        }else{
					websys_showModal({
						url:"diagnosentry.v8.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm+"&CMDisFlag="+GlobalObj.CMOrdNeedTCMDiag,
						title:'诊断录入',
						width:((top.screen.width - 100)),height:(top.screen.height - 120),
						onClose:function(){
							if (GlobalObj.CMOrdNeedTCMDiag == 1){
							    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetCMMRDiagnoseCount", GlobalObj.mradm);
							}else{
						    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
							}
				            GlobalObj.MRDiagnoseCount = Ret;
				            if (Ret == 0) { Ret = false; } else { Ret = true; }
							resolve(Ret);
						}
					})
			    }
			})
	    }else{
		    callBackFun(true);
		}
	}).then(function(rtn){
		callBackFun(rtn);
	})
}
function ARCOSChangePrescType(ARCOSRowid,CallBackFun){
	if (typeof CallBackFun!="function"){
		CallBackFun=function(){};
	}
	var ARCOSPrescTypeStr = $.cm({
		ClassName:"web.UDHCFavItemNew",
		MethodName:"GetARCOSPrescType",
		dataType:"text",
		ARCOSItemRowid:ARCOSRowid,
		CurLogonHosp:session['LOGON.HOSPID']
	},false);
    if (ARCOSPrescTypeStr==""){CallBackFun();return true}
    var ARCOSPrescTypeCode=ARCOSPrescTypeStr.split("^")[0];
    if (ARCOSPrescTypeCode=="") {CallBackFun();return true}
    var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeName=CMPrescTypeKWSel[0].text
    var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    new Promise(function(resolve,rejected){
	    if (SelPrescTypeCode!=ARCOSPrescTypeCode){
			///处方类型的自动切换事件中可能包含转换相关的提醒，详见AutoConvertPrescForm中的处理
			///转换提醒相关的内容，会和callback的弹窗或处理发生互相遮罩的影响，因AutoConvertPrescForm的调用链太长
			///在这里直接判断是否会出现提醒内容，如果会出现，则让医生手工去选择切换处方类型，并对AutoConvertPrescForm的内容处理完毕后
			///再录入该医嘱套
			///----tanjishan
			///AutoConvertPrescForm内部会调用AddItemToList， 涉及的弹窗内容太多，这里直接提醒医生是否手工处理即可
			var HaveOrdItemFlag="N";
			//console.log(ARCOSPrescTypeStr)
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
				   if (OrderARCIMRowid!=""){
					    HaveOrdItemFlag="Y";
					    break;
				   }
			    }
			    if (HaveOrdItemFlag=="Y"){
					break;  
				}
			}
			if (HaveOrdItemFlag=="Y"){
				$.messager.confirm('提示', "当前列表中存在未审核的"+CMPrescTypeName+"医嘱项，与当前医嘱套属于不同处方类型，需切换处方类型后在重新开立该医嘱套，是否自动切换?", function(r){
					if (r) {
						var Data=$("#CMPrescTypeKW").keywords('options').items;
						for (var i=0;i<Data.length;i++){
							var CMPrescTypeCode=Data[i].id;
							if (CMPrescTypeCode==ARCOSPrescTypeCode){
								$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
								break;
							}
						}
					}
				});
				///医嘱套不再继续录入
				return false;
			}
		}
		resolve();
    }).then(function(){
	    if (ARCOSPrescTypeStr.split("^").length>1){
		    SetCNInfoByOS(ARCOSPrescTypeStr);
		}
		CallBackFun();
		/*
		if (SelPrescTypeCode==ARCOSPrescTypeCode){return true}
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==ARCOSPrescTypeCode){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
		*/
    });
}
//按医嘱套信息串赋值:
function SetCNInfoByOS(CNInfoStr)
{
	if(CNInfoStr){
	    var CNArr=CNInfoStr.split(String.fromCharCode(2));
		var PrescTypeCode=CNArr[0].split("^")[0];
		var DoseQtyId=CNArr[1].split("^")[0];
		var FreqStr=CNArr[2];
		var InstrStr=CNArr[3];
		var DuratStr=CNArr[4];
		var Notes=CNArr[5];
        var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			if (PrescTypeCode==Data[i].id){
				$("#CMPrescTypeKW").keywords('select',PrescTypeCode);
				SetPrescAppenItemQty();
				break;
			}
		}
	    $("#PrescInstruction").combobox('select',InstrStr.split("^")[0]);
	    var data=$('#PrescOrderQty').combobox('getData')
        for (var j = 0; j < data.length; j++) {
            if (DoseQtyId==data[j].Code){
	            $("#PrescOrderQty").combobox('select',data[j].Code);
                break;
            }
        }
	    $("#PrescDuration").combobox('select',DuratStr.split("^")[0]);
	    $("#PrescFrequence").combobox('select',FreqStr.split("^")[4]);
	    $("#PrescNotes").val(Notes);
	}
}
function PrescInstrLookUpSelect(){
	//var CMPrescTypeDetails=$HUI.combobox("#CMPrescType").getValue();
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var DefaultQtyStr=DetailsArr[4];
    var DefaultQtyID=mPiece(DefaultQtyStr, "!", 0);
	ResetPrescOrderQty(DefaultQtyID);
}
function MultiTemplOrdEntry() {
	new Promise(function(resolve,rejected){
		CheckFormulaCanAppendItem("",resolve);
	}).then(function(rtn){
		if (!rtn) return;
		var ItemCount=0;
		if ($("#OrderTemplate").length==0){
			var nodeArr=new Array();
			if ((window.parent)&&(window.parent.getCheckedNodes)){
				nodeArr=window.parent.getCheckedNodes();
			}else{
				if ((typeof(getCheckedNodes) === 'function')){
					nodeArr=getCheckedNodes();
				}
			}
			if (nodeArr.length>0) {
				new Promise(function(resolve,rejected){
					(function(callBackFun){
						function loop(i){
							new Promise(function(resolve,rejected){
								ItemCount=ItemCount+1;
								addSelectedFav(nodeArr[i],resolve);
							}).then(function(){
								i++;
								if ( i < nodeArr.length ) {
									 loop(i);
								}else{
									callBackFun();
								}
							})
						}
						loop(0);
					})(resolve);
				}).then(function(){
					 if(window.parent.unCheckedNodes) window.parent.unCheckedNodes();
					 if (clearCheckedNodes) clearCheckedNodes();
				})
			}
		}else{
		    var _$OrdTempCheck=$(".ordtemplatecheck");
		    new Promise(function(resolve,rejected){
				(function(callBackFun){
					function loop(i){
						new Promise(function(resolve,rejected){
							var checkboxid = _$OrdTempCheck[i].id;
							if ($("#" + escapeJquery(checkboxid) + "").is(":checked")) {
								ItemCount=ItemCount+1;
					            var checkidArr = checkboxid.split("_");
					            var checkidlength = checkidArr.length;
					            var itemclass = checkidArr[checkidlength - 3] + "_" + checkidArr[checkidlength - 2] + "_" + checkidArr[checkidlength - 1];
					            var itemid = $("." + itemclass + "").attr("id");
								addSelectedFav(itemid,resolve);
								$("#" + checkboxid + "").prop('checked', false);
							}else{
								resolve();
							}
						}).then(function(){
							i++;
							if ( i < _$OrdTempCheck.length ) {
								 loop(i);
							}else{
								callBackFun();
							}
						})
						
					}
					loop(0);
				})(resolve);
			}).then(function(){
				 if(window.parent.unCheckedNodes)window.parent.unCheckedNodes();
			})
		}
	    if (ItemCount==0){
	        $.messager.alert("提示","请选择需要添加的模板医嘱!");
	        return false;
	    }
	})
}
function ResizeGridHeight(){
	$(".search-table").addClass('in-table');
	var c=$("#Ordlayout_main");
	var p=c.layout('panel', 'north');
	p.panel('resize',{height:212}); 
	var p = c.layout('panel','center');
	p.panel('resize',{top:212});
	var p = c.layout('panel','center');	
	var Height = parseInt(p.outerHeight())+parseInt(36);
	p.panel('resize', {height:Height})
	var ActiveHeight=$(window).height()-265
	$('#CMOrdEntry_DataGrid').setGridHeight(parseInt(ActiveHeight));
}
function OrderTemplateClick(){
	var btntext=[{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				//$HUI.dialog('#TemplateDetail').close();
				$("#TemplateDetail").panel('collapse','100');
			}
		},{
			text:'添加模板医嘱',
			iconCls:'icon-w-plus',
			handler:function(){
				MultiTemplOrdEntry();
			}
		}]
		$.ajax('ipdoc.ordtemplat.show.hui.csp', {
			"type" : "GET",
			"dataType" : "html",
			"success" : function(data, textStatus) {
				createTemplModalDialog("TemplateDetail","医嘱模板", 280, $(window).height()-20,"icon-w-list",btntext,data,"InitOrdTemplTree()");
			}
		});
}
function createTemplModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class=''></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    var collapsed=true;
   	if (GlobalObj.DefaultCMExpandTemplate==1){
	   collapsed=false;
   	}
    $("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon, 
        collapsible: true,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: false,
        content:_content,
        buttons:_btntext,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:$(window).width()-300,
        onClose:function(){
	        //destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		},onCollapse:function(){
			$(this).panel('resize',{
				width: 130,
				height: 400,
				left:$(window).width()-220
			});
		},onExpand:function(){
			$(this).panel('resize',{
				width: 280,
				height: $(window).height()-20,
				left:$(window).width()-300,
			});
			
		}
    });
    $("#"+id).parent('').find(".panel-header").bind("click",function(){
	    if ($("#"+id).css("display")=="none"){
			$("#"+id).panel('expand');
		}else{
			$("#"+id).panel('collapse');
		}
	});
    
}
function InitOrdTemplTree(){
	InitTree();
	$("#OrdTempTypeKW").keywords({
	    singleSelect:true,
	    //labelCls:'red',
	    items:[
		        {text:'个人',id:'SSUser',selected:true},
		        {text:'科室',id:'CTLoc'}
		    ],
	    onClick:function(v){
		    var id="User."+v.id;
		    LoadOrdTemplTree(id,0);
		}
	});
	LoadOrdTemplTree("User.SSUser",1);
	/*$('#OrdTempTypeTab').tabs({
	  onSelect: function(title,index){
		  ClearTree();
		  if (title=="个人"){
			  LoadOrdTemplTree("User.SSUser",0);
		  }else{
			  LoadOrdTemplTree("User.CTLoc",0);
		  }
	  }
   });*/
   //模板名切换
   $('#templName_tabs').tabs({    
	    onSelect:function(title,index){
		    templNameTabSelect(index);
	    }    
   }); 
}
function templNameTabSelect(index){
	var _$tree=$('#OrdTemplTree');
    var Roots= _$tree.tree('getRoots');
    if (Roots.length>0){
        TreeFilter(index+1);
    }
}
function InitTree(){
	var tbox=$HUI.tree("#OrdTemplTree",{
		checkbox:true,
		onlyLeafCheck:true,
		onBeforeExpand:function(node){
			var targeteleid=node.eleid;
			if (targeteleid!="") return false;
			var targetId=node.id;
			var targetIdLen=targetId.length;
			var state="closed",defId="",attributes="";
			var treeDataArr=new Array();
			for (var i=0;i<treeData.length;i++){
				var RealStock=treeData[i]["RealStock"];
				var eleid=treeData[i]["eleid"]; 
				var id=treeData[i]["id"]; 
				var name=treeData[i]["name"]; 
				var pId=treeData[i]["pId"];
				if ((id.substring(0, targetIdLen)==targetId)&&(id.length==(targetIdLen+2))){
					if (eleid!="") {
						state="open";
						if (+RealStock=="0") attributes={'color':'red'}
					}
					if (defId=="") defId=id;
					var tmpnode=$(this).tree('find', id);
					if (tmpnode){
						$(this).tree('remove',tmpnode.target);
					}
					treeDataArr.push({"id":id,"text":name,"RealStock":RealStock,"eleid":eleid,"pId":pId,"state":state,"attributes":attributes});					
				}
			};
			tbox.append({
				parent: node.target,
				data:treeDataArr
			});
			if (defId!=""){
				var node =tbox.find(defId);
				tbox.expand(node.target);
		    }
		},
		onDblClick:function(node){
			var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)) return false;
			//$HUI.dialog('#TemplateDetail').close();
			addSelectedFav(value);
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					return '<span style="color:red">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				var nodes = $(this).tree('getChecked');
				for (var i=0;i<nodes.length;i++){
					if (nodes[i]['id']==curId){
						$(this).tree('uncheck',node.target);
						isChecked=true;
						break;
					}
				}
				if (!isChecked){
					$(this).tree('check',node.target);
				}
			}
		},
		onBeforeCheck:function(node, checked){
			var isLeaf=$(this).tree('isLeaf',node.target);
			if (isLeaf){
				var eleid=node.eleid;
				if (eleid=="") return false;
				var type=eleid.split("^")[0];
				if (type=="ARCIM"){
					$(this).tree('select',node.target);
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
	});
}
function ClearNameTabs(){
	$("#mmedit div").remove();
	var _$tab=$('#templName_tabs');
	var tabs=_$tab.tabs('tabs');
	for (var i=tabs.length-1;i>=0;i--){
		_$tab.tabs('close',i);
	}
}
function LoadOrdTemplTree(type,isSelLoc){
	$("#BMore,#templName_tabs").show();
	ClearTree();
	ClearNameTabs();
	//var tab = $('#OrdTempTypeTab').tabs('getSelected');
	//var index = $('#OrdTempTypeTab').tabs('getTabIndex',tab);
	$.q({
	    ClassName:"DHCDoc.OPDoc.OrderTemplateCommmon",
	    QueryName:"GetOEPrefTabsTrees",
	    UserID:session['LOGON.USERID'], GroupID:session['LOGON.GROUPID'], LocID:session['LOGON.CTLOCID'], CONTEXT:"W50007", 
	    objectType:type, HospID:session['LOGON.HOSPID'], Region:session['LOGON.REGION'],
	    SITECODE:session['LOGON.SITECODE'], EpisodeID:GlobalObj.EpisodeID,
	    rows:99999
	},function(jsonData){ 
		var tbox=$HUI.tree("#OrdTemplTree");
		var treeDataArr=new Array();
		treeData=jsonData.rows;
		if ((type=="User.SSUser")&&(isSelLoc=="1")&&(treeData.length==0)){
			/*if (index=="1"){
				LoadOrdTemplTree("User.CTLoc",0);
			}else{
				$HUI.tabs("#OrdTempTypeTab").select(1);
			}*/
			$("#OrdTempTypeKW").keywords('select',"CTLoc");
			return false;
		}
		var LasTabNameIndex=-1,showMoreBtnFlag=0;
		//var defId="";
		var _$scroller=$("#templName_tabs .tabs-scroller-left");
		for (var i=0;i<treeData.length;i++){
			var RealStock=treeData[i]["RealStock"];
			var eleid=treeData[i]["eleid"]; 
			var id=treeData[i]["id"]; 
			var name=treeData[i]["name"]; 
			var pId=treeData[i]["pId"];
			var state="closed";
			if (pId==0){
				if ((_$scroller.is(':hidden'))&&(showMoreBtnFlag==0)){
					$('#templName_tabs').tabs('add',{
						title: name,
						index: id
					});
					LasTabNameIndex=LasTabNameIndex+1;
					if (!_$scroller.is(':hidden')){
						AddMoreMenu();
					}
				}else{
					AddMoreMenu();
				}
				//if (defId=="") defId=id;
				treeDataArr.push({"id":id,"text":name,"RealStock":RealStock,"eleid":eleid,"pId":pId,"state":state});
			}
		};
		if (showMoreBtnFlag==0){
			$("#BMore").hide();
		}
		tbox.append({
			parent: "",
			data:treeDataArr
		});
		var len=treeDataArr.length;
		if (len==0){
			$("#BMore,#templName_tabs").hide();
		}else if(len>1){
			$('#templName_tabs').tabs('select',0);
		}else{
			templNameTabSelect(0);
		}
		/*if (defId!=""){
			var node =tbox.find(defId);
			tbox.expand(node.target);
		}*/
		function AddMoreMenu(){
			showMoreBtnFlag=1;
			if (LasTabNameIndex>-1){
				var closeTab=$('#templName_tabs').tabs('getTab',LasTabNameIndex);
				var closeTabTitle=closeTab.panel("options").title;
				var closeTabid=closeTab.panel("options").index;
				$("#mmedit").menu('appendItem', {
					id:closeTabid,
					text: closeTabTitle
				});
				$('#templName_tabs').tabs('close',LasTabNameIndex);
				LasTabNameIndex=-1;
			}else{
				$("#mmedit").menu('appendItem', {
					id:id,
					text: name
				});
			}
		}
	}); 
}
function ClearTree(){
    var tbox=$HUI.tree("#OrdTemplTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
}
function getCheckedNodes(){
	var nodeArr=new Array();
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var eleid=nodes[i]['eleid'];
		if (eleid=="") continue;
		nodeArr.push(eleid.replace(/\^/g,String.fromCharCode(4)));
	}
	return nodeArr;
}
function clearCheckedNodes(){
	var nodes = $("#OrdTemplTree").tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		var eleid=nodes[i]['eleid'];
		if (eleid=="") continue;
		var node = $('#OrdTemplTree').tree('find', nodes[i]['id']);
		$("#OrdTemplTree").tree('uncheck',node.target);
	}
}
function OrdTemplManClick(){
	var CMFlag="CM";
	var src="oeorder.template.maintenancev8.csp?EpisodeID="
			+GlobalObj.EpisodeID+"&XCONTEXT="+"W50007"
			+"&PreftabType=User.SSUser&SaveContextWorkflow=on&CMFlag="+CMFlag;
	websys_showModal({
		url:src,
		title:'医嘱模板维护',
		width:window.screen.width-100,height:window.screen.height-220
	});
}
//******************模版在下相关 开始**********************//
function OEPrefClickHandler(e) {
    var obj = websys_getSrcElement(e);
    if (!obj) return;
    var ObjectType = "";
    var id=obj.id;
    if (id==""){
    	id=e.currentTarget.id;
    }
    $(".seltemplate_btn").removeClass("seltemplate_btn");
    if (id == 'Personal_Template_Btn') {
        ObjectType = "User.SSUser";
    } else if (id == 'Departments_Template_Btn') {
        ObjectType = "User.CTLoc";
    } else if (id == 'OEPrefHosp') {
        ObjectType = "User.CTHospital";
    }
    $("#"+id).addClass("seltemplate_btn");
    PageLogicObj.m_ObjectTypeS = ObjectType;
    websys_createWindow(lnkFav + '&TABIDX=0' + '&ObjectType=' + ObjectType + '&PREFTAB=1', 'TRAK_hidden');
}
function OEPrefChangeHandel(Type){
    if (Type=="U"){
        $('#Personal_Template_Btn').click();
    }
    if (Type=="L"){
        $('#Departments_Template_Btn').click();
    }
}
function PrefAddItemCustom(tabidx, lstcnt, val, desc, hasdefault, stockqty) {
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var lstpanel = jQuery(selector);
    var descarr = desc.split(" - ");
    if (descarr.length > 1) { desc = descarr[1] };
    val = val + selector;
    if (!document.getElementById(val)) {
        var Color = "";
        if (hasdefault == "Y") { Color = "blue"; }
        if (stockqty == 0) {
            Color = "red";
        }

        var StyleStr = "style=\"color:" + Color + " \"";
        var ItemCustomLabelStr = $("#tempTemplateData").data(selector) || "";
        var length = ItemCustomLabelStr.split("</label>").length || 0;
        var itemid = val.split(String.fromCharCode(4))[2];
        itemid = itemid.replace("||", "_")
        var labelclass = lstcnt + "_" + tabidx + "_" + length;
        var checkvalue = itemid + "_" + labelclass
        var OrderType = val.split("#")[0].split(String.fromCharCode(4))[0] //mPiece(value,String.fromCharCode(4),0);
        var OneLabel = "<label " + StyleStr + " id=\"" + val + "\" class=\"" + labelclass + "\" onclick=\"templateItemClickHandler(this)\" ondblclick=\"templateItemdbClickHandler(this)\" onselectstart=\"return false;\" >" + desc + "</label><br>"
        if (OrderType == "ARCIM") {
            var OneLabel = "<input onclick=\"templateCheckClickHandler(this)\" class=\"ordtemplatecheck\" id=\"" + checkvalue + "\" type='checkbox' style='vertical-align:middle;padding:0px;'>" + OneLabel
        }
        var ItemCustomLabelStr = $("#tempTemplateData").data(selector) || "";
        ItemCustomLabelStr = ItemCustomLabelStr + OneLabel;
        $("#tempTemplateData").data(selector, ItemCustomLabelStr);
        $HUI.checkbox("input.ordtemplatecheck",{});
    }
}
function PrefAddItemCustomAppend(tabidx, lstcnt) {
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var lstpanel = jQuery(selector);
    var ItemCustomLabelStr = $("#tempTemplateData").data(selector);
    lstpanel.append(ItemCustomLabelStr);
    $("#tempTemplateData").data(selector, "");
    $("#ngroup" + lstcnt + "Z" + tabidx).click(function() {
        for (var i = 0; i < 5; i++) {
            $("#ngroup" + i + "Z" + tabidx).prev().children(":first").css("background-color", "")
        }
        $("#" + this.id).prev().children(":first").css("background-color", "#87CEFF") //css("color","red")
        lstidx = lstcnt
    })
}
function templateCheckClickHandler(e){
    var idstr = e.id
    var labelclassArr=idstr.split("_");
    var labelclass=labelclassArr[2]+"_"+labelclassArr[3]+"_"+labelclassArr[4];
    $("."+labelclass+"").removeClass("templateItemSelect");
    idstr=escapeJquery(idstr);
    if ($("#" + idstr + "").checkbox("getValue")) {
        $("."+labelclass+"").addClass("templateItemSelect");
    }
}
function templateItemClickHandler(e) {
    var idstr = e.id
    var labelclassname = e.className.split(" ")[0];
    var itemid = idstr.split("#")[0].split(String.fromCharCode(4))[2];
    itemid = itemid.replace("||", "_")
    var checkvalue = itemid + "_" + labelclassname;
    checkvalue=escapeJquery(checkvalue);
    if ($("#" + checkvalue + "").length==0){
       if (jQuery(e).hasClass("templateItemSelect")){
          jQuery(e).removeClass("templateItemSelect");
       }else{
           jQuery(e).addClass("templateItemSelect");
       }
       return;
    }
    if ($("#" + checkvalue + "").checkbox("getValue")) {
        $("#" + checkvalue + "").checkbox('uncheck');
        jQuery(e).removeClass("templateItemSelect");
    } else {
        $("#" + checkvalue + "").checkbox('check');
        jQuery(e).addClass("templateItemSelect");
    }
}
function templateItemdbClickHandler(e) {
    //从模板增加医嘱
    var obj = websys_getSrcElement(e);
    addSelectedFav(obj.id);
}
function RedrawFavourites(tabidx, FocusWindowName) {
    var obj = jQuery('#Template_tabs');
    var currTab = obj.tabs('getSelected');
    var currTabIndex = obj.tabs('getTabIndex', currTab);
    if (!document.getElementById('ngroup0Z' + tabidx)) {
        for (var groupI = 0; groupI < 5; groupI++) { //easyui-panel
            currTab.append("<div class='template_div'><div data-options='fit:true' class='hisui-panel' title=' ' id='ngroup" + groupI + 'Z' + tabidx + "'></div></div>");
        }
        jQuery.parser.parse('#Template_tabs');
    }
    var formulary = "";
    var obj = document.getElementById("NonFormulary");
    if (obj) {
        if (obj.checked) formulary = "Y";
        else { formulary = "N"; }
    }

    if (!obj) formulary = "";
    //if ((FocusWindowName) && (FocusWindowName != "")) {
        //websys_createWindow(lnkFav + '&TABIDX=' + tabidx + '&FocusWindowName=' + FocusWindowName + '&formulary=' + formulary, 'TRAK_hidden');
    //} else {
        //如果模板内容出不来?有可能窗口出错?可以把第二个参数'TRAK_hidden'设为空?就可以显示弹出窗口
        websys_createWindow(lnkFav + '&ObjectType=' + PageLogicObj.m_ObjectTypeS + '&TABIDX=' + tabidx, 'TRAK_hidden');
        //将默认的list index置为空
        lstidx = "";
    //}
    //因为切换Tab时会根据模板的设定置上Categor和SubCategory?为了不影响开医嘱?默认要置为空
    //window.setTimeout("ClearCategory()", 1000);
}
function ClearCategory() {

    obj = document.getElementById('catID');
    if (obj) obj.value = '';
    obj = document.getElementById('Category');
    if ((obj) && (obj.tagName == 'INPUT')) { obj.value = ''; };
    obj = document.getElementById('subcatID');
    if (obj) obj.value = '';
    obj = document.getElementById('SubCategory');
    if ((obj) && (obj.tagName == 'INPUT')) obj.value = "";
}
function PrefEditItem(Str) {
    var arr = Str.split("Z");
    var lstcnt = arr[1];
    var tabidx = arr[2];
    var ObjectType = arr[3];
    var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
    var select = jQuery(selector).find(".templateItemSelect")[0];
    //判断是否存在科室权限,有则需要选择维护个人还是科室
    var IsHaveMenuAuthOrderOrgFav=$.cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"IsHaveMenuAuthOrderOrgFav",
		dataType:"text",
		GroupId:session['LOGON.GROUPID'], MenuName:"System.OEOrder.OrgFav.Save.SetSaveForLocation"
	},false);
    if ((IsHaveMenuAuthOrderOrgFav != 1) && (ObjectType == "User.CTLoc")) {
        $.messager.alert("提示", "没有权限维护科室模板")
        return false;
    }
    var ItemCount=0;
    var $select=jQuery(selector).find(".templateItemSelect")
    var length=$select.length;
    for (var i = 0; i < length; i++) {
        ItemCount=ItemCount+1;
    }
    if (arr[0]=="edit"){
        if (ItemCount>=2){
           $.messager.alert("提示", "请选择一条记录进行操作!")
           return false;
        }
    }
    if (arr[0]=="remove"){
        if (ItemCount==0){
            $.messager.alert("提示", "请至少选择一条记录进行操作!")
            return false;
        }
    }
    var value = "",
        OrderType = "",
        itemid = "";
    if (select) {
        value = select.id;
        OrderType = mPiece(value, String.fromCharCode(4), 0);
        itemid = value.split(String.fromCharCode(4))[2];
    }
    switch (arr[0]) {
        case "add":
            {
	            var ItemStr=GetItemStr(lstcnt,tabidx)
                var URL = "oeorder.orgfav.prefedit.csp?Type=add&OrderType=" + OrderType + "&itemid=" + itemid + "&EpisodeID=" + GlobalObj.EpisodeID+"&ItemStr="+ItemStr; //lstcnt + "Z" + tabidx
                websys_showModal({
					url:URL,
					title:'增加医嘱',
					width:650,height:400,
					CallBackFunc:function(result){
						var NewOrderType = result.NewOrderType;
		                var NewItemID = result.NewItemID;
		                var rtn=$.cm({
							ClassName:"epr.PreferencesQuery",
							MethodName:"PrefEditItem",
							dataType:"text",
							EditType:'add', objectType:'ObjectType', CONTEXT:GlobalObj.XCONTEXT, SelectPosition:lstcnt + "Z" + tabidx,
							OldOrderType:"", OldItemID:"", NewOrderType:NewOrderType, NewItemID:NewItemID
						},false);
		                if (rtn != "1") {
		                    $.messager.alert("提示", "更新失败:" + rtn);
		                    return;
		                }
		                websys_createWindow(lnkFav + '&TABIDX=0' + '&ObjectType=' + ObjectType + '&PREFTAB=1', 'TRAK_hidden');
					}
				})
                break
            }
        case "remove":
            {
                var $select=jQuery(selector).find(".templateItemSelect")
                var length=$select.length;
                for (var i = 0; i < length; i++) {
                    var value = $select[i].id;
                    var OrderType = mPiece(value, String.fromCharCode(4), 0);
                    var itemid = value.split(String.fromCharCode(4))[2];
                    var rtn=$.cm({
						ClassName:"epr.PreferencesQuery",
						MethodName:"PrefEditItem",
						dataType:"text",
						EditType:'remove', objectType:'ObjectType', CONTEXT:GlobalObj.XCONTEXT, SelectPosition:lstcnt + "Z" + tabidx,
						OldOrderType:OrderType, OldItemID:itemid, NewOrderType:"", NewItemID:""
					},false);
                    if (rtn != "1") {
                        $.messager.alert("提示", "更新失败:" + rtn);
                        break
                    }
                }
                websys_createWindow(lnkFav + '&TABIDX=0' + '&ObjectType=' + ObjectType + '&PREFTAB=1', 'TRAK_hidden');
                break
            }
        case "edit":
            {
                if (itemid == "") {
                    $.messager.alert("提示", "请选择需要修改的项目");
                    break;
                }
                var ItemStr=GetItemStr(lstcnt,tabidx)
                var URL = "oeorder.orgfav.prefedit.csp?Type=edit&OrderType=" + OrderType + "&itemid=" + itemid + "&EpisodeID=" + GlobalObj.EpisodeID+"&ItemStr="+ItemStr;
                /*var result = window.showModalDialog(URL, "", "dialogHeight: " + (370) + "px; dialogWidth: " + (650) + "px");
                if ((typeof result == "undefined") || (typeof result != 'object') || (result == null) || (result.Save == false)) {
                    break;
                }*/
                websys_showModal({
					url:URL,
					title:'修改医嘱',
					width:650,height:400,
					CallBackFunc:function(result){
						var NewOrderType = result.NewOrderType;
		                var NewItemID = result.NewItemID;
		                var rtn=$.cm({
							ClassName:"epr.PreferencesQuery",
							MethodName:"PrefEditItem",
							dataType:"text",
							EditType:'edit', objectType:'ObjectType', CONTEXT:GlobalObj.XCONTEXT, SelectPosition:lstcnt + "Z" + tabidx,
							OldOrderType:OrderType, OldItemID:itemid, NewOrderType:NewOrderType, NewItemID:NewItemID
						},false);
		                if (rtn != "1") {
		                    $.messager.alert("提示", "更新失败:" + rtn);
		                    return;
		                }
		                websys_createWindow(lnkFav + '&TABIDX=0' + '&ObjectType=' + ObjectType + '&PREFTAB=1', 'TRAK_hidden');
					}
				})
                break;
            }
            defaule: {
                $.messager.alert("提示", "操作无效!")
            }
    }
}
function GetItemStr(lstcnt,tabidx){
	var ItemStr="";
	var selector = '#ngroup' + lstcnt + 'Z' + tabidx;
	var select=$(selector).children("label");
	for (var i=0;i<select.length;i++){
		var value=select[i].id;
		var itemid = value.split(String.fromCharCode(4))[2];
		if (ItemStr=="") ItemStr=itemid;
		else ItemStr=ItemStr+"^"+itemid
	}
	return ItemStr;
}
function ResizeGridWidthHeiht(){
	var ActiveHeight=$(window).height()-496;
	$('#CMOrdEntry_DataGrid').setGridHeight(parseInt(ActiveHeight));
}
function escapeJquery(srcString) {
	 // 转义之后的结果
	 var escapseResult = srcString;
	 // javascript正则表达式中的特殊字符
	 var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
	   "]", "|", "{", "}"];

	 // jquery中的特殊字符,不是正则表达式中的特殊字符
	 var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
	   ":", ";", "<", ">", ",", "/"];
	 for (var i = 0; i < jsSpecialChars.length; i++) {
	  escapseResult = escapseResult.replace(new RegExp("\\"
	        + jsSpecialChars[i], "g"), "\\"
	      + jsSpecialChars[i]);
	 }
	 for (var i = 0; i < jquerySpecialChars.length; i++) {
	  escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
	      "g"), "\\" + jquerySpecialChars[i]);
	 }
	 return escapseResult;
}
//******************模版相关 结束**********************//

function CheckFormulaCanAppendItem(OrderARCOSRowid,callBackFun){
    if ((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")&&(PageLogicObj.m_ARCOSRowId!=OrderARCOSRowid)){
		$.messager.alert("提示","正在录入协定处方,不允许添加其他医嘱!","info",function(){
			callBackFun(false); 
		}); 
	}else{
		callBackFun(true);
	}
}
///在输入框按方向键时跳转焦点
function MoveFouce(keycode,FocusRowIndex,FocusGroupIndex,FocusName){
	/*←37;↑38;→39;↓40*/
	var OldFocusRowIndex=FocusRowIndex;
	var OldFocusGroupIndex=FocusGroupIndex
	if ((keycode!="37")&&(keycode!="38")&&(keycode!="39")&&(keycode!="40")) {
		return false;
	}
	if (ItemzLookupGrid&&ItemzLookupGrid.store) return false;
	if (PageLogicObj.LookupPanelIsShow==1) return false;
	var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
	var cbox=$HUI.checkbox("#DrugAndQtyYQ");
	if (cbox.getValue()){
		if(keycode=="37"){
			if (FocusName=="OrderName"){
				if(FocusGroupIndex==1){
				    if (FocusRowIndex>1){
						FocusRowIndex=parseFloat(FocusRowIndex)-1;
						FocusGroupIndex=GlobalObj.ViewGroupSum;
						SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
					}else{
						SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
					}
				}else{
					FocusGroupIndex=parseFloat(FocusGroupIndex)-1;
					SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
				}
			}else if (FocusName=="OrderDoseQty"){
				SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
			}
		}else if (keycode=="38"){
			if (FocusRowIndex>1){
				FocusRowIndex=parseFloat(FocusRowIndex)-1;
			}
			SetFocusColumn(FocusName+""+FocusGroupIndex,FocusRowIndex);
		}else if (keycode=="39"){
			if (FocusName=="OrderName"){
				SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
			}else if (FocusName=="OrderDoseQty"){
				if(FocusGroupIndex==GlobalObj.ViewGroupSum){
					if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
					FocusGroupIndex=1;
					FocusRowIndex=parseFloat(FocusRowIndex)+1;
				}else{
					FocusGroupIndex=parseFloat(FocusGroupIndex)+1;
				}
				SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
			}
		}else if (keycode=="40"){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { return false;}
			if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
			FocusRowIndex=parseFloat(FocusRowIndex)+1;
			SetFocusColumn(FocusName+""+FocusGroupIndex,FocusRowIndex);
		}
	}else{
		if(keycode=="37"){
			if(FocusGroupIndex==1){
			    if (FocusRowIndex>1){
					FocusRowIndex=parseFloat(FocusRowIndex)-1;
					FocusGroupIndex=GlobalObj.ViewGroupSum;
				}
			}else{
				FocusGroupIndex=parseFloat(FocusGroupIndex)-1;
			}
		}else if(keycode=="38"){
			if (FocusRowIndex>1){
				FocusRowIndex=parseFloat(FocusRowIndex)-1;
			}
		}else if(keycode=="39"){
			if(FocusGroupIndex==GlobalObj.ViewGroupSum){
				if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
				FocusGroupIndex=1;
				FocusRowIndex=parseFloat(FocusRowIndex)+1;
			}else{
				FocusGroupIndex=parseFloat(FocusGroupIndex)+1;
			}
		}else if(keycode=="40"){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { return false;}
			if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
			FocusRowIndex=parseFloat(FocusRowIndex)+1;
		}
		SetFocusColumn(FocusName+FocusGroupIndex,FocusRowIndex);
	}
	return true;
	
}

function InitPrescNotes(){
	$("#PrescNotes").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'名称',width:350,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:370,
        isCombo:true,
        minQueryLen:0,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"医嘱录入字典",DDesc:"草药录入备注"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#PrescNotes").val(item.Desc);
		}
    });
}
/*function INSCPackSumInt(GroupIndex, Row,Type,Sum,OrderARCIMRowid){
	if (Sum==""){
		var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
	}
	if (OrderARCIMRowid==""){
		var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
	}
	var RecLoc=$('#RecLoc').combobox('getValue');
	var RecLocDesc=$("#RecLoc").combobox('getText');
	if ((parseInt(Sum).toString() != Sum.toString())) {
        return "";
    } else {
        if (Sum > 1000000) {
            return "";
        }
    }
    var INICrowInfo="";
    var numStr =tkMakeServerCall("web.DHCDocOrderEntryCM","CheckINCIPackSum",GlobalObj.EpisodeID,OrderARCIMRowid, RecLoc,parseFloat(Sum))
    if (numStr != "") {
    	var INICConFacStr=numStr.split(String.fromCharCode(2))[0];
    	    INICrowInfo=numStr.split(String.fromCharCode(2))[1];
    	var minNear=numStr.split(String.fromCharCode(2))[2];
    	var maxNear=numStr.split(String.fromCharCode(2))[3];
    	//if (minNear==0) var minNear=maxNear
        if (INICrowInfo=="") {
            if (Sum=="1"){
            	var FindINICrowInfo=INSCPackSumInt(GroupIndex,Row,"0",maxNear,OrderARCIMRowid)
			    return FindINICrowInfo;
			}else{
	            var lnk="DHCDocSelectCMQty.csp?OrderARCIMRowid="+OrderARCIMRowid+"&RecLoc="+RecLoc+"&minNear="+minNear+"&maxNear="+maxNear;
			    var retval=window.showModalDialog(lnk,"","dialogwidth:400px;dialogheight:150px;status:no;center:1;resizable:yes");
			    if ((retval=="")||(retval==undefined)||(retval==null)||(retval==0)){
					return "";
			    }else{
				    var FindINICrowInfo=INSCPackSumInt(GroupIndex,Row,"0",retval,OrderARCIMRowid)
				    return FindINICrowInfo;
			    }
		    }
        }
    }
    if (INICrowInfo!=""){
	   	return INICrowInfo+"^"+Sum;
	}else{
	    return "";
	}
}*/
function CheckINCIPackSum(GroupIndex,Row,Type,callBackFun) {
	new Promise(function(resolve,rejected){
		var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
		var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
		var RecLoc=$('#RecLoc').combobox('getValue');
		var RecLocDesc=$("#RecLoc").combobox('getText');
	    /*if ((parseInt(Sum).toString() != Sum.toString())) {
	        SetFocusColumn("OrderDoseQty"+GroupIndex,Row);
	        resolve("");
	    } else {*/
	        if (Sum > 1000000) {
	            $.messager.alert("提示","单味药品数量超出范围!","info",function(){
		            SetFocusColumn("OrderDoseQty"+GroupIndex,Row);
		            resolve("");
		        })
	            return;
	        }
	    //}
	    //判断下的数量是不是由药房系数组合
	    //协定处方项目,不检索库存组合
		var INICrowInfo="";
	    var RecLoc=$('#RecLoc').combobox('getValue');
	    var numStr =tkMakeServerCall("web.DHCDocOrderEntryCM","CheckINCIPackSum",GlobalObj.EpisodeID,OrderARCIMRowid, RecLoc,parseFloat(Sum),session['LOGON.HOSPID'])
    	if (numStr != "") {
	    	var INICConFacStr=numStr.split(String.fromCharCode(2))[0];
    	    INICrowInfo=numStr.split(String.fromCharCode(2))[1];
	    	var minNear=numStr.split(String.fromCharCode(2))[2];
	    	var maxNear=numStr.split(String.fromCharCode(2))[3];
    	 	if ((Type=="1")||(INICrowInfo!="")) {
	    	 	resolve(INICrowInfo);
	    	}else{
	            //允许直接选择数量进行录入 提示的地方相应修改
	            var lnk="DHCDocSelectCMQty.csp?OrderARCIMRowid="+OrderARCIMRowid+"&RecLoc="+RecLoc+"&minNear="+minNear+"&maxNear="+maxNear;
	            websys_showModal({
					url:lnk,
					title:'请选择组合数',
					width:400,height:200,
					closable:false,
					CallBackFunc:function(result){
						websys_showModal("close");
						if (result=="") {
							SetFocusColumn("OrderDoseQty"+GroupIndex,Row);
							resolve("");
						}else{
							$("#"+Row+"_OrderDoseQty"+GroupIndex+"").val(result);
							new Promise(function(resolve,rejected){
								CheckINCIPackSum(GroupIndex,Row,0,callBackFun)
							}).then(function(rtnValue){
								callBackFun(rtnValue);
							})
						}
					}
				})
		    }
	    }else{
		    resolve("");
		}
	}).then(function(rtnValue){
		callBackFun(rtnValue);
	})
}

//单元格取值
function GetCellData(rowid, GroupIndex, colname) {
	var id=rowid + "_" + colname + GroupIndex;
    var CellData = "";
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(id);
        if (obj) {
            if (obj.type == "checkbox") {
                if ($("#" + id).prop("checked")) {
                    CellData = "Y";
                } else {
                    CellData = "N";
                }
            } else {
                CellData = $("#" + id).val();
            }
        } else {
            CellData = $("#CMOrdEntry_DataGrid").getCell(rowid, ""+colname+GroupIndex+"");
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            CellData = $("#" + colname).val();
        }
    }
    return CellData;
}
//单元格赋值
function SetCellData(rowid, GroupIndex, colname, data) {
	var id=rowid + "_" + colname + GroupIndex;
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(id);
        if (obj) {
            if (obj.type == "checkbox") {
                // data: true or  false
                var olddata = $("#" + id + "").prop("checked");
                if (data=="Y"){
	                $("#" + id + "").prop("checked", true);
	                }else{
		            $("#" + id + "").prop("checked", false);    
		                }
            } else {
                $("#" + id + "").val(data);
            }
        } else {
	        $("#CMOrdEntry_DataGrid").setCell(rowid, ""+colname+GroupIndex+"", data, "", "", true);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            $("#" + colname + "").val(data);
        }
    }
}
function AddCPWOrdClickHandler(){
	addOrdItemToDoc(GlobalObj.EpisodeID,"C",addOEORIByCPW,GlobalObj.PAAdmType);
}
//添加临床路径医嘱
function addOEORIByCPW(StepItemIDS){
	if (StepItemIDS != '') {
        var ret = cspRunServerMethod(GlobalObj.AddMRCPWItemToListMethod, 'AddCopyItemToList', '', StepItemIDS,session['LOGON.HOSPID'],GlobalObj.EpisodeID);
    }
}
function TreeFilter(index){
	var _$tree=$('#OrdTemplTree');
	var Roots= _$tree.tree('getRoots');
	_$tree.tree('collapseAll');
    for (var i=0;i<Roots.length;i++){
       var _root=Roots[i].target;
       $(_root).show();
       if ((+Roots[i]['id'])!=index) {
	       $(_root).hide();
	   }else{
		   _$tree.tree('expand',_root);
	   }
    }
}
function menuHandler(item){
	var tab = $('#templName_tabs').tabs('getSelected');
	if (tab){
		$('#templName_tabs').tabs('unselect',$('#templName_tabs').tabs('getTabIndex',tab));
	}
	
	TreeFilter(+item['id']);
}
// 药品说明书
function YDTS_Click() {
	if(GlobalObj.HLYYInterface==1){
		HLYYYDTS_Click();
	}
}
function InitOrderNameLookup(rowid){
	$("input[id^='"+rowid+"_OrderName']").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'名称',width:200,sortable:true},
           {field:'SubCategoryDesc',title:'子类',width:100,sortable:true},
           {field:'Price',title:'价格',width:80,sortable:true},
           {field:'BillUOM',title:'单位',width:60,sortable:true},
           {field:'StockQty',title:'库存',width:90,sortable:true},
           {field:'PackedQty',title:'打包数',width:90,sortable:true},
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntryCM',QueryName: 'LookUpItem'},
        rowStyler: function(index,row){
            var Type=row["HIDDEN2"]
            var StockQty=row["StockQty"]
            if ((Type=="ARCIM")&&(StockQty==0)){
	            return 'background-color:#DDA0DD;';
            }
	    },
        onBeforeLoad:function(param){
	        //var CMPrescTypeDetails=$HUI.combobox("#CMPrescType").getValue();
	        var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
			var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
			var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	        var desc=param['q'];
	        if (desc=="") return false;
	        var RelocID=$("#RecLoc").combobox('getValue');
			param = $.extend(param,{Item:desc,GroupID:session['LOGON.GROUPID'],Category:"",SubCategory:"",TYPE:'0',
									LUCategoryDesc:CMPrescTypeCode,LUSubCategoryDesc:"",
									EpisodeID:GlobalObj.EpisodeID,BillingGrp:"",BillingSubGrp:"",RelocID:RelocID,
									OrdCatGrp:"",NonFormulary:"",Form:"",Strength:"",Route:""
									
       				 });
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			new Promise(function(resolve,rejected){
				OrderItemLookupSelect(ItemArr.join("^"),resolve);
			}).then(function(rtn){
				if (rtn==true) {
					var iordertype=item["HIDDEN2"];
					if (iordertype == "ARCIM") {
						DHCDocUseCount(item["HIDDEN"], "User.ARCItmMast");
					}else{
						DHCDocUseCount(item["HIDDEN"], "User.ARCOrdSets")
					}
				}
			})
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			var id=$(this)[0].id; //"1_OrderName2"
			var row=id.split("_")[0];
			var group=id.split("_")[1].split("OrderName")[1];
			var OrderHiddenPara=GetCellData(row,group,"OrderHiddenPara");
			if (OrderHiddenPara!=""){
		        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
		        PageLogicObj.IsARCOSFormula = $.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:ARCIMARCOSRowid
				},false);
		        if (PageLogicObj.IsARCOSFormula=="1") return false;
		    }else{
		    	if ((PageLogicObj.IsARCOSFormula=="1")&& (GlobalObj.FormulaCanAppendItem=="0")) return false;
		    }
		}
    });
}
function InitLayOut() {
	//根据是否启用合理用药来显示【说明书】按钮
	if (GlobalObj.HLYYInterface==0){
		$("#YDTS").hide();
		$("#YDTS").parent().prev().hide()
	}else{
		$("#YDTS").show();
		$("#YDTS").parent().prev().show()
	}
}
//记录基础代码数据使用次数
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
function CMOrderOpenForAllHospClick(e,value){
	setTimeout(function(){
		//var PrescCookDecoctionFlag=$("#PrescCookDecoction").checkbox('getValue')?1:0;
		var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
		var DetailsArr=CMPrescTypeDetails.split("#");
		if ($("#CMOrderOpenForAllHosp").length==1){
			var CMOrderOpenForAllHospFlag=$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0;
		}else{
			var CMOrderOpenForAllHospFlag=0;
		}
		var CMRecLocStr=DetailsArr[6];
		var OpenHospCMRecLocStr=DetailsArr[15];
    	//var CNMedCookReclocStr=DetailsArr[7];
    	//var OpenHospCNMedCookReclocStr=DetailsArr[16];
    	var CookModeReclocStr="";OpenHospCookModeReclocStr="";
    	var CookMode=$('#CookModelist').combobox('getValue'); 
    	var CookModelist=$('#CookModelist').combobox('getData'); 
    	for (i=0;i<CookModelist.length;i++){
			if (CookModelist[i].RowID==CookMode){
				CookModeReclocStr=CookModelist[i].CookModeReclocStr;
				OpenHospCookModeReclocStr=CookModelist[i].OpenHospCookModeReclocStr;
				break;
			}
	    }
    	var RecLocStr="";
    	if (CMOrderOpenForAllHospFlag==1){
	    	RecLocStr=OpenHospCMRecLocStr
	    	if (OpenHospCookModeReclocStr!="") RecLocStr=RecLocStr+"!"+OpenHospCookModeReclocStr;
	    	/*if ((PrescCookDecoctionFlag==1)&&(OpenHospCNMedCookReclocStr!="")){
		        RecLocStr=OpenHospCNMedCookReclocStr;
		    }else{
		        RecLocStr=OpenHospCMRecLocStr;
		    }*/
	    }else{
		    RecLocStr=CMRecLocStr;
		    if (CookModeReclocStr!="") RecLocStr=RecLocStr+"!"+CookModeReclocStr;
		    /*if ((PrescCookDecoctionFlag==1)&&(CNMedCookReclocStr!="")){
		        RecLocStr=CNMedCookReclocStr;
		    }else{
		        RecLocStr=CMRecLocStr;
		    }*/
		}
		RecLocStr=RecLocStr.replace(/[!]/g, String.fromCharCode(2))
	    RecLocStr=RecLocStr.replace(/[@]/g, String.fromCharCode(1))
	    SetRecLoc(RecLocStr);
	    ///在这里进行处方类型转换，保证获取到正确的接受科室
    	AutoConvertPrescForm();
	})
}
///进行处方和诊断信息的关联
function OpenSelectDia(EpisodeID,OEOrdItemIDs){
  var precnum=tkMakeServerCall("web.DHCDocDiagLinkToPrse","getAllCheckDiaPrce",EpisodeID,session['LOGON.USERID'],OEOrdItemIDs) 
  if (precnum!=""){
	  //若诊断数量为1,则直接进行诊断与处方关联
	  var GridData=$.cm({
			ClassName:"web.DHCDocDiagLinkToPrse",
			QueryName:"GetDiaQuery",
			Adm:EpisodeID,
			Type:"ALL",
			rows:99999
	  },false);
	  var total=GridData['total'];
	  if (total==1){
		  var rtn=$.cm({
				ClassName:"web.DHCDocDiagLinkToPrse",
				MethodName:"Insert",
				dataType:"text",
				PrescNoStr:precnum,
				DiagIdStr:GridData['rows'][0]['diaid'],
				UserDr:session['LOGON.USERID'],
		   },false);
	  }else{
		  if (total==0) return;
		  var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+precnum; //+"&ExitFlag="+"Y"
		  var awidth=screen.availWidth/6*5; 
		  var aheight=screen.availHeight/5*4; 
		  websys_showModal({
			 url:url,
			 title:'处方关联诊断',
			 width:awidth,height:aheight
		  })
	  }
   }
}
///实习生审核医嘱
function InsertPriceAdd() {
	var OrderItemStr=""
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected')[0].id;
	var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
	var PrescInstruction=$("#PrescInstruction").combobox('getValue');
	var PrescDuration=$("#PrescDuration").combobox('getValue');
	var AddLongOrderList=$("#AddLongOrderList").combobox('getValue');
	var PrescOrderQty=$("#PrescOrderQty").combobox('getText');
	var PrescPrior=$("#PrescPrior").combobox('getValue');
	var RecLoc=$("#RecLoc").combobox('getValue');
	var PrescNotes=$('#PrescNotes').val();
	var PrescUrgent=$HUI.checkbox("#PrescUrgent").getValue();
	var PrescCookDecoction=$('#CookModelist').combobox('getValue'); //$HUI.checkbox("#PrescCookDecoction").getValue();
	var DrugAndQtyYQ=$HUI.checkbox("#DrugAndQtyYQ").getValue();
	var DrugAndQtySplit=$HUI.checkbox("#DrugAndQtySplit").getValue();
	var PrescAppenItemQty=$('#PrescAppenItemQty').val();
	var CMOrderOpenForAllHosp=$HUI.checkbox("#CMOrderOpenForAllHosp").getValue(); //跨院
	OrderItemStr=CMPrescTypeKWSel + String.fromCharCode(4) +  PrescFreqRowid+ String.fromCharCode(4) +PrescInstruction  + String.fromCharCode(4) + PrescDuration+ String.fromCharCode(4) +AddLongOrderList + String.fromCharCode(4) + PrescOrderQty
	OrderItemStr=OrderItemStr + String.fromCharCode(4) +  PrescPrior+ String.fromCharCode(4) +PrescAppenItemQty+String.fromCharCode(4)+RecLoc  + String.fromCharCode(4) + PrescNotes + String.fromCharCode(4) + PrescUrgent
	OrderItemStr=OrderItemStr + String.fromCharCode(4) +  PrescCookDecoction+ String.fromCharCode(4) +DrugAndQtyYQ  + String.fromCharCode(4) + DrugAndQtySplit + String.fromCharCode(4) +CMOrderOpenForAllHosp
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
		   if (OrderARCIMRowid!=""){
			    var OrderName=GetCellData(i,j,"OrderName");
			    var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
			    var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr"); //$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
			    var OrderPrice=GetCellData(i,j,"OrderPrice");
			    var OrderItemSum=GetCellData(i,j,"OrderSum");
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				var OrderDoseUOM=GetCellData(i,j,"OrderDoseUOM");
                if (OrderDoseQty==""){OrderDoseUOMRowid=""}
                var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns"); 
				OrderItem=OrderARCIMRowid+","+OrderName+","+OrderDoseQty+","+OrderDoseUOM+","+OrderPrice +","+OrderItemSum+","+OrderHiddenPara+","+OrderPhSpecInstr+","+OrderCoverMainIns;
				if (OrderItemStr==""){OrderItemStr=OrderItem}else{OrderItemStr=OrderItemStr+String.fromCharCode(4)+OrderItem}
		   }
	    }
	}
	var Rtn = cspRunServerMethod(GlobalObj.InsertPrcaticeDocMethod,GlobalObj.EpisodeID,OrderItemStr,session["LOGON.USERID"],"C")
	return true;
}
//展示实习生页面
function ShowPracticeOrder() {
    if (GlobalObj.EpisodeID) {
        websys_showModal({
			url:"ipdoc.practicedocpreorder.hui.csp?EpisodeID=" + GlobalObj.EpisodeID+"&PageType=C" ,
			title:'实习生医嘱处理',
			width:screen.availWidth-200,height:screen.availHeight-200,
			AddPracticeOrder:AddPracticeOrder
		});
    }
}
function AddPracticeOrder(PracticePreary,RowidStr){
	ClearClickHandler();
	var PracticePrearyArry=PracticePreary.split(String.fromCharCode(4))
	$("#CMPrescTypeKW").keywords('select',PracticePrearyArry[0]);
	$HUI.checkbox("#CMOrderOpenForAllHosp").setValue(PracticePrearyArry[14]=="true"?true:false);
	setTimeout(function(){
		var sbox = $HUI.combobox("#PrescFrequence");
		sbox.select(PracticePrearyArry[1]);
		var sbox = $HUI.combobox("#PrescInstruction");
		sbox.select(PracticePrearyArry[2]);
		var sbox = $HUI.combobox("#PrescDuration");
		sbox.select(PracticePrearyArry[3]);
		var sbox = $HUI.combobox("#AddLongOrderList");
		sbox.select(PracticePrearyArry[4]);
		var sbox = $HUI.combobox("#PrescOrderQty");
		sbox.setText(PracticePrearyArry[5]); //select
		var sbox = $HUI.combobox("#PrescPrior");
		sbox.select(PracticePrearyArry[6]);
		var sbox = $HUI.combobox("#RecLoc");
		sbox.select(PracticePrearyArry[8]);
		$('#PrescNotes').val(PracticePrearyArry[9]);
		$HUI.checkbox("#PrescUrgent").setValue(PracticePrearyArry[10]=="true"?true:false);
		$("#CookModelist").combobox('setValue',PracticePrearyArry[11]);
		//$HUI.checkbox("#PrescCookDecoction").setValue(PracticePrearyArry[11]=="true"?true:false);
		$HUI.checkbox("#DrugAndQtyYQ").setValue(PracticePrearyArry[12]=="true"?true:false);
		$HUI.checkbox("#DrugAndQtySplit").setValue(PracticePrearyArry[13]=="true"?true:false);
		
		setTimeout(function(){
			$('#PrescAppenItemQty').val(PracticePrearyArry[7]);
		})
		FocusRowIndex=1
		FocusGroupIndex=1
		for(var i=15;i<PracticePrearyArry.length;i++){
			FindNullCell();
			var OrderStr=PracticePrearyArry[i]
			var OrderStry=OrderStr.split(",")
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderName",OrderStry[1]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseQty",OrderStry[2]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID",OrderStry[0]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPrice",OrderStry[4]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseUOM",OrderStry[3]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderSum",OrderStry[5]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara",OrderStry[6]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr",OrderStry[7]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderCoverMainIns",OrderStry[8]);
			SetScreenSum();
			FocusGroupIndex=FocusGroupIndex+1
			if (FocusGroupIndex>GlobalObj.ViewGroupSum){
				FocusRowIndex=FocusRowIndex+1
				FocusGroupIndex=1
			}
		}
		PageLogicObj.PractiacRowStr=RowidStr;
	})
}
///校验能否将该条医嘱添加到行上
function CheckItemCongeries(ItemToListDetailObj){
	var CheckBeforeAddObj={
		SuccessFlag:true,				//是否需要继续审核医嘱
		UserOptionObj:new Array()
	}
	var CallBakFunS=ItemToListDetailObj.CallBakFunS;
	new Promise(function(resolve,rejected){
		///执行回调方法
		if (typeof ItemToListDetailObj.CallBakFunS=="object"){
			///先进行判断是否有需要递归的后处理
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
						var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
						ExeItemCongeriesUserOption(CallBakFunCode,CallBakFunParams,resolve);
					}).then(function(UserOptionObj){
						if (!$.isEmptyObject(UserOptionObj)){
							CheckBeforeAddObj.UserOptionObj.push(UserOptionObj);
						}						
						i++;
						if ( i < CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (CheckBeforeAddObj.UserOptionObj.length>0){
				resolve();
			}else{
				if (typeof CallBakFunS=="object"){
					///再进行判断是否需要继续进行普通的后处理
					(function(callBackExecFun){
						function loop(i){
							new Promise(function(resolve,rejected){
								var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
								var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
								ExeItemCongeriesCallBackFun(CallBakFunCode,CallBakFunParams,resolve);
							}).then(function(ReturnObj){
								if (ReturnObj.SuccessFlag==false){
									CheckBeforeAddObj.SuccessFlag=false;
									callBackExecFun();
								}else{
									i++;
									if ( i < CallBakFunS.length ) {
										 loop(i);
									}else{
										callBackExecFun();
									}
								}
							})
						}
						loop(0);
					})(resolve);
				}else{
					resolve();
				}
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (CheckBeforeAddObj.UserOptionObj.length>0){
				resolve();
			}else{
				var ErrCode=ItemToListDetailObj.ErrCode;
				var ErrMsg=ItemToListDetailObj.ErrMsg;
				if ((CheckBeforeAddObj.SuccessFlag==false)||(ErrCode==0)){
					resolve();
				}else{
					if (ErrCode!="0"){
						$.messager.alert("提示",ErrMsg,"info",function(){
							$.extend(CheckBeforeAddObj, {SuccessFlag:false});
							resolve();
						});
					}
				}
			}
		})
	}).then(function(){
		ItemToListDetailObj.callBackFun(CheckBeforeAddObj)
	})
	function ExeItemCongeriesUserOption(FunCode,FunCodeParams,CallBackFun){
		///-------
		//被设计用来反插后台查询方法，用于对后续计算有影响的confirm计算，
		//每次对这个值进行新属性的赋值，都需要在后台计算中加上对应的处理
		//UserOptionOb应至少包含两个固定属性{Type:"",Value:""},用于后台方法识别
		var UserOptionObj={};
		new Promise(function(resolve,rejected){
			var ParamsArr=FunCodeParams.split(";");
			switch(FunCode)
			{
				case "SelectCMDoseQty": //弹出草药组合数界面
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							ShowSelectCMDoseQty(ParamsArr,resolve);
						}).then(function(OrderDoseQty){
							if (OrderDoseQty!="") {
								$.extend(UserOptionObj,{Type:"SelectCMDoseQty",Value:OrderDoseQty,ARCIMRowId:ParamsArr[1]});
							}
							callBackFunExec();
						})
					})(resolve); //此处的resolve指的是FunObj.CallBackFun(UserOptionObj);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(UserOptionObj);
		})
	}
	/*
	用于additemtolist方法的回调，注意：
	为兼容快速医嘱套录入模式，此方法中不能直接对行数据进行操作，如需对数据操作，请使用返回对象，操作ParamObj
	*/
	function ExeItemCongeriesCallBackFun(FunCode,FunCodeParams,CallBackFun){
		var ReturnObj={SuccessFlag:true}
		var ParamsArr=FunCodeParams.split(";");
		new Promise(function(resolve,rejected){
			switch(FunCode)
			{
				case "Alert":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.alert("提示",ParamsArr.join(";"),"info",function(){
								callBackFunExec();
							});
						})
					})(resolve); //此处的resolve指的是FunObj.CallBackFun(ReturnObj);
					break;
				case "Confirm" :
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('确认对话框', FunCodeParams, function(r){
								if (!r) {
									ReturnObj.SuccessFlag=false;
								}
								callBackFunExec();
							});
						})
					})(resolve);
					break;	
				case "SwitchCMPrescTypeKW" :
					(function(callBackFunExec){
						var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
						var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
						var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
						if (ParamsArr[1]!=CMPrescTypeCode){
							$.messager.confirm('确认对话框', ParamsArr[0], function(r){
								if (r) {
									$("#CMPrescTypeKW").keywords('select',ParamsArr[1]);
									ReturnObj.SuccessFlag=true;
								}else{
									ReturnObj.SuccessFlag=false;
								}
								callBackFunExec();
							});
						}else{
							ReturnObj.SuccessFlag=true;
							callBackFunExec();
						}
					})(resolve);
					break;
				case "CheckPoison":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							websys_showModal({
								url:"dhcdoccheckpoison.csp?PatID=" + GlobalObj.EpisodeID,
								title:'毒麻处方信息验证',
								width:530,height:290,
								closable:false,
								CallBackFunc:function(retval){
									websys_showModal("close");
									if (typeof retval=="undefined"){
										retval="";
									}
									if (retval!="") {
										var encmeth = GlobalObj.UpdateAgencyInfoMethod;
						                if (encmeth != "") {
							                var rtn = $.cm({
												ClassName:"web.DHCDocCheckPoison",
												MethodName:"UpdateAgencyInfo",
												dataType:"text",
												EpisodeID:GlobalObj.EpisodeID,
												PatInfo:retval
											},false)
						                    if (rtn == "-100") {
							                    $.messager.alert("提示",FunCodeParams + t['POISONSAVE_FAILED'],"info",function(){
													ReturnObj.SuccessFlag=false;
													resolve();
												});
						                    }else{
							                    resolve();
							                }
						                }else{
							                resolve();
							            }
									}else{
										$.messager.alert("提示",FunCodeParams + t['POISON_ALERT'],"info",function(){
											ReturnObj.SuccessFlag=false;
											resolve();
										});
									}
								}
							})
						}).then(function(){
							callBackFunExec();
						})
					})(resolve);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(ReturnObj);
		})
	}
}
function AddItemDataToRow(RowIndex,GroupIndex,ParamObj){
	SetCellData(RowIndex,GroupIndex,"OrderName",ParamObj.OrderName);
	SetCellData(RowIndex,GroupIndex,"OrderDoseQty",ParamObj.OrderDoseQty);
	SetCellData(RowIndex,GroupIndex,"OrderARCIMID",ParamObj.OrderARCIMRowid);
	SetCellData(RowIndex,GroupIndex,"OrderPrice",ParamObj.OrderPrice);
	SetCellData(RowIndex,GroupIndex,"OrderDoseUOM",ParamObj.PHCDoseUOMDesc);
	SetCellData(RowIndex,GroupIndex,"OrderHiddenPara",ParamObj.OrderHiddenPara);
	SetCellData(RowIndex,GroupIndex,"OrderSum",ParamObj.OrderSum);
	SetCellData(RowIndex,GroupIndex,"OrderPhSpecInstr",ParamObj.OrderPhSpecInstr);
	PageLogicObj.IsARCOSFormula=ParamObj.IsARCOSFormula;
	if (ParamObj.IsARCOSFormula==1){
	   ChangeRowStyle1(RowIndex,GroupIndex,true);
	}
	SetCellData(RowIndex,GroupIndex,"OrderCoverMainIns",ParamObj.OrderCoverMainIns);
	return true;
}
function ShowSelectCMDoseQty(ParamsArr,callBackFun) {
	var lnk="DHCDocSelectCMQty.csp?OrderARCIMRowid="+ParamsArr[1]+"&RecLoc="+ParamsArr[2]+"&minNear="+ParamsArr[3]+"&maxNear="+ParamsArr[4];
	websys_showModal({
		url:lnk,
		title:'草药数量选择',
		width:400,height:200,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
function SetTimeLog(FunctionName, Position){
	var myDate = new Date();
    var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();
    var TimeLogStr = 'FunctionName:' + FunctionName + ',Position:' + Position + ',DateTime:' + DateTime;
    console.log(TimeLogStr);
    return;
}
function CheckBeforeSaveToServer(OrderItemStr,callBackFun) {
    var UserAddRowid = session['LOGON.USERID'];
    var UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GlobalObj.LogonDoctorID
    var LogonDep = "";
    var FindRecLocByLogonLoc=$("#FindByLogDep").checkbox("getValue")?1:0;
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    var OrderOpenForAllHosp = $("#CMOrderOpenForAllHosp").checkbox("getValue")?1:0;
    var ExpStr = "" +"^"+LogonDep+"^"+OrderOpenForAllHosp;
    
    var ret = cspRunServerMethod(GlobalObj.CheckBeforeSaveMethod, GlobalObj.EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr,1)
    var CheckResultObj=jQuery.parseJSON(ret);
    
	/*var ErrCode=CheckResultObj.ErrCode; //1
	var ErrMsg=CheckResultObj.ErrMsg;	//2
    var ErrCellPosi=CheckResultObj.cellPosi;	//3
    var FocusCol=CheckResultObj.FocusCol;//4
    var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;//4*/
	var CheckBeforeSaveObj={
		isAfterCheckLoadDataFlag:false,	//前台是否需要重载数据
		SuccessFlag:true				//是否需要继续审核医嘱
	}
	new Promise(function(resolve,rejected){
		//执行回调方法
		var CallBakFunS=CheckResultObj.CallBakFunS;
		if (typeof CallBakFunS=="object"){
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var FunCode=CallBakFunS[i].CallBakFunCode;
						var FunCodeParams=CallBakFunS[i].CallBakFunParams;
						var Row=CheckResultObj.ErrCode;
						CheckAfterCheckMethod(FunCode,FunCodeParams,Row,resolve);
					}).then(function(ReturnObj){
						if (ReturnObj.isAfterCheckLoadDataFlag){
							CheckBeforeSaveObj.isAfterCheckLoadDataFlag=true;
						}
						if (ReturnObj.SuccessFlag==false){
							CheckBeforeSaveObj.SuccessFlag=false;
							callBackExecFun();
							return;
						}
						i++;
						if ( i < CheckResultObj.CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrMsg=CheckResultObj.ErrMsg;
		    var ErrCellPosi=CheckResultObj.cellPosi;
		    var FocusCol=CheckResultObj.FocusCol;
			if (ErrMsg!=""){
			    if ((ErrCellPosi)&&(FocusCol!="")){
					$.messager.alert("提示", ErrMsg, "warning", function() {
						var FocusRow=ErrCellPosi.split(";")[0];
						var FocusCellCol=ErrCellPosi.split(";")[1];
						SetFocusColumn(FocusCol+FocusCellCol,FocusRow);
						resolve();
				    });
				}else if((ErrCellPosi=="")&&(FocusCol!="")){
					$.messager.alert("提示", ErrMsg, "warning", function() {
						$("#"+FocusCol).focus();
						resolve();
				    });
				}else{
					$.messager.alert("提示",ErrMsg,"info",function(){
						resolve();
					});
				}
		    }else{
			    resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrCode=CheckResultObj.ErrCode;
			if ((parseInt(ErrCode)<0)){
				CheckBeforeSaveObj.SuccessFlag=false;
			}
			var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;
			if (NeedCheckDeposit) {
		        var amount=$("#ScreenBillSum").val();
		        if (!CheckDeposit(amount, "")) {
		            CheckBeforeSaveObj.SuccessFlag=false;
		        }
		    }
		    resolve();
		})
	}).then(function(){
		callBackFun(CheckBeforeSaveObj);
	})
}
function CheckAfterCheckMethod(FunCode,FunCodeParams,Row,CallBackFun){
	var ReturnObj={
		isAfterCheckLoadDataFlag:false,
		SuccessFlag:true
	}
	var ParamsArr=FunCodeParams.split(",");
	new Promise(function(resolve,rejected){
	    switch(FunCode)
	    {
			case "Confirm" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.confirm('确认对话框', FunCodeParams, function(r){
							if (r) {
								ReturnObj.SuccessFlag=true;
							}else{
								ReturnObj.SuccessFlag=false;
							}
							callBackFunExec();
						});
					})
				})(resolve); //此处的resolve指的是CheckAfterCheckObj.CallBackFun(FunObj.ReturnObj);
				break;
			default:
				resolve();
				break;
		}
	}).then(function(){
		CallBackFun(ReturnObj);
	})
}

function InitPatOrderViewGlobalCM(EpisPatInfo){
	var EpisPatObj=eval("("+EpisPatInfo+")");
	$.extend(GlobalObj,EpisPatObj);
	var adm=GetMenuPara("EpisodeID");
	var FixedEpisodeID="";
	if ((parent)&&((parent.FixedEpisodeID)&&(typeof parent.FixedEpisodeID!="undefined"))){
		FixedEpisodeID=parent.FixedEpisodeID;
	}
	if ((parent.parent.FixedEpisodeID)&&(typeof parent.parent.FixedEpisodeID!="undefined")){
		FixedEpisodeID=parent.parent.FixedEpisodeID;
	}
	// 若标识switchSysPat为N,用的是request内的病人,且不能切换病人
	if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
		FixedEpisodeID=EpisPatObj.EpisodeID;
	}
	if ((adm!=GlobalObj.EpisodeID)&&((FixedEpisodeID=="")||((FixedEpisodeID!="")&&(FixedEpisodeID!=GlobalObj.EpisodeID)))){
		//xhrRefresh("",adm,"")
		var Url=window.location.href;
		 Url=rewriteUrl(Url, {
	        EpisodeID:GetMenuPara("EpisodeID"),
        	PatientID:GetMenuPara("PatientID"),
        	mradm:GetMenuPara("mradm"),
        	EpisodeIDs:"",
        	copyOeoris:"",
        	copyTo:""});
        history.pushState("", "", Url);
        window.location.reload();
		return;
	}
	
	var warning="";
	if (GlobalObj.warning != ""){
		warning=GlobalObj.warning;
	}
	$("#CardBillCardTypeValue").val(GlobalObj.CardBillCardTypeValue);
	if (warning!=""){
		$("#Prompt").css("display","");
		$("#Prompt").text(warning);
	}else{
		$("#Prompt").css("display","none");
	}
	if (GlobalObj.CPWOrdFlag=="1") {
		$("#Add_CPWOrd").show();
	}else{
		$("#Add_CPWOrd").hide();
	}
}
//使用局部刷新,这样除第一次渲染较慢重复使用较快
function xhrRefresh(Args){
	//console.log("xhrRefresh"+Args.adm)
	$(".messager-button a").click(); //自动关闭上一个患者的alert弹框
	//关闭所有的dialog,window,message
	$(".panel-body.window-body").each(function(index,element){
		if (("^TemplateDetail^").indexOf($(element).attr("id"))==-1){
			$(element).window("destroy");
		}
	});
	//有可能是诊疗界面没有配置CheckLinkDetails,会在这个地方切换失败，在这不能局部刷新了，要重置url
	if (typeof GlobalObj=="undefined"){
		window.location.reload();
		return;
	}
	CopyOeoriDataArr = new Array();
	if ((typeof Args.copyOeoris !="undefined")&&(Args.copyOeoris !="")){
		var copyOeorisArr=Args.copyOeoris.split("^");
		for (var i = 0; i < copyOeorisArr.length; i++) {
			var dataItem = tkMakeServerCall("web.DHCDocMain", "CreateCopyItem", copyOeorisArr[i],"");
			//var dataItem = copyOeorisArr[i];
			if (dataItem=="") continue
			CopyOeoriDataArr.push(dataItem);
		}
	}
	
	var papmi=GetMenuPara("PatientID");
	var adm=GetMenuPara("EpisodeID");
	if ((adm==GlobalObj.EpisodeID)||(adm=="")){
		var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", adm,GlobalObj.EmConsultItm);
		var EpisPatObj=eval("("+EpisPatInfo+")");
		InitPatOrderViewGlobalCM(EpisPatInfo);
		if (CopyOeoriDataArr.length>0){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		HideWindowMask();
		return
	}
	$(".window-mask.alldom").show();
	//$(".window-mask.alldom").height();
	var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", adm,GlobalObj.EmConsultItm);
	var EpisPatObj=eval("("+EpisPatInfo+")");
	///以下情况务必走强制刷新，保证界面样式正确变化
	if (
		(EpisPatObj.PAAdmType!=GlobalObj.PAAdmType)||
		(EpisPatObj.CPWOrdFlag!=GlobalObj.CPWOrdFlag)
	){
		if (typeof(history.pushState) === 'function') {
	        var Url=window.location.href;
	        Url=rewriteUrl(Url, {
		        EpisodeID:EpisPatObj.EpisodeID,
	        	PatientID:EpisPatObj.PatientID,
	        	mradm:EpisPatObj.mradm,
	        	EpisodeIDs:"",
	        	copyOeoris:"",
	        	copyTo:""});
	        history.pushState("", "", Url);
	        window.location.reload();
	        return;
	    }
	}
	//推到堆栈，保证遮罩优先展示--PB by tanjishan 担心出现多个患者伪并发到这步
	window.requestAnimationFrame(function(){
		DocumentUnloadHandler();
		InitPatOrderViewGlobalCM(EpisPatInfo);
		$('#CMOrdEntry_DataGrid').jqGrid('clearGridData');
		var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if(records==0){
			Add_CMOrdEntry_row();
		}
		InitPrescriptTypeBillList();
		//处方类型改变时需要修改其它combobox的默认值,故初始化时需在所有元素加载完之后进行
		InitCMPrescType(GlobalObj.CMPrescTypeStrStr);
		//清除除CMPrescTypeChangeHandler中赋值以外的其他元素的值
		$("#PrescNotes").val("");
		$("#PrescUrgent").checkbox('setValue',false);
		
		if (GlobalObj.PracticeShowFlag>0){
	    	ShowPracticeOrder();
	    }
		///以下组件需要基于各自组件的初始化，所以不能放到InitPatOrderViewGlobalCM中
		ReloadPrescListData();
		if (GlobalObj.CurrentDischargeStatus=="B") {
			$("#AddLongOrderList").combobox('select','').combobox("disable");
	   	}else{
			$("#AddLongOrderList").combobox("disable",false);
		}
		
		//从门诊诊疗复制医嘱界面复制
		if (('undefined' !== typeof CopyOeoriDataArr)&&(CopyOeoriDataArr.length>0)){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		InitBtnDisplay();
		HideWindowMask();
	});
}
function ReloadPrescListData(){
	var PrescListArr=new Array();
    var ArrData = GlobalObj.PrescList.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]=="") continue;
        var value=ArrData1[0]+"^"+ArrData1[2];
		PrescListArr.push({"value":value, "desc":ArrData1[1]});
    }
	$HUI.combobox("#PrescList", {data:PrescListArr});
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
function HideWindowMask(){
	$(".window-mask.alldom").hide();
}
function InitPrescriptTypeBillList(){
	if (GlobalObj.PrescriptTypes!=""){
		clearTab();
		//var PrescriptTypesArr=[];
		var defaultIndex="",defaultBilltype="";
	    var PrescriptTypesCount=GlobalObj.PrescriptTypes.split("||").length;
	    for (var i=0;i<PrescriptTypesCount;i++){
		    var PrescriptTypeTemp=GlobalObj.PrescriptTypes.split("||")[i];
		    var presctypebilltypeid=PrescriptTypeTemp.split(PrescTypeDetailDelim)[4];
		    var presctypedesc=PrescriptTypeTemp.split(PrescTypeDetailDelim)[2];
		    var presctypedefault=PrescriptTypeTemp.split(PrescTypeDetailDelim)[7];
		    var selected=false
		    if (presctypedefault=="Y") {
			    selected=true;
			    defaultIndex=i;
			    defaultBilltype=presctypebilltypeid;
			}
		    $('#PrescriptTypeBillList').tabs('add',{    
			    title:presctypedesc,    
			    content:'',
			    closable:false,   
			    selected:selected
			})
			//PrescriptTypesArr.push({"id":presctypebilltypeid,"text":presctypedesc,"selected":selected});
			PageLogicObj.m_selTabIndex=i;
			GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
		}
		//切换病人时重复初始化改元素会导致元素样式异常
		/*if ($('#PrescriptTypeBillList').hasClass('combobox-f')){
			$('#PrescriptTypeBillList').combobox('clear').combobox('loadData',PrescriptTypesArr);
		}else{
			$('#PrescriptTypeBillList').combobox({
				valueField:'id',   
		    	textField:'text',
		    	editable:false,
		    	data:PrescriptTypesArr,
		    	onSelect:function(record){
					PrescTypeBillChange(record["id"]);
				}
			});
		}*/
		if (defaultBilltype==""){
			PageLogicObj.m_selTabIndex=0;
			GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
		}else{
			PageLogicObj.m_selTabIndex=defaultIndex;
			GlobalObj.OrderBillTypeRowid=defaultBilltype;
		}
	}else{
		GlobalObj.OrderBillTypeRowid=GlobalObj.DefaultBilltype;
	}
}

function InitBtnDisplay(){
	if (GlobalObj.EnableButton == 0) {
		DisableBtn("Update",true);
	    DisableBtn("Delete_Order_btn",true);
	    DisableBtn("Add_Order_btn",true);
	}else{
		DisableBtn("Update",false);
	    DisableBtn("Delete_Order_btn",false);
	    DisableBtn("Add_Order_btn",false);
	}
}
function ReloadFrameData() {
	$(".window-mask.alldom").show();
	window.requestAnimationFrame(function(){
		$.extend(PageLogicObj,{IsARCOSFormula:0,m_ARCOSRowId:""}); //,m_selTabIndex:""
		var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", GlobalObj.EpisodeID,GlobalObj.EmConsultItm);
		InitPatOrderViewGlobalCM(EpisPatInfo);
		$('#CMOrdEntry_DataGrid').jqGrid('clearGridData');
		var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if(records==0){
			Add_CMOrdEntry_row();
		}
		$("#PrescUrgent,#CMOrderOpenForAllHosp").checkbox("uncheck");
		$("#PrescList").combobox('select','clear');
		$("#PrescPrior").combobox('loadData',JSON.parse(GlobalObj.PrescPriorJson));
		ReloadPrescListData();
		$("#PrescList,#AddLongOrderList").combobox('select','');
		/*if ($("#CMPrescTypeKW").keywords('getSelected').length>0){
			var SelCMPrescTypeKW=$("#CMPrescTypeKW").keywords('getSelected')[0].id;
			$("#CMPrescTypeKW").keywords('select',SelCMPrescTypeKW);
		}*/
		$("#PrescNotes").lookup('setText',"");
		InitCMPrescType(GlobalObj.CMPrescTypeStrStr);
		InitPrescriptTypeBillList();
		HideWindowMask();
		if (GlobalObj.PAAdmType=="I"){
		   if (GlobalObj.CurrentDischargeStatus=="B") {
			   $("#AddLongOrderList").combobox('select','').combobox("disable");
		   }
	    }
	});
}
function clearTab(){
	var tabs=$('#PrescriptTypeBillList').tabs("tabs");
	for (var i=tabs.length;i>=0;i--) {
		$('#PrescriptTypeBillList').tabs("close",i);
	}
}
function GetNewFocusIndex(){
	if (+FocusRowIndex==0) FocusRowIndex=1;
	if (+FocusGroupIndex==0) FocusGroupIndex=1;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	var Find=0;
	for (var i=FocusRowIndex; i<=rows; i++){
		for (var j=FocusGroupIndex; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid=="") {
				FocusRowIndex=i;
				FocusGroupIndex=j;
				Find=1;
				break;
			}
		}
		if (Find==1) break;
	}
	var FocusObj={
		FocusRowIndex:FocusRowIndex,
		FocusGroupIndex:FocusGroupIndex
	}
	return FocusObj;
}
function GetPreCMPrescTypeDataObj(){
	if (PageLogicObj.PreCMPrescTypeCode=="") return;
	var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
	var PrescInstrRowid=$('#PrescInstruction').combobox("getValue");
	var PrescDurRowid=$('#PrescDuration').combobox("getValue");
	var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
	var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
    var PrescNotes=$('#PrescNotes').val();
    var PrescCookDecoction=$('#CookModelist').combobox('getValue');
    PreCMPrescTypeDataObj[PageLogicObj.PreCMPrescTypeCode]={};
    $.extend(PreCMPrescTypeDataObj[PageLogicObj.PreCMPrescTypeCode], {
	    PrescFrequence:PrescFreqRowid,
	    PrescInstruction:PrescInstrRowid,
	    PrescDuration:PrescDurRowid,
	    PrescOrderQty:PrescOrderQty,
	    CMOrderOpenForAllHosp:$("#CMOrderOpenForAllHosp").checkbox('getValue'),
	    RecLoc:OrderRecDepRowid,
	    PrescNotes:PrescNotes,
	    CookModelist:PrescCookDecoction
	});
}
function SetPreCMPrescTypeData(CMPrescTypeCode){
	if (!$.isEmptyObject(PreCMPrescTypeDataObj[CMPrescTypeCode])) {
		var dataObj=PreCMPrescTypeDataObj[CMPrescTypeCode];
		for ( var id in dataObj) {
			setValue(id,dataObj[id]);
		}
	}
	$.extend(PreCMPrescTypeDataObj[CMPrescTypeCode], {});
}
///根据元素的classname赋值
function setValue(id,value){
	var _$id=$("#"+id)
	var className=_$id.attr("class")
	if(typeof className =="undefined"){
		_$id.val(value);
		return;
	}
	if(className.indexOf("hisui-lookup")>=0){
		_$id.lookup('setText',value);
	}else if(className.indexOf("combobox-f")>=0){
		_$id.combobox('select',value);
	}else if(className.indexOf("hisui-datebox")>=0){
		_$id.datebox("select",value)
	}else{
		_$id.val(value);
	}
}
function FormateNumber(Number) {
    if ((Number == "")||(Number==" ")) return "";
    if (Number.indexOf(".") == -1) { 
    	if (Number.indexOf("-") >=0) {
	    	var NewNumber="";
	    	for (var m=0;m<Number.split("-").length;m++) {
		    	if (NewNumber=="") NewNumber=FormateNumber(Number.split("-")[m]);
		    	else  NewNumber=NewNumber+"-"+FormateNumber(Number.split("-")[m]);
		    }
		    return NewNumber;
	    }else{
    		return +Number ;
    	}
    }
    var FirstNum = Number.split(".")[0];
    FirstNum = +FirstNum
    var SecondNum = ""
    if (Number.indexOf(".") != -1) SecondNum = Number.split(".")[1];
    if (SecondNum != "") SecondNum = SecondNum
    if (SecondNum != "") {
        return FirstNum + "." + SecondNum;
    } else {
        return FirstNum;
    }
}