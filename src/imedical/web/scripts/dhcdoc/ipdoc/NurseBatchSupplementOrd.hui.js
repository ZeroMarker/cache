var PageLogicObj={
	m_ordlistDataGrid:"",
	//m_AddItemToListMethod: "LookUp",
	LookupPanelIsShow:0
};
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	 document.getElementsByTagName('head')[0].appendChild(script);
}
window.onbeforeunload = DocumentUnloadHandler;
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function Init(){
	InitTempFrame();
	PageLogicObj.m_ordlistDataGrid=InitOrdListDataGrid();
	InitsearchItemLookUp();
	PageLogicObj.AnaesthesiaID=GetMenuPara("AnaesthesiaID");
	if (PageLogicObj.AnaesthesiaID!="") {
		$.extend(ServerObj, { NotUnSelectPat: "Y"});
	}
}
function PageHandle(){
	LoadselPatKW([]);
}
$(window).load(function() {
	//获取session数据
	GetSessionData(); 
	$("#searchItem").focus();
	
})
function InitEvent(){
	$("#FindSupplementedOrd").click(FindSupplementedOrdClick);
	$("#searchItem").keydown(searchItemkeydown);
}
var selRowIndex="";
function InitOrdListDataGrid(){
	var toobar=[{
        text: $g('删除'),
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle(); }
    },'-',{
	    id: 'InsertOrder',
        text: $g('审核医嘱'),
        iconCls: 'icon-paper-stamp',
        handler: function() {UpdateClickHandler();}
    }/*,{
        text: '暂存',
        iconCls: 'icon-save',
        handler: function() { DocumentUnloadHandler();}
    }*/,'-',{
        iconCls: 'icon-arrow-top',
        handler: function() { SortRowClick("up");}
    },{
        iconCls: 'icon-arrow-bottom',
        handler: function() { SortRowClick("down");}
    }];
	if (ServerObj.GroupCPPFlag=="Y") {
		toobar.push('-');
		toobar.push({
		    text: $g('预扣费'),
	        iconCls: 'icon-paper-money',
	        handler: function() { CardBillClick();}
		});
	}
	// 接收科室编辑格
	var rLocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: '',
			valueField: "id", 
			textField: "text",
			editable:false,
			onSelect:function(option){
				var index = getRowIndex(this);
				var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
				rows[index]["OrderRecDepRowid"]=option.id;
				rows[index]["OrderRecDep"]=option.text;
				ChangeLinkOrderRecDept(index);
			} 
		}

	}
	//手术列表
	var rOperationEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: '',
			valueField: "id", 
			textField: "text",
			onSelect:function(option){
				if (option) {
					var index = getRowIndex(this);
					var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
					rows[index]["OrderOperationCode"]=option.id;
					rows[index]["OrderOperation"]=option.text;
					ChangeLinkOrderOperation(index);
				}
			},
			onChange:function(newValue, oldValue){
				if (newValue=="") {
					 var index = getRowIndex(this);//这就是当前combobox下拉框编辑行的索引
					 var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
					 rows[index]["OrderOperationCode"]="";
					 rows[index]["OrderOperation"]="";
					 ChangeLinkOrderOperation(index);
				}
			}
		}

	}
	var Columns=[[ 
		{field:'rowid',title:'',checkbox:true},
		{field:'id',title:'序号',width:40},
		{field:'OrderMasterSeqNo',title:'关联',width:40},
		{field:'OrderName',title:'名称',width:200},
		{field:'OrderPackQty',title:'数量',width:50,
			editor : {type : 'text',options : {}}
		},
		{field:'OrderPackUOM',title:'单位',width:70},
		{field:'OrderMaterialBarcodeHiden',title:'条码',width:150},
		{field:'OrderPrice',title:'单价',width:90,
			editor : {type : 'text',options : {}}
		},
		{field:'OrderSum',title:'总金额',width:90,
			editor : {type : 'text',options : {editable:false}}
		},
		{field:'OrderRecDep',title:'接收科室',width:150,editor:rLocEditor
			/*formatter:function(value,row,index){
				if (row['OrderRecLocStr']){
				   var Len=row['OrderRecLocStr'].split(String.fromCharCode(2)).length;
				   if (Len>1){
					   return '<a class="editcls" id= "' + row['id'] + '" onmouseover="OrdLocChangeShow(this)">'+value+'</a>';
			       }else{
				       return value;
				   }
			   }
			   return value;
            }*/
		},
		{field:'OrderOperation',title:'手术列表',width:90,editor:rOperationEditor},
		{field:'OrderOperationStr',hidden:true}
		
    ]]
	var ordlistDataGrid=$("#ordlist").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'id',
		columns :Columns,
		toolbar:toobar,
		rowStyler: function(index,row){
			if ((row['CalSeqNo']!="")&&(row['CalSeqNo']!="undefined")){
				if (row['CalSeqNo'].indexOf(".")>=0){
					return 'background-color:#cdf1cd;';
				}else{
					return 'background-color:#94e494;';
				}
			}
		},
		onCheck:function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["id"];
			var OrderMasterSeqNo=row["OrderMasterSeqNo"];
			if (OrderMasterSeqNo!=""){
				var index=$("#ordlist").datagrid('getRowIndex',OrderMasterSeqNo);
				$("#ordlist").datagrid('checkRow',index);
			}else{
				var GridData=$("#ordlist").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					var OrderMasterSeqNo=GridData.rows[m]["OrderMasterSeqNo"];
					if (OrderMasterSeqNo==selOrderSeqNo) {
						var OrderItemInValid=GridData.rows[m]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=m;
							$("#ordlist").datagrid('checkRow',m);
						}
					}
				}
			}
			selRowIndex="";
		},
		onUnselect:function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["id"];
			var OrderMasterSeqNo=row["OrderMasterSeqNo"];
			if (OrderMasterSeqNo!=""){
				var index=$("#ordlist").datagrid('getRowIndex',OrderMasterSeqNo);
				$("#ordlist").datagrid('uncheckRow',index);
			}else{
				var GridData=$("#ordlist").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					var OrderMasterSeqNo=GridData.rows[m]["OrderMasterSeqNo"];
					if (OrderMasterSeqNo==selOrderSeqNo) {
						var OrderItemInValid=GridData.rows[m]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=m;
							$("#ordlist").datagrid('uncheckRow',m);
						}
					}
				}
			}
			selRowIndex="";
		},
		onDblClickRow:function(rowIndex, rowData){
			var rowidArr=GetOrderSeqArr(rowIndex);
			var NeedOpenChangeOrder=false
			for (var i=0;i<rowidArr.length;i++){
				SetBeginEdit(rowidArr[i]);
			}
		}
	});
	if (GetMenuPara("AnaesthesiaID")=="") {
		ordlistDataGrid.datagrid("hideColumn","OrderOperation");
	}
	try {
		$.data($("#ordlist")[0], "datagrid").panel.bind("drop", function(event) {
			console.log("禁止拖拽");return false;
		});
	} catch (error) {
		
	}
	
	return ordlistDataGrid;
}
function InitsearchItemLookUp(){
	$("#searchItem").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'医嘱名称',width:250,sortable:true},
           {field:'subcatdesc',title:'子类',width:100,sortable:true},
           {field:'ItemPrice',title:'价格',width:80,sortable:true},
           {field:'BasicDrugFlag',title:'基本药物',width:90,sortable:true},
           {field:'billuom',title:'计价单位',width:90,sortable:true},
           {field:'StockQty',title:'库存数',width:80,sortable:true},
           {field:'PackedQty',title:'打包数',width:80,sortable:true},
           {field:'GenericName',title:'通用名',width:120,sortable:true},
           {field:'ResQty',title:'在途数',width:80,sortable:true},
           {field:'DerFeeRules',title:'收费规定',width:90,sortable:true},
           {field:'InsurClass',title:'医保类别',width:90,sortable:true},
           {field:'InsurSelfPay',title:'自付比例',width:90,sortable:true},
           {field:'Recloc',title:'接收科室',width:100,sortable:true},
           {field:'arcimcode',title:'代码',width:90,sortable:true}
        ]],
        pagination:true,
        rownumbers:true,
        panelWidth:1000,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem'},
        rowStyler: function(index,row){
	        var ArcimID=row["HIDDEN"]
            var Type=row["HIDDEN2"]
            var OrderType=row["HIDDEN4"]
            var HaveStock=row["HIDDEN16"]
            if ((OrderType=="R")&&(Type="ARCIM")&&(HaveStock!="Y")){
	            return 'background-color:#DDA0DD;';
            }
	    },
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        PageLogicObj.SearchName=desc;
		    var CurLogonDep = session['LOGON.CTLOCID'];
		    var GroupID = session['LOGON.GROUPID'];
		    var catID = "",subCatID="",OrdCatGrp="";
		    var LogonDep = GetLogonLocByFlag();
		    var P5 = "",P9 = "",P10 = "";
		    var OrderPriorRowid = "",OrdCateGoryRowId="",OrdCatGrp="";
			param = $.extend(param,
				{Item:desc,GroupID:GroupID,Category:"",SubCategory:"",TYPE:P5,
				 OrderDepRowId:LogonDep,OrderPriorRowId:OrderPriorRowid,
				 EpisodeID:GetParamAdm(),BillingGrp:P9,BillingSubGrp:P10,UserRowId:session["LOGON.USERID"],
				 OrdCatGrp:OrdCatGrp,NonFormulary:"",Form:CurLogonDep,Strength:"",Route:""
       	   });
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			OrderItemLookupSelect(ItemArr.join("^"));
			ClearSearch();
            $("#searchItem").focus();
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			if ($("#searchByBarcode").checkbox('getValue')){return false;}
			return true;
		},selectRowRender:function(row){
			if (!row){return "";}
			if (row['Recloc']=="") {return "";}
			if (row['Recloc'].split("/").length==1){
				var OrderMsg=row['Recloc']+":"+row['StockQty'];
			}else{
				var OrderMsg = tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderStockMsg", ServerObj.EpisodeID,row['HIDDEN'],row['Recloc'],session['LOGON.CTLOCID']);
            	if (OrderMsg==""){return "";}
			}
            var innerHTML="<div style='height:100px;background:#FFFFFF'>";
            innerHTML=innerHTML+"<div style='width:1000px;color:red;font-size:18px;'>";
            innerHTML=innerHTML+OrderMsg;
            innerHTML=innerHTML+"</div>";
            innerHTML=innerHTML+"</div>";
            return innerHTML;
		}
    });
}
function OrderItemLookupSelect(text){
	var Split_Value = text.split("^");
    var idesc = Split_Value[0];
    var icode = Split_Value[1];
    var ifreq = Split_Value[2];
    var iordertype = Split_Value[3];
    var ialias = Split_Value[4];
    var isubcatcode = Split_Value[5];
    var iorderCatID = Split_Value[6];
    var iSetID = Split_Value[7];
    var mes = Split_Value[8];
    var irangefrom = Split_Value[9];
    var irangeto = Split_Value[10]
    var iuom = Split_Value[11];
    var idur = Split_Value[12];
    var igeneric = Split_Value[13];
    var match = "notfound";
    var SetRef = 1;
    var OSItemIDs = Split_Value[15];
    var iorderSubCatID = Split_Value[16];
    var StockQty = Split_Value[20];
    var PackedQty = Split_Value[21];
    if (iordertype == "ARCIM") iSetID = "";
    var Itemids = "";
    if (OSItemIDs == "") {
        Itemids = icode;
    } else {
        Itemids = icode + String.fromCharCode(12) + OSItemIDs;
    }
    var OSItemIDArr = OSItemIDs.split(String.fromCharCode(12))
    for (var i = 0; i < OSItemIDArr.length; i++) {
        if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i] = OSItemIDArr[i].split(String.fromCharCode(14))[1];
    }
    OSItemIDs = OSItemIDArr.join(String.fromCharCode(12));
	var rowid=GetNewrowid();
    if (iordertype == "ARCIM") {
		var OrdParamsArr=new Array();
		OrdParamsArr[OrdParamsArr.length]={
			OrderARCIMRowid:icode,
			ItemDefaultRowId:""
		};
		new Promise(function(resolve,rejected){
			AddItemToList(rowid,OrdParamsArr,"data","",resolve);
		}).then(function(RtnObj){
			var rowid=RtnObj.rowid;
			var returnValue=RtnObj.returnValue;
    		DHCDocUseCount(icode, "User.ARCItmMast");
		})
    } else {
        //医嘱套
        if ($.isNumeric(rowid) == false) { return; }
        OSItemListOpen(icode, "", "YES", "", "");
        DHCDocUseCount(icode, "User.ARCOrdSets")
    }
    //添加数据成功后 设置Footer数据
    return true;
}
//打开医嘱套界面
function OSItemListOpen(ARCOSRowid, OSdesc, del, itemtext, OrdRowIdString) {
    if (ARCOSRowid != "") {
	    if (ServerObj.MedNotOpenARCOS=="1"){
		    var ret=tkMakeServerCall("web.DHCDocOrderCommon", "SetARCOSItemDirect","AddCopyItemToList",ARCOSRowid,session['LOGON.HOSPID'],"");
		}else{
        	websys_showModal({
				url:"doc.arcositemlist.hui.csp?EpisodeID=" +GetParamAdm()+ "&ARCOSRowid=" + ARCOSRowid +"&nowOrderPrior=0",
				title:'医嘱套录入',
				width:1160,height:592,
				AddCopyItemToList:AddCopyItemToList
			});
		}
    }
}
//添加医嘱套
function AddCopyItemToList(ParaArr) {
    //GlobalObj.AuditFlag = 0;
	//ParaArr在这里丢失了数组的成员属性，奇怪
	var OrdArr = new Array();
	for (var i = 0,ArrLength = ParaArr.length; i < ArrLength; i++){
		OrdArr.push(ParaArr[i]);
	}
	window.setTimeout(function(){
		AddCopyItemToListSub(OrdArr);
	}, 100);
	function AddCopyItemToListSub(OrdArr){
		var OrdParamsArr=new Array();
		//将多列医嘱信息合并到一个对象里面
		for (var i = 0,ArrLength = OrdArr.length; i < ArrLength; i++) {
			var Para1Str=OrdArr[i];
			
			var para1Arr = Para1Str.split("!")
			var icode = para1Arr[0];
			var seqno = para1Arr[1];
			var Para = para1Arr[2];
			var ItemOrderType = para1Arr[3];
			var CopyBillTypeRowId = para1Arr[4];
			//update by zf 2012-05-14
			var CopyType = para1Arr[5];
			var CPWStepItemRowId = para1Arr[6];
			if ((typeof CPWStepItemRowId == "undefined") || (CPWStepItemRowId == "undefined")) {
				CPWStepItemRowId="";
			}
			//抗菌药物申请通过的医嘱项保存，不需要再次进行抗菌药审核
			var KSSCopyFlag = para1Arr[7];
			if ((KSSCopyFlag != "undefined") && (KSSCopyFlag == "KSS")) {
				ServerObj.AuditFlag = 1;
			}
			var OrderBodyPartLabel="";
			if (Para != "") {
				var OrderBodyPartLabel=mPiece(Para, "^", 17);
				if (typeof OrderBodyPartLabel=="undefined") OrderBodyPartLabel="";
			}
			var OrderARCOSRowid = para1Arr[8];
			if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
				OrderARCOSRowid="";
			}
			var ITMRowId=mPiece(Para, "^", 13);
			//seqno用于传值计算成组关系，与行上的SeqNo没有实际关系
			OrdParamsArr[OrdParamsArr.length]={
				OrderARCIMRowid:icode,
				ParamS:Para,
				OrderBillTypeRowid:CopyBillTypeRowId,
				OrderCPWStepItemRowId:CPWStepItemRowId,
				CopyType:CopyType,
				CalSeqNo:seqno,
				OrderBodyPartLabel:OrderBodyPartLabel,
				ITMRowId:ITMRowId
			};
		}
		if (OrderARCOSRowid==""){
			var OrderARCOSRowid=mPiece(Para, "^", 6);
		}
		var FastEntryMode=0;
		var	FastEntryName="";
		///判断是否属于快速医嘱套
		if (OrderARCOSRowid!=""){
			var ARCOSInfo=cspRunServerMethod(ServerObj.GetARCOSInfoMethod,OrderARCOSRowid);
			FastEntryName=mPiece(ARCOSInfo,"^",0)
			if (mPiece(ARCOSInfo,"^",1)=="Y"){
				FastEntryMode=1;
			}
		}
		var ExpStr=CopyType+"^"+FastEntryMode+"^"+FastEntryName+"^"+OrderARCOSRowid;
		var rowid=GetNewrowid();
		new Promise(function(resolve,rejected){
			AddItemToList(rowid,OrdParamsArr,"obj",ExpStr,resolve);
		}).then(function(RtnObj){
			var rowid=RtnObj.rowid;
			var returnValue=RtnObj.returnValue;
		})
	}
}
//获取新增行ID
function GetNewrowid() {
    var rowid = "";
    var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
    if (rowids.length > 0) {
        rowid = parseInt(rowids[rowids.length-1]['id'])+1;
    } else {
        rowid = 1;
    }
    return rowid;
}
//改造为支持异步回调
function AddItemToList(rowid,OrdParams,AddMethod,ExpStr,callBackFun) {
	var RtnObj={
		returnValue:false,
		rowid:rowid
	};
	var AdmStr=GetSelPatKW();
	if (AdmStr!="") {
		var warning=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd", "ChkOrdEntryLimit",AdmStr,ServerObj.NotAdmTypeLimit);
		if (warning!="") {
			$.messager.alert("提示",warning);
			if (callBackFun) callBackFun(RtnObj);
			return RtnObj;
		}
	}
	var CopyType=mPiece(ExpStr, "^", 0);
	var FastEntryMode=mPiece(ExpStr, "^", 1);
	var FastEntryName=mPiece(ExpStr, "^", 2);
	var OrderARCOSRowid=mPiece(ExpStr, "^", 3);
    //如果按登录科室取接收科室?就把登录科室传进去 session['LOGON.CTLOCID']
    var LogonDep = GetLogonLocByFlag();
    //跨院
	var OrderOpenForAllHosp="0";
    var SessionStr = GetSessionStr();
    var OrderOperationCode=GetMenuPara("AnaestOperationID");
    var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
    if(rows.length){
    	var lastRow=rows[rows.length-1];
    	var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:rows.length-1,field:'OrderOperation'});
    	if(ed) OrderOperationCode=$(ed.target).combobox('getValue')
    }
    var BaseParam = {
		///单条医嘱信息-后台会重置这部分数据
		OrderARCIMRowid:"",
		RelocRowID:"",
		MaterialBarcode:"",
		///rowid需要在后台修改,和前台的实际行号不一定能对照起来，原因参考快速医嘱套录入功能
		rowid:rowid,
		///全局变量
		LogonDep:LogonDep,
		OrderOpenForAllHosp:OrderOpenForAllHosp, 
		SessionStr:SessionStr,
		AnaesthesiaID:GetMenuPara("AnaesthesiaID"), //手术ID
		OrderOperationCode:OrderOperationCode, //手术列表明细ID
		OrderARCOSRowid:OrderARCOSRowid,
		Adm:GetParamAdm()//GetMenuPara("EpisodeID")
    };
    var ItemOrdsJson=GetItemOrds();
    new Promise(function(resolve,rejected){
		GetItemCongeries(OrdParams,BaseParam,ItemOrdsJson,resolve);
	}).then(function(NeedAddItemCongeriesObj){
		return new Promise(function(resolve,rejected){
			NeedAddItemCongeriesObjArr=NeedAddItemCongeriesObj;
			if (NeedAddItemCongeriesObj.length==0){
				$.extend(RtnObj, {returnValue:false});
				if (callBackFun) callBackFun(RtnObj);
				return;
			}
			//快速医嘱套
			if (FastEntryMode==1){
				var ItemCongeriesSum=0;
				var NeedAddSingleRowItem=[];
				var Len=NeedAddItemCongeriesObj.length;
				for (var i=0;i<NeedAddItemCongeriesObj.length;i++) {
					/*
					对于快速医嘱套中的单条项目的判断或处理，在此处处理；
					（抗菌药管理）、医嘱套明细维护快速例外
					*/
					if (NeedAddItemCongeriesObj[i].SingleRowFlag=="Y"){
						NeedAddSingleRowItem.push(NeedAddItemCongeriesObj[i]);
						NeedAddItemCongeriesObj.splice(i,1);
						i=i-1;
						continue;
					}
					ItemCongeriesSum=parseFloat(ItemCongeriesSum)+parseFloat(NeedAddItemCongeriesObj[i].OrderSum);
				}
				rowid=GetNewrowid();
				if (NeedAddSingleRowItem.length<Len){
			    	var ParamObj={};
			    	ParamObj.OrderARCIMRowid="";
			    	ParamObj.rowid=rowid;
			    	ParamObj.OrderName=FastEntryName;
			    	ParamObj.OrderARCOSRowid=OrderARCOSRowid;
			    	ParamObj.OrderSum=ItemCongeriesSum;
			    	ParamObj.OrderMasterSeqNo="";
			    	ParamObj.id=rowid;
			    	ParamObj.CalSeqNo="";
			    	var OrderItemCongeriesJson=JSON.stringify(NeedAddItemCongeriesObj);
			    	ParamObj.OrderItemCongeries=OrderItemCongeriesJson;
			    	ParamObj.OrderRecLocStr=NeedAddItemCongeriesObj[0].OrderRecLocStr
			    	ParamObj.OrderRecDep=NeedAddItemCongeriesObj[0].OrderRecDep
			    	ParamObj.OrderOperation=NeedAddItemCongeriesObj[0].OrderOperation
			    	ParamObj.OrderOperationStr=NeedAddItemCongeriesObj[0].OrderOperationStr
			    	ParamObj.AnaesthesiaID=GetMenuPara("AnaesthesiaID"), //手术ID
					ParamObj.OrderOperationCode=GetMenuPara("AnaestOperationID"), //手术列表明细ID
			    	AddItemDataToRow(ParamObj,{});
		    	}
				if (NeedAddSingleRowItem.length>0){
					AddItemCongeriesToRow(rowid,AddMethod,NeedAddSingleRowItem,resolve);
				}
			}else{
		    	AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj,resolve);
		    }
		})
	}).then(function(rowid){
		if ((rowid!="")&&(NeedAddItemCongeriesObjArr.length>0)){
			$.extend(RtnObj, {returnValue:true,rowid:rowid});
			SetScreenSum();
		}else{
			$.extend(RtnObj, {returnValue:false});
		}
		if (callBackFun) callBackFun(RtnObj);
	})
	return RtnObj;
	///把数据依次添加到行上面
	function AddItemCongeriesToRow(rowid,AddMethod,NeedAddItemCongeriesObj,callBackFun){
		var seqnoarr = new Array(),GroupSeqNoArr = new Array(),tempseqnoarr = new Array();
		var SuccessCount=0;
		var ParamObj={},CopyRowDataObj={};
		var Startrowid="";
		function loop(i){
			new Promise(function(resolve,rejected){
				ParamObj={};
				ParamObj=NeedAddItemCongeriesObj[i];
				rowid=GetNewrowid();
				ParamObj.rowid=rowid;
				ParamObj.id=rowid;
				if (Startrowid==""){Startrowid=ParamObj.rowid;}
				var CalSeqNo=ParamObj.CalSeqNo;
				//记录关联关系
				var MasterSeqNo="";
				tempseqnoarr = CalSeqNo.split(".");
				if (tempseqnoarr.length > 1) {
					var masterseqno = tempseqnoarr[0];
					if (seqnoarr[masterseqno]) {
						MasterSeqNo = seqnoarr[masterseqno] //+"."+tempseqnoarr[1];
					}
				}
				ParamObj.OrderMasterSeqNo=MasterSeqNo;
				if (MasterSeqNo!=""){
					GroupSeqNoArr[rowid]=MasterSeqNo;
				}
				CopyRowDataObj={},RowDataObj={};
				CopyRowDataObj=DeepCopyObject(RowDataObj);
				CopyRowDataObj.tempseqnoarr=tempseqnoarr;
				//保存行数据
				AddItemDataToRow(ParamObj,CopyRowDataObj,resolve);
			}).then(function(returnValue){
				if (returnValue == true) {
					if (tempseqnoarr.length =1) {
						newseqno = CopyRowDataObj.id;
						seqnoarr[ParamObj.CalSeqNo] = newseqno;
					}
					if (AddMethod=="data"){
						SetBeginEdit(CopyRowDataObj.rowid);
					}
				}
				i++;
				if ( i < NeedAddItemCongeriesObj.length ) {
					 loop(i);
				}else{
					callBackFun(CopyRowDataObj.rowid);
				}
			})
		}
		loop(0);
	}
    function GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,callBackFun){
	    var NeedAddItemCongeriesObj = new Array();
		var OrdCongeriesJson=JSON.stringify(OrdCongeriesObj);
		var BaseParamJson=JSON.stringify(BaseParamObj);
		var ItemCongeries = cspRunServerMethod(ServerObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson);
		var ItemCongeriesObj=eval("("+ItemCongeries+")");
		var RecursionFlag=false,Sum=0;
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
							if ((CheckBeforeAddObj.SuccessFlag==true)&&($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==false)){
								NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
							}
						}
						i++;
						if ( i < ItemCongeriesObj.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0)
			})(resolve); //此处的resolve是指callBackFun(NeedAddItemCongeriesObj)
		}).then(function(){
			callBackFun(NeedAddItemCongeriesObj);
		});
    }
	function GetItemOrds(){
		var ItemOrdsObj={
			Length:0,
			ItemOrds:[]	//行对象集合
		}
		var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
		for (var i = 0; i < rows.length; i++) {
			var OrderItemRowid = rows[i]["OrderItemRowid"];
			var OrderARCIMRowid = rows[i]["OrderARCIMRowid"];
			if (OrderARCIMRowid=="") continue;
			var OrderSeqNo = rows[i]["id"];
			var OrderMasterSeqNo = rows[i]["OrderMasterSeqNo"];
			var OrderPriorRowid = rows[i]["OrderPriorRowid"];
			var OrderMaterialBarcode= rows[i]["OrderMaterialBarcodeHiden"];
			var ItemOrd={
				OrderItemRowid:'',
				OrderARCIMRowid:OrderARCIMRowid,
				rowid:rows[i]["rowid"],
				OrderSeqNo:OrderSeqNo,
				OrderMasterSeqNo:OrderMasterSeqNo,
				OrderPriorRowid:OrderPriorRowid,
				OrderMaterialBarcode:OrderMaterialBarcode
			};
			ItemOrdsObj.ItemOrds.push(ItemOrd);
			ItemOrdsObj.Length=ItemOrdsObj.Length+1;
		}
		var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
		return ItemOrdsJson;
	}
}
///校验能否将该条医嘱添加到行上
function CheckItemCongeries(ItemToListDetailObj){
	var CheckBeforeAddObj={
		SuccessFlag:true,				//是否需要继续审核医嘱
		StartDateEnbale:true,
		UserOptionObj:new Array()
	}
	new Promise(function(resolve,rejected){
		if (typeof ItemToListDetailObj.CallBakFunS=="object"){
			///先进行判断是否有需要递归的后处理
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var CallBakFunCode=ItemToListDetailObj.CallBakFunS[i].CallBakFunCode;
						var CallBakFunParams=ItemToListDetailObj.CallBakFunS[i].CallBakFunParams;
						ExeItemCongeriesUserOption(CallBakFunCode,CallBakFunParams,resolve);
					}).then(function(UserOptionObj){
						if (!$.isEmptyObject(UserOptionObj)){
							CheckBeforeAddObj.UserOptionObj.push(UserOptionObj);
						}						
						i++;
						if ( i < ItemToListDetailObj.CallBakFunS.length ) {
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
			if ((CheckBeforeAddObj.UserOptionObj.length>0)||(ItemToListDetailObj.UserOptionCount>0)){
				resolve();
			}else{
				//医嘱的ErrCode不等于0，代表医嘱不能被录入到页面，那其他的提示就没有必须要显示
				if (ItemToListDetailObj.ErrCode!="0"){
					$.messager.alert("提示",ItemToListDetailObj.ErrMsg,"info",function(){
						$.extend(CheckBeforeAddObj, {SuccessFlag:false});
						resolve();
					});
				}else{
					if (typeof ItemToListDetailObj.CallBakFunS=="object"){
						///再进行判断是否需要继续进行普通的后处理
						(function(callBackExecFun){
							function loop(i){
								new Promise(function(resolve,rejected){
									var CallBakFunCode=ItemToListDetailObj.CallBakFunS[i].CallBakFunCode;
									var CallBakFunParams=ItemToListDetailObj.CallBakFunS[i].CallBakFunParams;
									ExeItemCongeriesCallBackFun(CallBakFunCode,CallBakFunParams,resolve);
								}).then(function(ReturnObj){
									if (ReturnObj.SuccessFlag==false){
										CheckBeforeAddObj.SuccessFlag=false;
										callBackExecFun();;
									}else{			
										i++;
										if ( i < ItemToListDetailObj.CallBakFunS.length ) {
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
			}
		})
	}).then(function(){
		ItemToListDetailObj.callBackFun(CheckBeforeAddObj);
	})
	function ExeItemCongeriesUserOption(FunCode ,FunCodeParams,CallBackFun){
		///-------
		//被设计用来反插后台查询方法，用于对后续计算有影响的confirm计算，
		//每次对这个值进行新属性的赋值，都需要在后台计算中加上对应的处理
		//UserOptionOb应至少包含两个固定属性{Type:"",Value:""},用于后台方法识别
		var UserOptionObj={};
		new Promise(function(resolve,rejected){
			var ParamsArr=FunCodeParams.split(";");
			switch(FunCode)
			{
				default:
					break;
			}
			resolve();
		}).then(function(){
			CallBackFun(UserOptionObj);
		})
	}
	/*
	用于additemtolist方法的回调，注意：
	为兼容快速医嘱套录入模式，此方法中不能直接对行数据进行操作，如需对数据操作，请使用返回对象，操作ParamObj
	*/
	function ExeItemCongeriesCallBackFun(FunCode ,FunCodeParams,CallBackFun){
		var ReturnObj={
			SuccessFlag:true,
			StartDateEnbale:true,
			//医保适应症涉及修改的内容--
			OrderCoverMainIns:"",	//医保勾选
			OrderInsurCatRowId:"",
			CalPackQtyObj:{}
		}
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
					})(resolve); //此处的resolve指的是CallBackFun(ReturnObj);
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
					})(resolve); //此处的resolve指的是CallBackFun(ReturnObj);
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

function AddItemDataToRow(ParamObj,RowDataObj,callBackFun){
	new Promise(function(resolve,rejected){
		RowDataObj = SetRowDataObj(ParamObj.rowid, RowDataObj, ParamObj);
		PageLogicObj.m_ordlistDataGrid.datagrid("appendRow",RowDataObj);
		resolve(true);
	}).then(function(){
		if (callBackFun) callBackFun(true);
	})
	return true;
}
function SetRowDataObj(rowid, RowDataObj, ParamObj){
    var dataObj=$.extend(RowDataObj, ParamObj); //{index:rowid-1,row:RowDataObj}
    return dataObj;
}
function ClearSearch(){
	$("#searchItem").lookup('setText','');
}
//记录基础代码数据使用次数
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
function GetLogonLocByFlag() {
    var FindRecLocByLogonLoc=$("#FindByLogDep").checkbox("getValue")?"1":"0";
    var LogonDep = ""
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    return LogonDep;
}
function LoadselPatKW(itemsArr){
	$("#selPatKW").keywords({
	    singleSelect:false,
	    labelCls:'red',
	    items:itemsArr,
	    onUnselect:function(v){
		    if (ServerObj.NotUnSelectPat!="Y") { //(GetMenuPara("AnaesthesiaID")=="")&&
		    	UnselPatKWClick(v);
		    }else{
			    $("#selPatKW").keywords('select',v.id);
			}
		}
	});
	ChgFindByLogDepCheckStatus();
}
function UnselPatKWClick(v){
	var amdId=v.id;
	var ItemArr=$("#selPatKW").keywords('options').items;
	var find=ItemArr.contains(v);
	if (find>=0){
		ItemArr.splice(ItemArr.contains(v),1); 
	}
	LoadselPatKW(ItemArr);
	if (parent.DataGridUnSelectRow) {
		parent.DataGridUnSelectRow(amdId);
	}
}
/// 选中/取消选中左侧患者列表时,局部刷新右侧补录页面总入口
// adm 就诊ID type(Add 新增选中患者,Del 取消选中患者,默认Add)
function xhrRefresh(obj){
	if (typeof type =="undefined"){type="Add";}
	//更新关联字列表
	UpdateselPatKWItem(obj);
	//若"显示已补录"窗口打开,则刷新列表
	if ($("#tabSupplementedOrd").length>0){
		LoadSupplementedOrd();
	}
}
function UpdateselPatKWItem(obj,type){
	var ItemArr=$("#selPatKW").keywords('options').items;
	if (obj['adm']!="") {
		var newobj={"text":obj['patname'],id:obj['adm'],selected:true};
		var find=ItemArr.contains(newobj);
		if (find>=0){
			ItemArr.splice(ItemArr.contains(newobj),1); //先删除重复的
		}
	}
	var LinkedMasterOrderRowid=obj['LinkedMasterOrderRowid'];
	if (typeof LinkedMasterOrderRowid=="undefined") LinkedMasterOrderRowid=""
	if ((obj['type']=="Add")&&(obj['adm']!="")) {
		ItemArr.push({"text":obj['patname'],id:obj['adm'],LinkedMasterOrderRowid:LinkedMasterOrderRowid,selected:true});
	}
	LoadselPatKW(ItemArr);
	InitKWPopover();
}
Array.prototype.contains = function(obj) {
	 var i = this.length;
	 while (i--) {
	   if (this[i].id == obj.id) {
	      return i; // 返回的这个 i 就是元素的索引下标，
	   }
	 }
	 return -1;
}
function GetCurr_time() {
    //取当前日期和时间(服务器)
    var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime", ServerObj.defaultDataCache, "1");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
    return CurrDateTime;
}

function mPiece(s1, sep, n) {
    var delimArray = s1.split(sep);
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
	return "";
}
function DeepCopyObject(source) { 
	var result={};
	for (var key in source) {
      result[key] = typeof source[key]==='object'?deepCoyp(source[key]): source[key];
   } 
   return result; 
}
function DelClickHandle(){
	var SelIds=[];
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		SelIds[i]=rows[i]['id'];
	}
	SelIds.sort(function(a, b){ return a - b; });
	for (var i=SelIds.length-1;i>=0;i--){
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",SelIds[i]);
		PageLogicObj.m_ordlistDataGrid.datagrid("deleteRow",index);
	}
	PageLogicObj.m_ordlistDataGrid.datagrid("unselectAll");
	var delCount=0;
	
	var OrderSeqNoArr=new Array();
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	for (var i=0;i<rowids.length;i++) {
		var id=parseInt(rowids[i].id);
		delCount=0;
		for (var j=0;j<SelIds.length;j++){
			if (id > parseInt(SelIds[j])){
				delCount++;
			}
		}
		//if ( id < parseInt(SelIds[SelIds.length-1])) continue;
		var rowid=parseInt(rowids[i].rowid);
		var curRowData=rowids[i];
		var curIndex=i; //PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var newId=id-delCount;
		curRowData["id"]=newId;
		curRowData["rowid"]=newId;
		var OrderMasterSeqNo=curRowData["OrderMasterSeqNo"];
		if (OrderMasterSeqNo) {
			var OrderMasterSeqNo=parseInt(OrderMasterSeqNo)-delCount;
			curRowData["OrderMasterSeqNo"]=OrderSeqNoArr[OrderMasterSeqNo];
		}else{
			OrderSeqNoArr[rowid]=newId;
		}
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', curIndex);
		if (editors.length>0){
			curRowData['OrderPackQty']=editors[0].target.val();
			curRowData['OrderPrice']=editors[1].target.val();
			curRowData['OrderSum']=editors[2].target.val();
		}
		PageLogicObj.m_ordlistDataGrid.datagrid('getData').rows[i] = curRowData;
		PageLogicObj.m_ordlistDataGrid.datagrid('refreshRow', i);
		if (editors.length>0){
			//可屏蔽掉，加快速度
			SetBeginEdit(newId);
		}
	}
	SetScreenSum();
}
function SetBeginEdit(rowid){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
    PageLogicObj.m_ordlistDataGrid.datagrid("beginEdit",index);
    var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderARCIMRowid=rows[index]["OrderARCIMRowid"];
	var OrderItemCongeriesJson = rows[index]["OrderItemCongeries"];
	if (OrderItemCongeriesJson!=""){
		//快速医嘱,数量/单价不可编辑
		var OrderPackQtyObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPackQty'});
		$(OrderPackQtyObj.target[0]).addClass('disabled')
		OrderPackQtyObj.target[0].disabled=true;
	}
	if (rows[index]['OrderType']!="P"){
		//自定义价格医嘱,单价可编辑
		var OrderPriceObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPrice'});
		$(OrderPriceObj.target[0]).addClass('disabled')
		OrderPriceObj.target[0].disabled=true;
	}
	var OrderSumObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderSum'});
	$(OrderSumObj.target[0]).addClass('disabled')
	OrderSumObj.target[0].disabled=true;
	
	if ((OrderARCIMRowid!="")||(OrderItemCongeriesJson!="")) {
		var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderRecDep'});
		$(OrderRecDepObj.target).combobox('loadData',GetColumnList("OrderRecDep",rows[index]["OrderRecLocStr"],rows[index].OrderRecDepRowid));
		var OrderOperationObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderOperation'});
		$(OrderOperationObj.target).combobox('loadData',GetColumnList("OrderOperation",rows[index]["OrderOperationStr"],rows[index].OrderOperationCode));
	}	
	if (rows[index].OrderMasterSeqNo!="") {
		$(OrderRecDepObj.target).combobox('disable');
		$(OrderOperationObj.target).combobox('disable');
	}
	GridBindEnterEvent(rowid);
}
function GetColumnList(ColumnName, str, defaultId){
	var dataArr=[];
	if (ColumnName == "OrderRecDep") {
		var DefaultRecLocRowid = "";
	    var ArrData = str.split(String.fromCharCode(2));
	    for (var i = 0; i < ArrData.length; i++) {
		    var selected=false;
	        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
	        if (defaultId!="") {
		        if (ArrData1[0]==defaultId){
		            var DefaultRecLocRowid = ArrData1[0];
		            selected=true;
		        }
	        }else{
		        if (((ArrData1[2] == "Y") && (DefaultRecLocRowid == "")) || (ArrData.length == 1)) {
		            var DefaultRecLocRowid = ArrData1[0];
		            selected=true;
		        }
		    }
	        dataArr[dataArr.length]={"id":ArrData1[0],"text":ArrData1[1],"selected":selected};
	    }
	}
	//手术列表 
	if (ColumnName=="OrderOperation"){
	   if ((str==false)||(str=="")) return dataArr;
	   var ArrData=str.split("^");
	   for (var i=0;i<ArrData.length;i++) {
		   var ArrData1=ArrData[i].split(String.fromCharCode(1));
		   var selected=false;
		   if (defaultId!="") {
				if (ArrData1[1]==defaultId){
					selected=true;
				}
			}
	       dataArr[dataArr.length]={"id":ArrData1[1],"text":ArrData1[0],"selected":selected};
	   }
	}
	return dataArr;
}
//给表格编辑列增加回车事件
function GridBindEnterEvent(rowid){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
	var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', index);
	///数量
	var OrderPackQtyEditor = editors[0];
	OrderPackQtyEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
			var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPackQty'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
			for (var i=parseInt(index)+1;i<rows.length;i++){
				var Nexteditors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
				var NextOrderPriceEditor= Nexteditors[0];
				NextOrderPriceEditor.target.focus().select();  ///设置焦点并选中
				break;
			}
		}
	});
	var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPackQty'});
	ed.target.change(function (e) {
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var qty=e.target.value;
		var OrderPrice=editors[1].target.val();
		OrderSum=(qty*OrderPrice).toFixed(4);
		rows[index]['OrderSum']=OrderSum;
		var obj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderSum'});
		obj.target[0].value=OrderSum;
		SetScreenSum();
	});
	 
	//单价
	var OrderPriceEditor = editors[1];
	OrderPriceEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
			var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPrice'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var rows=PageLogicObj.m_ordlistDataGrid.datagrid('getRows');
			for (var i=parseInt(index)+1;i<rows.length;i++){
				if (rows[i]['OrderType']=="P"){
					var Nexteditors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
					var NextOrderPriceEditor= Nexteditors[1];
					NextOrderPriceEditor.target.focus().select();  ///设置焦点并选中
					break;
				}
			}
		}
	});
	var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderPrice'});
	ed.target.change(function (e) {
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		var OrderPrice=e.target.value;
		var qty=editors[0].target.val();
		OrderSum=(qty*OrderPrice).toFixed(4);
		rows[index]['OrderSum']=OrderSum;
		var obj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor',{index:index, field:'OrderSum'});
		obj.target[0].value=OrderSum;
	});
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	var clsName=_btntext?'single-dialog-body':'single-window-body';
    $("body").append("<div id='"+id+"' class='"+clsName+"'></div>");
    if (_width == null) _width = 800;
    if (_height == null) _height = 500;
    if(_btntext==""){
		var buttons="" 
	}else{
		if ($.isArray(_btntext)) {
			var buttons=_btntext;
		}else {
			var buttons=[{
				text:_btntext,
				iconCls:_icon,
				handler:function(){
					if(_event!="") eval(_event);
				}
			}]
		}
	}
    var collapsed=false,collapsible=false;
    var left=null,closable=true;
    $("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: collapsible,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: closable,
        content:_content,
        buttons:buttons,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:left,
	    onOpen:function(){
		    if ((_btntext=="")||($.isArray(_btntext))) {
			    if (_event!="") eval(_event);
			}
		    return true;
		}
    }).children().eq(0).addClass('panel-body-gray panel-body panel-body-noheader').css({'border-width':'1px','border-style':'solid','border-radius':'4px'});
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function DocumentUnloadHandler(e) {
    /*if (GetMenuPara("AnaesthesiaID")!="") {
		ClearSessionData();
		return;
	}
    */
	var AdmStr=GetSelPatKW();
    //如果医嘱保存成功就不用保留在session中(设置)
    ClearSessionData();
    //未审核的医嘱
    var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
    //设置字符串
    var UnsaveData = ""
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var SaveCount = 0;
    for (var i = 0; i < rows.length; i++) {
	    var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
	    if (editors.length>0){
		    rows[i]["OrderPackQty"]=editors[0].target.val();
		    if (editors.length>1) {
			    rows[i]["OrderPrice"]=editors[1].target.val();
			}
		}
        var oneData = JSON.stringify(rows[i]);
        if (UnsaveData == "") {
            UnsaveData = oneData;
        } else {
            UnsaveData = UnsaveData + "###" + oneData;
        }
        //超过25条记录,则分开存储
        if ((i + 1) % 5 == 0) {
            SaveCount = SaveCount + 1;
            var retDetail = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod, UserID, CTLocId, SaveCount, UnsaveData,AdmStr);
            UnsaveData = "";
        }
    }
    if ((UnsaveData != "")||(AdmStr!="")) {
        SaveCount = SaveCount + 1;
        var retDetail = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod,UserID, CTLocId, SaveCount, UnsaveData,AdmStr);
    }
}
//清除session数据
function ClearSessionData(AdmStr) {
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(ServerObj.GetUserUnSaveCountMethod,UserID, CTLocId);
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var ret = cspRunServerMethod(ServerObj.SetUserUnSaveDataMethod,UserID, CTLocId, i, "","");
    }
    //解除患者锁
    //tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
function GetSelPatKW(){
	var AdmStr="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		var adm=ItemArr[i]['id'];
		if (AdmStr=="") AdmStr=adm;
		else  AdmStr=AdmStr+"!"+adm;
	}
	return AdmStr.toString();
}
function GetSelPat(){
	var AdmStr="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		var adm=ItemArr[i]['id'];
		var LinkedMasterOrderRowid=ItemArr[i]['LinkedMasterOrderRowid'];
		if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
		if (AdmStr=="") AdmStr=adm+String.fromCharCode(1)+LinkedMasterOrderRowid;
		else  AdmStr=AdmStr+"!"+adm+String.fromCharCode(1)+LinkedMasterOrderRowid;
	}
	return AdmStr;
}
function GetSessionData(){
	var AdmStr="";
	var UnSaveDataArr=new Array();
	//获取session数据 
    var UserID = session['LOGON.USERID'];
    var CTLocId = session['LOGON.CTLOCID'];
    var UnSaveCount = cspRunServerMethod(ServerObj.GetUserUnSaveCountMethod, UserID, CTLocId);
    for (var i = 1; i <= parseInt(UnSaveCount); i++) {
        var UserUnSaveDataStr = cspRunServerMethod(ServerObj.GetUserUnSaveDataMethod, UserID, CTLocId, i);
        if (UserUnSaveDataStr == "") { continue; }
        var UserUnSaveData=UserUnSaveDataStr.split("^")[0];
        var AdmStr=UserUnSaveDataStr.split("^")[3];
        if ((ServerObj.NotUnSelectPat=="Y")&&(AdmStr!=GetMenuPara("EpisodeID"))) AdmStr="",UserUnSaveData="";
        if (UserUnSaveData =="" ) { continue; }
        if (UserUnSaveData.split('@').length == 2) {
            if (UserUnSaveData.split('@')[1] == "%CSP.CharacterStream") {
                $.messager.alert("提示", "上一次页面未审核需重载记录数超过最大值,不能自动获取.");
                continue;
            }
        }
        var DataArry = UserUnSaveData.split("###");
        for (var j = 0; j < DataArry.length; j++) {
            var data = DataArry[j];
            var obj = {};
            if (data != "") {
                obj = eval("(" + data + ")");
            }
            UnSaveDataArr.push(obj);
            //AddItemDataToRow(obj,{});
            //SetBeginEdit(obj['id']);
        }
    }
    
    if (AdmStr!=""){
	    for (var i=0;i<AdmStr.split("!").length;i++){
		    var admInfo=AdmStr.split("!")[i];
		    var admId=admInfo.split(String.fromCharCode(1))[0];
		    var LinkedMasterOrderRowid=admInfo.split(String.fromCharCode(1))[1];
		    if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
			if (((parent.DataGridSelectRow)&&(!parent.DataGridSelectRow(admId)))||(ServerObj.NotUnSelectPat=="Y")){
				var patname=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd", "GetPatNameByAdm",admId);
				var objParam = {adm: admId, patname: patname,LinkedMasterOrderRowid:LinkedMasterOrderRowid, type: "Add"};
				xhrRefresh(objParam);
			}
		}
	}
	var EpisPatInfoArr=eval("("+ServerObj.EpisPatInfo+")");
	if ((PageLogicObj.AnaesthesiaID!="")&&(EpisPatInfoArr.length==0)) {
		var EpisPatInfo=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","InitPatOrderViewGlobal","","",GetMenuPara("EpisodeID"));
		$.extend(ServerObj, { EpisPatInfo: EpisPatInfo});
		var EpisPatInfoArr=eval("("+ServerObj.EpisPatInfo+")");
	}
	for (var i=0;i<EpisPatInfoArr.length;i++) {
		xhrRefresh({adm: EpisPatInfoArr[i].id, patname: EpisPatInfoArr[i].text, LinkedMasterOrderRowid: EpisPatInfoArr[i].LinkedMasterOrderRowid, type: "Add"});
	}
	for (var i=0;i<UnSaveDataArr.length;i++){
		AddItemDataToRow(UnSaveDataArr[i],{});
	}
	if (EpisPatInfoArr.length>0) {
		if (typeof(history.pushState) === 'function') {
	        //防止右键刷新后医嘱重复复制
	        var Url=window.location.href;
	        var NewUrl=rewriteUrl(Url, {EpisodeID:"",OEOrdItemIDs:"",OEOrdItemID:""});
	        history.pushState("", "", NewUrl);
	    }
    }
    SetScreenSum();
}
function UpdateClickHandler(){
	if ($("#InsertOrder").hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn("InsertOrder",true);
	var AdmStr=GetSelPat();
	if (AdmStr=="") {
		$.messager.alert("提示", "请先勾选需要进行批量补录的患者!","info",function(){
		    DisableBtn("InsertOrder",false);
		});
	    return websys_cancel();
	}
	var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	if (DataArry.length==0) {
		$.messager.alert("提示", "没有需要保存的数据!","info",function(){
		    DisableBtn("InsertOrder",false);
		});
	    return websys_cancel();
	}
	var OrderItemStr = GetOrderDataOnAdd();
    if (OrderItemStr == "") {
	    $.messager.alert("提示", "没有需要保存的数据!","info",function(){
		    DisableBtn("InsertOrder",false);
		});
	    return websys_cancel();
    }
    var PatKWItemArr=$("#selPatKW").keywords('options').items;
    for (var i=0;i<AdmStr.split("!").length;i++){
	    var AdmInfo=AdmStr.split("!")[i];
		var adm=AdmInfo.split(String.fromCharCode(1))[0];
		var index=$.hisui.indexOfArray(PatKWItemArr,"id",adm);
		var PatName=PatKWItemArr[index].text;
		//var PatName=PatKWItemArr
	    //保存前的后台审核,对于医嘱录入非必须前端处理的判断逻辑可以在此处理
	    var ret = CheckBeforeSaveToServer(adm,PatName,OrderItemStr);
	    if (ret.SuccessFlag == false) {
			 DisableBtn("InsertOrder",false);
	        return websys_cancel();
	    }
	    if (ret.isAfterCheckLoadDataFlag== true){
			var OrderItemStr = GetOrderDataOnAdd();
	    	if (OrderItemStr == "") {
			    $.messager.alert("提示", "没有需要保存的数据!","info",function(){
		    		DisableBtn("InsertOrder",false);
				});
			    return websys_cancel();
		    }
	    }
	}
	var ExpStr = "N^^";
	var SUCCESS=InsertOrderItem(AdmStr,OrderItemStr, ExpStr);
	//审核成功后刷新医嘱单
    if (SUCCESS == true) {
	    $.messager.popover({msg: '保存成功！',type:'success'});
	    ClearData();
	}
	DisableBtn("InsertOrder",false);
}
function InsertOrderItem(AdmStr,OrderItemStr, ExpStr) {
	var SUCCESS = false;
	//var ItemArr=$("#selPatKW").keywords('options').items;
    var UserAddRowid = "";
    var UserAddDepRowid = "";
    UserAddRowid = session['LOGON.USERID'];
    UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var ExpStr=1+"^^^^^^^^"+ServerObj.NotAdmTypeLimit;
    var ret = cspRunServerMethod(ServerObj.InsertContinuousOrder, AdmStr, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr);
    if (ret != "0") {
        $.messager.alert("提示","医嘱保存失败!"+ret);
        return websys_cancel();
    }else{
	    SUCCESS = true;
	}
    return SUCCESS;
}
function CheckBeforeSaveToServer(EpisodeID,PatName,OrderItemStr) {
    var UserAddRowid = session['LOGON.USERID'];
    var UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GetEntryDoctorId();
    var LogonDep = GetLogonLocByFlag();
    var OrderOpenForAllHosp = 0,PPRowId="";
    var ExpStr = PPRowId +"^"+LogonDep+"^"+OrderOpenForAllHosp+"^"+ServerObj.NotAdmTypeLimit;
    var ret = cspRunServerMethod(ServerObj.CheckBeforeSaveMethod, EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr,1)
    var CheckResultObj=jQuery.parseJSON(ret);
    
	var ErrCode=CheckResultObj.ErrCode; //1
	var ErrMsg=CheckResultObj.ErrMsg;	//2
    var ErrRowID=CheckResultObj.OrdRowIndex;	//3
    var FocusCol=CheckResultObj.FocusCol;//4
    var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;//4
	var CheckBeforeSaveObj={
		StopConflictFlag:"0",			//是否需要自动停止互斥医嘱
		isAfterCheckLoadDataFlag:false,	//前台是否需要重载数据
		SuccessFlag:true				//是否需要继续审核医嘱
	}
	//执行回调方法
	var CallBakFunS=CheckResultObj.CallBakFunS;
	if (typeof CallBakFunS=="object"){
		for (var i=0,length=CallBakFunS.length;i<length;i++){
			var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
			var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
			var ReturnObj=CheckAfterCheckMethod(CallBakFunCode,CallBakFunParams,ErrRowID);
			if (ReturnObj.isAfterCheckLoadDataFlag){
				CheckBeforeSaveObj.isAfterCheckLoadDataFlag=true;
			}
			if (ReturnObj.SuccessFlag==false){
				CheckBeforeSaveObj.SuccessFlag=false;
				break;
			}
			if (ReturnObj.StopConflictFlag=="1"){
				CheckBeforeSaveObj.StopConflictFlag="1";
				break;
			}
		}
	}
    if (ErrMsg!=""){
	    if ((ErrRowID!="")&&(FocusCol!="")){
			$.messager.alert("警告", $g("患者【")+PatName+"】"+ ErrMsg, "warning", function() {
				SetFocusCell(ErrRowID, FocusCol);
		    });
		}else{
			$.messager.alert("警告",$g("患者【")+PatName+"】"+ ErrMsg);
		}
    }
	if ((parseInt(ErrCode)<0)){
		CheckBeforeSaveObj.SuccessFlag=false;
	}
	/*if (NeedCheckDeposit) {
        var amount = 0;
        var obj_ScreenBillSum = document.getElementById('ScreenBillSum');
        if (obj_ScreenBillSum) { amount = obj_ScreenBillSum.value; }
        if (!CheckDeposit(amount, "")) {
            CheckBeforeSaveObj.SuccessFlag=false;
        }
    }*/
	return CheckBeforeSaveObj;
}
function CheckAfterCheckMethod(FunCode ,FunCodeParams,Row){
	var ReturnObj={
		StopConflictFlag:"0",
		isAfterCheckLoadDataFlag:false,
		SuccessFlag:true
	}
	var ParamsArr=FunCodeParams.split(",");
    switch(FunCode)
    {
		case"SetPageLogicFocusRow": 
			PageLogicObj.FocusRowIndex = Row;
			break;
		case "Confirm" :
			ReturnObj.SuccessFlag=dhcsys_confirm(FunCodeParams, true);
			break;
		case "ReSetMasterSeqNo" :
			SetCellData(Row, "OrderMasterSeqNo", "");
			ReturnObj.isAfterCheckLoadDataFlag=true;
			break;
		case "AddRemarkClickhandler" :
			ReturnObj.SuccessFlag=AddRemarkClickhandler(ParamsArr[0]); //Row
			ReturnObj.isAfterCheckLoadDataFlag=true;
			break;
		case "NeedInputOrderPrice" :
			EditRow(Row);
            $.messager.alert("提示信息", OrderName + t['NO_OrderPrice'], "warning", function() { SetFocusCell(Row, "OrderPrice"); });
            var StyleConfigObj = { OrderPrice: true };
            ChangeRowStyle(Row, StyleConfigObj)
            PageLogicObj.FocusRowIndex = Row;
            ReturnObj.SuccessFlag=false;
			break;
		case "EmptyPackQty" :
			SetCellData(Row, "OrderPackQty", "");
            ReturnObj.SuccessFlag=true;
			break;
		case "StopConflict" :
			var StopConflictItems = dhcsys_confirm("存在以下互斥医嘱：" + ParamsArr + " 请确认是否自动停止互斥医嘱");
			if (StopConflictItems) ReturnObj.StopConflictFlag = "1";
			break;
		case "CheckPatCount":
			var AdmStr=GetSelPatKW();
			if ((AdmStr!="")&&(AdmStr.split("!").length>1)){
				$.messager.alert("提示", "高值条码 "+ParamsArr[0]+"只能一人使用!");
				ReturnObj.SuccessFlag=false;
			}else{
				ReturnObj.SuccessFlag=true;
			}
			break;
		default:
			break;
	}
    return ReturnObj;

}
function GetEntryDoctorId() {
    var DoctorRowid = "";
    //如果登陆人为医生?就加入医生?如果登陆人为护士?并替医生录入?还是加入医生
    //如果登陆人为护士?而且没有选择医生?就加入护士
    if (ServerObj.LogonDoctorType == "DOCTOR") {
        DoctorRowid = ServerObj.LogonDoctorID;
    } else {
        var obj = document.getElementById('DoctorID');
        if (obj) DoctorRowid = obj.value;
        if (DoctorRowid == "") { DoctorRowid = ServerObj.LogonDoctorID; }
    }
    return DoctorRowid;
}
//获取录入医嘱信息 组织提交字符串
function GetOrderDataOnAdd() {
    var OrderItemStr = "";
    var OrderItem = "";
    var OneOrderItem = "";
	//快速医嘱套中包含的医嘱数量
	var OrderItemCongeriesNum=0;
	var Count=0;
	var Currtime = GetCurr_time();
    //try {
	    var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
        for (var i = 0; i < DataArry.length; i++) {
	        var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
	        var editLen=editors.length;
            var OrderItemRowid = DataArry[i]["OrderItemRowid"];
            var OrderARCIMRowid = DataArry[i]["OrderARCIMRowid"];
			var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
            if ((OrderARCIMRowid == "")&&(OrderARCOSRowid=="")) { continue; }
			//原序号  现行ID
            var OrderSeqNo = DataArry[i]["id"];
			var OrderItemCongeriesJson = DataArry[i]["OrderItemCongeries"];
			var AnaesthesiaID = DataArry[i]["AnaesthesiaID"]
			var OrderOperationCode=DataArry[i]["OrderOperationCode"]
			if (OrderItemCongeriesJson!=""){
				var OrderItemObj=GetOrderItemByItemCongeries(OrderSeqNo,OrderItemCongeriesJson,Count);
				if (OrderItemObj.OrderItemStr!=""){
					if (OrderItemStr == "") {
						OrderItemStr = OrderItemObj.OrderItemStr;
					} else {
						OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItemObj.OrderItemStr;
					}
				}
				if (parseFloat(OrderItemObj.OrderItemCount)==0){
					OrderItemObj.OrderItemCount=1;
				}
				OrderItemCongeriesNum=parseFloat(OrderItemCongeriesNum)+parseFloat(OrderItemObj.OrderItemCount);
				Count=Count+OrderItemCongeriesNum;
				continue;
			}
			Count=Count+1;
			if (parseFloat(OrderItemCongeriesNum)>0){
				OrderSeqNo=parseFloat(OrderItemCongeriesNum)+OrderSeqNo;
			}
			
            var OrderName = DataArry[i]["OrderName"];
            var OrderType = DataArry[i]["OrderType"];
            var OrderPriorRowid = DataArry[i]["OrderPriorRowid"];
            var OrderRecDepRowid = DataArry[i]["OrderRecDepRowid"];
            var OrderFreqRowid = DataArry[i]["OrderFreqRowid"];
            var OrderDurRowid = DataArry[i]["OrderDurRowid"];
            var OrderInstrRowid = DataArry[i]["OrderInstrRowid"];
            var OrderDoseQty = DataArry[i]["OrderDoseQty"];
            var OrderDoseUOMRowid = DataArry[i]["OrderDoseUOMRowid"];
            var OrderPackQty = DataArry[i]["OrderPackQty"];
            if (editLen>0) {
	            OrderPackQty= editors[0].target.val();
	        }
            var OrderPrice = DataArry[i]["OrderPrice"];
            if (editLen>0) {
	            OrderPrice= editors[1].target.val();
	        }
            var PHPrescType = DataArry[i]["OrderPHPrescType"];
            var BillTypeRowid = DataArry[i]["OrderBillTypeRowid"];
            var OrderSkinTest = DataArry[i]["OrderSkinTest"];
            var OrderARCOSRowid = DataArry[i]["OrderARCOSRowid"];
            var OrderDrugFormRowid = DataArry[i]["OrderDrugFormRowid"];
            var OrderStartDateStr = Currtime; //DataArry[i]["OrderStartDate"];
            var OrderStartDate = "";
            var OrderStartTime = "";
            if (OrderStartDateStr != "") {
                OrderStartDate = OrderStartDateStr.split(" ")[0];
                OrderStartTime = OrderStartDateStr.split(" ")[1];
            }
            //关联
            var OrderMasterSeqNo = DataArry[i]["OrderMasterSeqNo"];
			if ((parseFloat(OrderItemCongeriesNum)>0)&&(OrderMasterSeqNo!="")){
				OrderMasterSeqNo=parseFloat(OrderItemCongeriesNum)+OrderMasterSeqNo;
			}
            var OrderDepProcNotes = DataArry[i]["OrderDepProcNote"];
            var OrderPhSpecInstr = ""; //DataArry[i]["OrderPhSpecInstr"];
            var OrderCoverMainIns = DataArry[i]["OrderCoverMainIns"];
            var OrderActionRowid = DataArry[i]["OrderActionRowid"];
            var OrderEndDateStr = DataArry[i]["OrderEndDate"];
            var OrderEndDate = "";
            var OrderEndTime = "";
            if (OrderEndDateStr != "") {
                OrderEndDate = OrderEndDateStr.split(" ")[0];
                OrderEndTime = OrderEndDateStr.split(" ")[1];
            }
            var OrderLabSpecRowid = DataArry[i]["OrderLabSpecRowid"];
            var OrderMultiDate = "";
            var OrderNotifyClinician = "";
            var OrderDIACatRowId = DataArry[i]["OrderDIACatRowId"];
            //医保类别
            var OrderInsurCatRowId = DataArry[i]["OrderInsurCatRowId"];
            //医嘱首日次数
            var OrderFirstDayTimes = DataArry[i]["OrderFirstDayTimes"];
            //医保适应症
            var OrderInsurSignSymptomCode = "";
            //身体部位
            var OrderBodyPart = DataArry[i]["OrderBodyPart"];
            if (OrderBodyPart != "") {
                if (OrderDepProcNotes != "") {
                    OrderDepProcNotes = OrderDepProcNotes + "," + OrderBodyPart;
                } else {
                    OrderDepProcNotes = OrderBodyPart;
                }
            }
            //医嘱阶段
            var OrderStageCode = DataArry[i]["OrderStageCode"];
            //输液滴速
            var OrderSpeedFlowRate = DataArry[i]["OrderSpeedFlowRate"];
            var AnaesthesiaID = DataArry[i]["AnaesthesiaID"];
            var OrderLabEpisodeNo = DataArry[i]["OrderLabEpisodeNo"];
            var VerifiedOrderMasterRowid = "";
            //营养药标志
            var OrderNutritionDrugFlag = ""; //DataArry[i]["OrderNutritionDrugFlag"];
            //补录关联主医嘱信息 
            var LinkedMasterOrderRowid = DataArry[i]["LinkedMasterOrderRowid"];
            var LinkedMasterOrderSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
            if ((LinkedMasterOrderSeqNo != "") && (OrderMasterSeqNo == "")) {
                OrderMasterSeqNo = DataArry[i]["LinkedMasterOrderSeqNo"];
            }
            //审批类型
            var OrderInsurApproveType = ""; //DataArry[i]["OrderInsurApproveType"];
            //临床路径步骤
            var OrderCPWStepItemRowId = DataArry[i]["OrderCPWStepItemRowId"];
            //高值材料条码
            var OrderMaterialBarCode = DataArry[i]["OrderMaterialBarcodeHiden"];
            //输液滴速单位
            var OrderFlowRateUnit = DataArry[i]["OrderFlowRateUnit"];
            var OrderFlowRateUnitRowId = DataArry[i]["OrderFlowRateUnitRowId"];
            //开医嘱日期
            var OrderDate = "";
            var OrderTime = "";
            var OrderDateStr = Currtime; //DataArry[i]["OrderDate"];
            if (OrderDateStr != "") {
                OrderDate = OrderDateStr.split(" ")[0];
                OrderTime = OrderDateStr.split(" ")[1];
            }
            //需要配液
            var OrderNeedPIVAFlag = DataArry[i]["OrderNeedPIVAFlag"];
            //****************抗生素10********************************/
            // 管制药品申请
            var OrderAntibApplyRowid = DataArry[i]["OrderAntibApplyRowid"];
            //抗生素使用原因
            var AntUseReason = DataArry[i]["AntUseReason"];
            //使用目的
            var UserReasonId = DataArry[i]["UserReasonId"];
            var ShowTabStr = DataArry[i]["ShowTabStr"];
            //************************************************/
            //输液次数
            var OrderLocalInfusionQty = DataArry[i]["OrderLocalInfusionQty"];
            //个人自备
            var OrderBySelfOMFlag = "";
            if (DataArry[i]["OrderSelfOMFlag"]) OrderBySelfOMFlag = DataArry[i]["OrderSelfOMFlag"];
            var OrderOutsourcingFlag = "";
            if (DataArry[i]["OrderOutsourcingFlag"]) OrderOutsourcingFlag = DataArry[i]["OrderOutsourcingFlag"];
            //超量疗程原因
            var ExceedReasonID = DataArry[i]["ExceedReasonID"];
            //是否加急
            var OrderNotifyClinician = DataArry[i]["Urgent"];
            //整包装单位
            var OrderPackUOMRowid = DataArry[i]["OrderPackUOMRowid"];
            var OrderOperationCode=DataArry[i]["OrderOperationCode"];
			var OrderFreqDispTimeStr = DataArry[i]["OrderFreqDispTimeStr"]; 
			var OrderFreqInfo=DataArry[i]["OrderFreqFactor"]+"^"+DataArry[i]["OrderFreqInterval"]+"^"+OrderFreqDispTimeStr;
			var OrderDurFactor=DataArry[i]["OrderDurFactor"];
			var OrderQtySum=OrderPackQty;
            var OrderPriorRemarks = DataArry[i]["OrderPriorRemarksRowId"];
            //药理项目
            var OrderPilotProRowid = DataArry[i]["OrderPilotProRowid"];
            if (OrderDoseQty == "") { OrderDoseUOMRowid = "" }
            //检查申请子表记录Id
            var ApplyArcId="";
            //治疗申请预约ID
            var DCAARowId=""; //ServerObj.DCAARowId
            //临床知识库检测表id
            var OrderMonitorId=DataArry[i]["OrderMonitorId"];
            var OrderNurseLinkOrderRowid=DataArry[i]["OrderNurseLinkOrderRowid"];;
			var OrderBodyPartLabel=DataArry[i]["OrderBodyPartLabel"];
			if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
			var CelerType="N";	//快速医嘱套标识
			var OrdRowIndex=DataArry[i]["id"];
			var OrderFreqWeekStr="";
	    	var OrderOpenForAllHosp=0;
	    	var OrderFreqTimeDoseStr=DataArry[i]["OrderFreqTimeDoseStr"];
	    	if (OrderFreqTimeDoseStr!="") OrderDoseQty="";
	    	var OrderNurseBatchAdd="Y";
	    	///
	    	var OrderPracticePreRowid="" //OrderHiddenPara.split(String.fromCharCode(1))[19];
            OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
            OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
            OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
            OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
            OrderItem = OrderItem + "^" + OrderActionRowid + "^" + OrderARCOSRowid + "^" + OrderEndDate + "^" + OrderEndTime + "^" + OrderLabSpecRowid + "^" + OrderMultiDate;
            OrderItem = OrderItem + "^" + OrderNotifyClinician + "^" + OrderDIACatRowId + "^" + OrderInsurCatRowId + "^" + OrderFirstDayTimes + "^" + OrderInsurSignSymptomCode;
            OrderItem = OrderItem + "^" + OrderStageCode + "^" + OrderSpeedFlowRate + "^" + AnaesthesiaID + "^" + OrderLabEpisodeNo;
            OrderItem = OrderItem + "^" + LinkedMasterOrderRowid + "^" + OrderNutritionDrugFlag;
            OrderItem = OrderItem + "^" + OrderMaterialBarCode + "^^" + OrderCPWStepItemRowId + "^" + OrderInsurApproveType;
            OrderItem = OrderItem + "^" + OrderFlowRateUnitRowId + "^" + OrderDate + "^" + OrderTime + "^" + OrderNeedPIVAFlag + "^" + OrderAntibApplyRowid + "^" + AntUseReason + "^" + UserReasonId;
            OrderItem = OrderItem + "^" + OrderLocalInfusionQty + "^" + OrderBySelfOMFlag + "^" + ExceedReasonID + "^" + OrderPackUOMRowid + "^" + OrderPilotProRowid + "^" + OrderOutsourcingFlag;
            OrderItem = OrderItem + "^" + OrderItemRowid + "^" + ApplyArcId + "^" + DCAARowId + "^" + OrderOperationCode;
            OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr +"^"+ OrderOpenForAllHosp+"^"+OrderPracticePreRowid;
            OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr + "^" + OrderNurseBatchAdd;
		    if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
        }
    //} catch (e) { $.messager.alert("警告", e.message) }
    return OrderItemStr;
	function GetOrderItemByItemCongeries(Startid,OrderItemCongeriesJson,Count){
		var OrderItemCongeriesObj=eval("("+OrderItemCongeriesJson+")");
		var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",Startid);
		var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
		var CurrData=rows[index];
		var seqnoarr = new Array();
		var id=Count+1; //Startid;
		var OrderItemCount=0;
		//先计算成组标志
		for (var i=0,Length=OrderItemCongeriesObj.length;i<Length;i++) {
			OrderItemCongeriesObj[i].id=id;
			var CalSeqNo=OrderItemCongeriesObj[i].CalSeqNo;
			//记录关联关系
			var MasterSeqNo="";
			var tempseqnoarr = CalSeqNo.split(".");
			if (tempseqnoarr.length > 1) {
				var masterseqno = tempseqnoarr[0];
				if (seqnoarr[masterseqno]) {
					MasterSeqNo = seqnoarr[masterseqno];
				}
			}
			OrderItemCongeriesObj[i].OrderMasterSeqNo=MasterSeqNo;
			
			if (tempseqnoarr.length =1) {
				seqnoarr[CalSeqNo] = id;
			}
			OrderItemCount++;
			id++;
		}
		/*
		获取医嘱列表信息,数据对应的后台
		##Class(web.DHCOEOrdItemView).GetItemToList的InitParamArr
		*/
		var OrderItemStr="";
		for (var j=0,Length=OrderItemCongeriesObj.length;j<Length;j++) {
			var OrderARCIMRowid=OrderItemCongeriesObj[j].OrderARCIMRowid;
			var OrderType=OrderItemCongeriesObj[j].OrderType;
			var OrderPriorRowid=OrderItemCongeriesObj[j].OrderPriorRowid;
			var OrderStartDateStr=Currtime; //OrderItemCongeriesObj[j].OrderStartDate;
			var OrderStartDate="",OrderStartTime="";
			if (OrderStartDateStr!=""){
				var OrderStartDate = OrderStartDateStr.split(" ")[0];
	            var OrderStartTime = OrderStartDateStr.split(" ")[1];
            }
			var OrderPackQty=OrderItemCongeriesObj[j].OrderPackQty;
            var OrderPrice=OrderItemCongeriesObj[j].OrderPrice;
			var OrderRecDepRowid=OrderItemCongeriesObj[j].OrderRecDepRowid;
			var BillTypeRowid=OrderItemCongeriesObj[j].OrderBillTypeRowid;
			var OrderDrugFormRowid=OrderItemCongeriesObj[j].OrderDrugFormRowid;
			var OrderDepProcNote=OrderItemCongeriesObj[j].OrderDepProcNote;
			
			var OrderDoseQty=OrderItemCongeriesObj[j].OrderDoseQty;
			var OrderDoseUOMRowid=OrderItemCongeriesObj[j].OrderDoseUOMRowid;
			var OrderFreqFactor=OrderItemCongeriesObj[j].OrderFreqFactor;
			var OrderFreqInterval=OrderItemCongeriesObj[j].OrderFreqInterval;
			var OrderFreqDispTimeStr=OrderItemCongeriesObj[j].OrderFreqDispTimeStr;
			var OrderDurFactor=OrderItemCongeriesObj[j].OrderDurFactor;
			var OrderFirstDayTimes=OrderItemCongeriesObj[j].OrderFirstDayTimes;
			var OrderFreqRowid=OrderItemCongeriesObj[j].OrderFreqRowid;
			var OrderDurRowid=OrderItemCongeriesObj[j].OrderDurRowid;
			var OrderInstrRowid=OrderItemCongeriesObj[j].OrderInstrRowid;
			var OrderPHPrescType=OrderItemCongeriesObj[j].OrderPHPrescType;
			var OrderMasterSeqNo=OrderItemCongeriesObj[j].OrderMasterSeqNo;
			var OrderSeqNo=OrderItemCongeriesObj[j].id;
			var OrderSkinTest=OrderItemCongeriesObj[j].OrderSkinTest;
			var OrderPhSpecInstr = "";
			var OrderCoverMainIns = OrderItemCongeriesObj[j].OrderCoverMainIns;
			var OrderActionRowid=OrderItemCongeriesObj[j].OrderActionRowid;
			var OrderARCOSRowid=OrderItemCongeriesObj[j].OrderARCOSRowid;
			var OrderHiddenPara = OrderItemCongeriesObj[j].OrderHiddenPara;
			var OrderEndDate="",OrderEndTime="";
			var OrderLabSpecRowid=OrderItemCongeriesObj[j].OrderLabSpecRowid;
			var OrderMultiDate="";
			var OrderNotifyClinician=OrderItemCongeriesObj[j].Urgent;//是否加急
			var OrderDIACatRowId=OrderItemCongeriesObj[j].OrderDIACatRowId;
			var OrderInsurCatRowId=OrderItemCongeriesObj[j].OrderInsurCatRowId;
			var OrderInsurSignSymptomCode="";
			var OrderStageCode = OrderItemCongeriesObj[j].OrderStageCode;
			var OrderSpeedFlowRate=OrderItemCongeriesObj[j].OrderSpeedFlowRate;
			var AnaesthesiaID =CurrData["AnaesthesiaID"]; //OrderItemCongeriesObj[j].AnaesthesiaID;
			var OrderLabEpisodeNo="";
			var LinkedMasterOrderRowid=OrderItemCongeriesObj[j].LinkedMasterOrderRowid;
			var OrderNutritionDrugFlag = "";
			var OrderMaterialBarCode="";
			var OrderCPWStepItemRowId=OrderItemCongeriesObj[j].OrderCPWStepItemRowId;
			var OrderInsurApproveType="";
			var OrderFlowRateUnitRowId=OrderItemCongeriesObj[j].OrderFlowRateUnitRowId;
			
			var OrderDate = "";
            var OrderTime = "";
            var OrderDateStr = Currtime; //OrderItemCongeriesObj[j].OrderDate;
            if (OrderDateStr != "") {
                OrderDate = OrderDateStr.split(" ")[0];
                OrderTime = OrderDateStr.split(" ")[1];
            }
			var OrderNeedPIVAFlag=OrderItemCongeriesObj[j].OrderNeedPIVAFlag;
			//****************抗生素********************************/
			// 管制药品申请-TODO：当前快速医嘱套还不支持抗生素
            var OrderAntibApplyRowid = "";
            //抗生素使用原因
            var AntUseReason = "";
            //使用目的
            var UserReasonId = OrderItemCongeriesObj[j].UserReasonId; //GetCellData(Startid, "UserReasonId");
            //************************************************/
			var OrderLocalInfusionQty="";//输液次数           
			var OrderBySelfOMFlag=""; //个人自备
            var ExceedReasonID = "";//超量疗程原因
			var OrderPackUOMRowid=OrderItemCongeriesObj[j].OrderPackUOMRowid;
			//药理项目
            var OrderPilotProRowid = OrderItemCongeriesObj[j].OrderPilotProRowid; //GetCellData(Startid, "OrderPilotProRowid");
			var OrderOutsourcingFlag="N";	//外购
			var OrderItemRowid="";
            var ApplyArcId="";	//检查申请子表记录Id
            var DCAARowId="";	// GlobalObj.DCAARowId 治疗申请预约ID
			var OrderOperationCode=CurrData["OrderOperationCode"];
            var OrderMonitorId="";	//临床知识库检测表id TODO:快速医嘱套没有和临床知识库对接
            var OrderNurseLinkOrderRowid=OrderItemCongeriesObj[j].OrderNurseLinkOrderRowid;
			var OrderBodyPartLabel=OrderItemCongeriesObj[j].OrderBodyPartLabel;
			if (typeof OrderBodyPartLabel=="undefined"){OrderBodyPartLabel="";}
			var OrderFreqInfo=OrderFreqFactor+"^"+OrderFreqInterval+"^"+OrderFreqDispTimeStr;
			
			var OrderQtySum=OrderPackQty;
			var CelerType="Y";
			var OrdRowIndex=Startid;
			var OrderFreqWeekStr="",OrderOpenForAllHosp=0,OrderPracticePreRowid="",OrderFreqTimeDoseStr="",OrderNurseBatchAdd="Y";
			OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
            OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNote;
            OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
            OrderItem = OrderItem + "^" + OrderPHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
            OrderItem = OrderItem + "^" + OrderActionRowid + "^" + OrderARCOSRowid + "^" + OrderEndDate + "^" + OrderEndTime + "^" + OrderLabSpecRowid + "^" + OrderMultiDate;
            OrderItem = OrderItem + "^" + OrderNotifyClinician + "^" + OrderDIACatRowId + "^" + OrderInsurCatRowId + "^" + OrderFirstDayTimes + "^" + OrderInsurSignSymptomCode;
            OrderItem = OrderItem + "^" + OrderStageCode + "^" + OrderSpeedFlowRate + "^" + AnaesthesiaID + "^" + OrderLabEpisodeNo;
            OrderItem = OrderItem + "^" + LinkedMasterOrderRowid + "^" + OrderNutritionDrugFlag;
            OrderItem = OrderItem + "^" + OrderMaterialBarCode + "^^" + OrderCPWStepItemRowId + "^" + OrderInsurApproveType;
            OrderItem = OrderItem + "^" + OrderFlowRateUnitRowId + "^" + OrderDate + "^" + OrderTime + "^" + OrderNeedPIVAFlag + "^" + OrderAntibApplyRowid + "^" + AntUseReason + "^" + UserReasonId;
            OrderItem = OrderItem + "^" + OrderLocalInfusionQty + "^" + OrderBySelfOMFlag + "^" + ExceedReasonID + "^" + OrderPackUOMRowid + "^" + OrderPilotProRowid + "^" + OrderOutsourcingFlag;
            OrderItem = OrderItem + "^" + OrderItemRowid + "^" + ApplyArcId + "^" + DCAARowId + "^" + OrderOperationCode;
            OrderItem = OrderItem + "^" + OrderMonitorId + "^" + OrderNurseLinkOrderRowid + "^" + OrderBodyPartLabel + "^" + CelerType + "^" + OrdRowIndex + "^" + OrderFreqWeekStr +"^"+ OrderOpenForAllHosp+"^"+OrderPracticePreRowid;
            OrderItem = OrderItem + "^" + OrderFreqTimeDoseStr + "^" + OrderNurseBatchAdd;;
            
            if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
		}
		return {
			OrderItemStr:OrderItemStr,
			OrderItemCount:OrderItemCount
		};
		
	}
}
function SetFocusCell(ErrRowID, FocusCol){
	var index=ErrRowID-1;
    var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	
	var OrderItemCongeriesJson = rows[index]["OrderItemCongeries"];
	if (OrderItemCongeriesJson!=""){
		var ed=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:index,field:'OrderPackQty'});
		$(ed.target).focus().select();
	}
}
function ClearData(){
	ClearSessionData();
    ClearGridData();
    ClearPatKW();
    //解除患者锁
    tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
function ClearGridData(){
	PageLogicObj.m_ordlistDataGrid.datagrid("loadData",{'total':0,rows:[]});
	$("#ScreenBillSum").val("");
}
function ClearPatKW(){
	if (parent.DataGridUnSelectAll) {
		parent.DataGridUnSelectAll();
		$("#selPatKW").keywords('clearAllSelected');
		LoadselPatKW([]);
	}
}
function OrdLocChangeShow(that){
	$(that).popover('destroy');
	var rowid=that.id;
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var data=rows[index];
	var OrderRecLocStr=data['OrderRecLocStr'];
	var innerHTML='<ul class="loclist">';;
	var Arr=data['OrderRecLocStr'].split(String.fromCharCode(2));
	for (var i=0;i<Arr.length;i++){
		var id=Arr[i].split(String.fromCharCode(1))[0];
		if (id==data['OrderRecDepRowid']) continue;
		var text=Arr[i].split(String.fromCharCode(1))[1];
		innerHTML+='<li>';
		innerHTML+='<a href="#" id="'+id+'" onclick="ChangeRowLoc(\''+rowid+'\',\''+Arr[i]+'\')">'+text+'</a>';
		innerHTML+='</li>';
	}
	innerHTML+='</ul>'; 
	$(that).popover({
		width:190,
		height:100,
		title:$g("请选择需要切换的接收科室"),
		content:innerHTML,
		trigger:'hover',
		placement:'bottom'
	});
	$(that).popover('show');
}
function ChangeRowLoc(rowid,str){
	var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var data=rows[index];
	var id=str.split(String.fromCharCode(1))[0];
	var text=str.split(String.fromCharCode(1))[1];
	data['OrderRecDepRowid']=id;
	data['OrderRecDep']=text;
	//不建议使用updateRow 会导致数据异常
	$("#"+rowid)[0].text=text;
}
function SortRowClick(type){
	var SelIds=[];
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		SelIds[i]=rows[i]['id'];
	}
	if (SelIds.length==0){
		return false;   
	}
	SelIds.sort(function(a, b){ return a - b; });
	var MinRowid=SelIds[0];
	var MaxRowid=SelIds[SelIds.length-1];
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows") //.slice(0);
	var EnableSort=true;
	var CheckStart=0;
	for (var i = 0; i<rowids.length; i++){
		var LoopIndex=$.inArray(rowids[i]['id'],SelIds);
		if (LoopIndex!=-1){
			CheckStart=1;
		}
		if ((CheckStart==1)&&(LoopIndex==-1)&&(SelIds[SelIds.length-1]>rowids[i]['id'])){
			EnableSort=false;
			break;
		}
	}
	if (EnableSort==false){
		$.messager.alert("警告","请选择相邻的块进行移动!");
		return false;
	}
	var RecentlyRowid="";
	if (type=="up"){
		//先找到选择的医嘱项最近的一个医嘱行id
		for (var i = rowids.length-1; i >=0; i--) {
			if (parseInt(rowids[i]['id'])<parseInt(SelIds[0])){
				RecentlyRowid=rowids[i]['id'];
				break;
			}
		}
	}else{
		for (var i = 0; i <rowids.length; i++) {
			if (parseInt(rowids[i]['id'])>parseInt(SelIds[SelIds.length-1])){
				RecentlyRowid=rowids[i]['id'];
				break;
			}
		}
	}
	if (RecentlyRowid==""){return;}
	//找到需要调整的行数据
	var NeedMoveRowids = new Array();
	//记录虽然本身行未调整,但是关联的数据调整了,需要调整成组标识
	var NeedChangeMasterRowids = new Array();
	///以下逻辑是为了找出需要配合移动的行
	//关联医嘱也不一定都是主医嘱在上，子医嘱在下，这里统一寻找需要移动的成组行
	var RecentlyIndex=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",RecentlyRowid);
	
	var RecentlyOrderMasterSeqNo=rowids[RecentlyIndex].OrderMasterSeqNo; 
	var RecentlyOrderSeqNo=RecentlyRowid;
	if (RecentlyOrderMasterSeqNo!=""){
		RecentlyOrderSeqNo=RecentlyOrderMasterSeqNo
	}
	var RecentlyLinkRowidList=GetSeqNolist(RecentlyRowid);
	if (RecentlyOrderMasterSeqNo==""){
		RecentlyLinkRowidList.push(RecentlyRowid);
	}
	RecentlyLinkRowidList.sort(function(a, b){ return a - b; });
	
	for (var i = 0; i < rowids.length; i++) {
        var OrderMasterSeqNo = rowids[i]['OrderMasterSeqNo']; 
        var OrderSeqNo = rowids[i]['id']; 
        var OrderItemRowid = rowids[i]['OrderItemRowid'];
        var OrderARCIMRowid = rowids[i]['OrderARCIMRowid']; 
        var OrderType = rowids[i]['OrderType'];
		
        if ((parseInt(rowids[i]['id'])>=parseInt(RecentlyLinkRowidList[0]))&&(parseInt(rowids[i]['id'])<=parseInt(RecentlyLinkRowidList[RecentlyLinkRowidList.length-1]))) {
			//往下移动时，需移动行上面的行数据不需要更改
			//虽然上面的行数据不需要更改，但是如果关联了下半部分的医嘱，上面的行的数据的组数据要进行修改，添加到NeedChangeMasterRowids中
			if (((type=="down")&&(parseInt(rowids[i]['id'])<=parseInt(MaxRowid)))||((type=="up")&&(parseInt(rowids[i]['id'])>=parseInt(MinRowid)))){
				if ((OrderSeqNo == RecentlyOrderSeqNo)||(OrderMasterSeqNo == RecentlyOrderSeqNo)){
					NeedChangeMasterRowids.push(rowids[i]['id']); 
				}
				continue;
			}
	    	NeedMoveRowids.push(rowids[i]["id"]);
	    }
    }
    if (NeedMoveRowids.length==0){return;}
    ///这里获得了需要重拍的队列
    var MoveList = new Array();
    if (type=="up"){
	    //这个变量是为了防止移动行和被移动行之间存在已删除行数据，定义一个初始化偏移变量
	    var BaseMoveLength=parseInt(SelIds[0])-parseInt(NeedMoveRowids[NeedMoveRowids.length-1])-1;
		var NeedMoveLength=parseInt(SelIds[0])-parseInt(NeedMoveRowids[0]);
		MoveList=SelIds.concat(NeedMoveRowids);
	}else{
		var BaseMoveLength=parseInt(NeedMoveRowids[0])-parseInt(SelIds[SelIds.length-1])-1;
		var NeedMoveLength=parseInt(NeedMoveRowids[NeedMoveRowids.length-1])-parseInt(SelIds[SelIds.length-1]);
		MoveList=NeedMoveRowids.concat(SelIds);
	}
	var MoveIndexList=new Array();
	$.each(MoveList,function(i,rowid){
		MoveIndexList[i]=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	})
	var DataArry=new Array();
	for (var i=0;i<MoveList.length;i++){
		//var rowid=MoveList[i];
		var curIndex=  MoveIndexList[i]; //PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid); //parseInt(rowid)-1; //
		var curRowData = rowids[curIndex];
		var OrderMasterSeqNo=curRowData["OrderMasterSeqNo"].toString();
		var OrderSeqNo=curRowData["id"];
        if (type=="up"){
			//前几个是需要向上移动的行
			if (i<SelIds.length){
				curRowData["id"]=(parseInt(curIndex)+1)-parseInt(NeedMoveLength); //parseInt(curRowData["id"])-parseInt(NeedMoveLength);
				curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)-parseInt(NeedMoveLength);
			}else{
				var NeedMoveLength=0;
		        for (var j=0;j<SelIds.length;j++){
			    	if (parseInt(curRowData["id"])<parseInt(SelIds[j])){
				    	NeedMoveLength++;
				    }
			    }
				curRowData["id"]=(parseInt(curIndex)+1)+parseInt(NeedMoveLength); //parseInt(curRowData["id"])+parseInt(NeedMoveLength);
				curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)+parseInt(SelIds.length);
			}
		}else{
			//前几个是需要向上移动的行
			if (i<NeedMoveRowids.length){
				curRowData["id"]=(parseInt(curIndex)+1)-parseInt(SelIds.length)-parseInt(BaseMoveLength); //parseInt(curRowData["id"])-parseInt(SelIds.length)-parseInt(BaseMoveLength);
				if ($.inArray(parseInt(OrderMasterSeqNo), MoveList)>=0){
					curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)-parseInt(SelIds.length)-parseInt(BaseMoveLength);
				}
			}else{
				curRowData["id"]=(parseInt(curIndex)+1)+parseInt(NeedMoveLength); //parseInt(curRowData["id"])+parseInt(NeedMoveLength);
				if (OrderMasterSeqNo!=""){
					curRowData["OrderMasterSeqNo"]=parseInt(OrderMasterSeqNo)+parseInt(NeedMoveLength);
				}
			}
		}
		if (($.isNumeric(curRowData["OrderMasterSeqNo"])==false)||(curRowData["OrderMasterSeqNo"]==0)){
			curRowData["OrderMasterSeqNo"]="";
		}
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', curIndex);
		if (editors.length>0){
			curRowData['OrderPackQty']=editors[0].target.val();
			curRowData['OrderPrice']=editors[1].target.val();
			curRowData['OrderSum']=editors[2].target.val();
			curRowData['OrderRecDepRowid']=editors[3].target.combobox('getValue');
			curRowData['OrderRecDep']=editors[3].target.combobox('getText');
		}
		//curRowData["rowid"]=curRowData["id"];
        DataArry[DataArry.length]=curRowData;
	}
	///这里获取到了需要编辑的行队列
	var SortList=MoveIndexList.slice(0);
	SortList.sort(function(a, b){return a - b;});
	$.each(SortList,function(k,rowid){ //
		var index=rowid;
        var NeedChangeData=DataArry[k];
		PageLogicObj.m_ordlistDataGrid.datagrid('getData').rows[index] = NeedChangeData;
		PageLogicObj.m_ordlistDataGrid.datagrid('refreshRow', index);
		SetBeginEdit(DataArry[k]['id']);
        if (type=="up"){
			//前几个是
			if (k<SelIds.length){
				PageLogicObj.m_ordlistDataGrid.datagrid('checkRow', index);
			}else{
				PageLogicObj.m_ordlistDataGrid.datagrid('uncheckRow', index);
			}
		}else{
			if (k<NeedMoveRowids.length){
				PageLogicObj.m_ordlistDataGrid.datagrid('uncheckRow', index);
			}else{
				PageLogicObj.m_ordlistDataGrid.datagrid('checkRow', index);
			}
		}
	});
}
//根据行号获取所有关联医嘱 
function GetSeqNolist(rowid) {
	var allrows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows") //.slice(0);
	var dataidex=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
	
    var OrderSeqNoMain = allrows[dataidex]['id'];
    var OrderMasterSeqNoMain = allrows[dataidex]['OrderMasterSeqNo'];
    var tmprowids = new Array();
    
    for (var i = 0; i < allrows.length; i++) {
	    
        var OrderMasterSeqNo = allrows[i]['OrderMasterSeqNo'];// GetCellData(AllRowids[i], "OrderMasterSeqNo");
        var Orderid = allrows[i]['id']; //GetCellData(AllRowids[i], "id");
        if (OrderMasterSeqNoMain == "") {
            if (OrderSeqNoMain == OrderMasterSeqNo) { tmprowids[tmprowids.length] = allrows[i]['id']; }
        } else {
            if ((OrderMasterSeqNoMain == Orderid) || (OrderMasterSeqNo == OrderMasterSeqNoMain)) { tmprowids[tmprowids.length] = allrows[i]['id']; }
        }
    }
    return tmprowids;
}
function FindSupplementedOrdClick(){
	var AdmStr=GetSelPatKW();
	if (AdmStr=="") {
		$.messager.alert("提示", "请先勾选患者!");
	    return websys_cancel();
	}
	var Content="<div id='Win' style='border-bottom:1px dashed #ccc;'>"
		   Content +="	<table class='search-table'>"
		       Content +="	 <tr>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 "+$g("开始日期")
		       	Content +="	 </td>"
		       	Content +="	 <td>"
		       		Content +="	 <input id='winSttDate' class='hisui-datebox textbox'></input>"
		       	Content +="	 </td>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 "+$g("结束日期")
		       	Content +="	 </td>"
		       	Content +="	 <td>"
		       		Content +="	 <input id='winEndDate' class='hisui-datebox textbox'></input>"
		       	Content +="	 </td>"
		       	Content +="	 <td class='r-label'>"
		       		Content +="	 <a href='#' onClick='LoadSupplementedOrd()'class='hisui-linkbutton' data-options="+"iconCls:'icon-w-find'"+">"+$g("查询")+"</a>"
		       	Content +="	 </td>"
		       Content +="	 </tr>"
		   Content +="	</table>"
	   Content += "</div>"
	Content +="<div><table id='tabSupplementedOrd' style='margin:5px;border:none;'></table></div>";
	var iconCls="icon-w-list";
	createModalDialog("OrdList",$g("已批量补录医嘱明细"), 800, 500,iconCls,"",Content,"InitSupplementedOrd()");
}
var selOrdRowIndex="";
function InitSupplementedOrd(){
	var o=$HUI.datebox('#winSttDate,#winEndDate');
	o.setValue(ServerObj.CurrentDate);
	var OrdToolBar=[{
            text: $g('撤销'),
            iconCls: 'icon-cancel-order',
            handler: function() {ShowCancelMulOrdWin();}
        },{
            text: $g('作废'),
            iconCls: 'icon-abort-order',
            handler: function() {ShowUnUseMulOrdWin();}
        }];
	var Columns=[[ 
		{field:'OEORIRowId',checkbox:true},
		{field:'TStDate',title:'补录日期',width:135},
		{field:'OrderName',title:'医嘱名称',width:120},
		{field:'PackQty',title:'数量',width:40},
		{field:'BillUOMDesc',title:'单位',width:40},
		{field:'TDoctor',title:'补录人',width:90},
		{field:'ReLoc',title:'接收科室',width:100},
		{field:'MaterialBarCode',title:'条码',width:80}
    ]]
	$("#tabSupplementedOrd").datagrid({  
		height:390,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : true,
		autoSizeColumn : true,
		rownumbers:false,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		idField:'OEORIRowId',
		columns:Columns,
		toolbar:OrdToolBar,
		rowStyler: function(index,row){
			if (row['OEORIRowId'].indexOf("||")<0){
				return 'background-color:#cdf1cd;';
			}
		},
		onSelect:function(index, row){
			if (selOrdRowIndex!="") return false;
			var OEORIRowId=row["OEORIRowId"];
			if (OEORIRowId.indexOf("||")<0) {
				var GridData=$("#tabSupplementedOrd").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					if (GridData.rows[m]["OEORIRowId"].split("||")[0]==OEORIRowId) {
						$("#tabSupplementedOrd").datagrid('checkRow',m);
					}
				}
			}else{
				var TOeoriOeori=row["TOeoriOeori"];
				if (TOeoriOeori!=""){
					var index=$("#tabSupplementedOrd").datagrid('getRowIndex',TOeoriOeori);
					$("#tabSupplementedOrd").datagrid('checkRow',index);
				}else{
					var GridData=$("#tabSupplementedOrd").datagrid("getData");
					for (var m=index+1;m<GridData.rows.length;m++){
						var TOeoriOeori=GridData.rows[m]["TOeoriOeori"];
						if (TOeoriOeori==OEORIRowId) {
							selOrdRowIndex=m;
							$("#tabSupplementedOrd").datagrid('checkRow',m);
						}
					}
				}
				selOrdRowIndex="";
			}
		},
		onUnselect:function(index, row){
			if (selOrdRowIndex!="") return false;
			var OEORIRowId=row["OEORIRowId"];
			if (OEORIRowId.indexOf("||")<0) {
				var GridData=$("#tabSupplementedOrd").datagrid("getData");
				for (var m=index+1;m<GridData.rows.length;m++){
					if (GridData.rows[m]["OEORIRowId"].split("||")[0]==OEORIRowId) {
						$("#tabSupplementedOrd").datagrid('uncheckRow',m);
					}
				}
			}else{
				var TOeoriOeori=row["TOeoriOeori"];
				if (TOeoriOeori!=""){
					var index=$("#tabSupplementedOrd").datagrid('getRowIndex',TOeoriOeori);
					$("#tabSupplementedOrd").datagrid('uncheckRow',index);
				}else{
					var GridData=$("#tabSupplementedOrd").datagrid("getData");
					for (var m=index+1;m<GridData.rows.length;m++){
						var TOeoriOeori=GridData.rows[m]["TOeoriOeori"];
						if (TOeoriOeori==OEORIRowId) {
							selOrdRowIndex=m;
							$("#tabSupplementedOrd").datagrid('uncheckRow',m);
						}
					}
				}
				selOrdRowIndex="";
			}
		},
		onLoadSuccess:function(data){
			$("#tabSupplementedOrd").datagrid("clearChecked")
		}
	});
	LoadSupplementedOrd();
}
function LoadSupplementedOrd(){
	var AdmStr=GetSelPatKW();
	$.q({
	    ClassName : "web.DHCDocNurseBatchSupplementOrd",
	    QueryName : "GetNurseBatchOrdList",
	    AdmStr : AdmStr,
	    SttDate:$("#winSttDate").datebox('getValue'),
	    EndDate:$("#winEndDate").datebox('getValue'),
	    LocId:session['LOGON.CTLOCID'],
	    Pagerows:$("#tabSupplementedOrd").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#tabSupplementedOrd").datagrid("clearChecked").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function searchItemkeydown(e){
	if (e.keyCode == 13) {
		if ($("#searchByBarcode").checkbox('getValue')){
			setTimeout(function(){
				OrderMaterialBarcodeContrl();
			})
		}
	}
}
function OrderMaterialBarcodeContrl(){
	var label=$("#searchItem").lookup('getText');
	if (label=="") return false;
	var AricmStr = cspRunServerMethod(ServerObj.GetArcimByLabel, label)
    var ArcimArr = AricmStr.split("^")
    var arcimRowid = ArcimArr[0];
    if (arcimRowid == "") {
        $.messager.alert("提示","该条码对应的医嘱项目不存在,请核实!")
        return false;
    }
    if (ArcimArr[1] == "Enable") {
        var IncItmHighValueFlag = ArcimArr[7]
        if (IncItmHighValueFlag == "N") {
			var OrdParamsArr=new Array();
			OrdParamsArr[OrdParamsArr.length]={
				OrderARCIMRowid:arcimRowid,
				MaterialBarcode:label
			};
			var rowid=GetNewrowid();
			new Promise(function(resolve,rejected){
				AddItemToList(rowid,OrdParamsArr,"data","",resolve);
			}).then(function(RtnObj){
				var rowid=RtnObj.rowid;
				var returnValue=RtnObj.returnValue;
				if (returnValue) {
	                ClearSearch();
	            }
	            $("#searchItem").focus().select();
			})
        } else {
	        var AdmStr=GetSelPatKW();
	        if ((AdmStr!="")&&(AdmStr.split("!").length>1)){
		        $.messager.alert("提示","高值条码只能一人使用!")
                return false;
		    }
            if (ServerObj.HighValueControl != 1) {
                $.messager.alert("提示","您所登录的科室没有录入高值材料的权限,请联系信息科确认!")
                return false;
            }
            //返回的是实库存数量。其实可以走统一的库存判断不用在这做判断
            var avaQty = ArcimArr[4]
            if (avaQty <= 0) {
                $.messager.alert("提示","该条码对应的医嘱库存不足.")
                return false;
            }
            var ReLocId = ArcimArr[5] //材料可用接收科室
            if (arcimRowid != "") {
                var ReLocIdFlag = "N";
				var OrdParamsArr=new Array();
				OrdParamsArr[OrdParamsArr.length]={
					OrderARCIMRowid:arcimRowid,
					MaterialBarcode:label
				};
				var rowid=GetNewrowid();
				new Promise(function(resolve,rejected){
					AddItemToList(rowid,OrdParamsArr,"data","",resolve);
				}).then(function(RtnObj){
					var rowid=RtnObj.rowid;
					var returnValue=RtnObj.returnValue;
	                if (returnValue == true) {
		                var data=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
		                var index=PageLogicObj.m_ordlistDataGrid.datagrid("getRowIndex",rowid);
		                var OrderRecLocStr=data[index]['OrderRecLocStr']
	                    var ArrData = OrderRecLocStr.split(String.fromCharCode(2));
	                    for (var i = 0; i < ArrData.length; i++) {
	                        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
	                        if ((ArrData1[0] == ReLocId) && (ReLocIdFlag != "Y")) { ReLocIdFlag = "Y" };
	                    }
	                    if (ReLocIdFlag == "N") {
	                        $.messager.alert("提示","该条码不能在该科室使用!")
	                        PageLogicObj.m_ordlistDataGrid.datagrid("deleteRow",index);
	                    }
	                    ClearSearch();
	        			$("#searchItem").focus();
	                }
				})
            }
        }
    } else {
        $.messager.alert("提示","该条码不存在或者已被使用!")
        return false;
    }
}
function InitKWPopover(){
	$("#selPatKW li").each(function(){
		var that=$(this);
		var ID=that.attr('id');
		that.on({
			mouseenter:function(){
				if (LoadPopover("Load",that.attr('id'))){
					//浮动内容
					var HTML=GetPannelHTML(that.attr('id'));
					if (HTML.innerHTML==""){return;}
					that.webuiPopover({
						width:HTML.width,
						height:HTML.height,
						title:HTML.Title,
						content:HTML.innerHTML,
						trigger:'hover',
						placement:'auto-bottom',
						onShow:function(){
							if (LoadPopover("Show",that.attr('id'))){
								if (typeof HTML.CallFunction == "function"){
									HTML.CallFunction.call();
								}
							}
						}
					});
					that.webuiPopover('show');
				}
			}
		});
	});
}
var LoadPopover=(function(){
	///防止多次初始化数据
	var AlreadLoadObj={};	//初始化元素
	var AlreadShowObj={};	//初始化显示数据
	return function(Type,ID){
		if (Type=="Load"){
			if (typeof AlreadLoadObj[ID] =="undefined"){
				AlreadLoadObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Show"){
			if (typeof AlreadShowObj[ID] =="undefined"){
				AlreadShowObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Clear"){
			 AlreadLoadObj={};	//初始化元素
			 AlreadShowObj={};
		}
		
	}
})();
///获取动态写入的HTML代码
function GetPannelHTML(LinkID){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	var width=280,height=150
	var Title=$g("补录主医嘱信息");
	
	var LinkedMasterOrderRowid="";
	var ItemArr=$("#selPatKW").keywords('options').items;
	for (var i=0;i<ItemArr.length;i++){
		if (ItemArr[i]['id']==LinkID) {
			var LinkedMasterOrderRowid=ItemArr[i]['LinkedMasterOrderRowid'];
			if (typeof LinkedMasterOrderRowid=="undefined"){LinkedMasterOrderRowid="";}
		}
	}
	if (LinkedMasterOrderRowid=="") {
		return {
			"innerHTML":innerHTML,
			"CallFunction":CallFunction,
			"Title":Title,
			"width":width,
			"height":height
		}
	}
	var JsonData=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetLinkMasterOrdList",LinkedMasterOrderRowid);
	var JsonData=eval("("+JsonData+")");
	innerHTML+='<ul class="loclist" style="list-style-type:none">';
	var CurrArcimDR="",OrdItem="";
	if (JsonData.length>0){
		for (var i=0,length=JsonData.length;i<length;i++) {
			var OrdName=JsonData[i].OrdName;
			var OrderId=JsonData[i].OrderId;
			OrdName=OrdName+" "+$g("医嘱")+"ID:"+OrderId;
			innerHTML+='<li>';
			innerHTML+='<a href="#" id="'+OrderId+'" onclick="DelLinkMasterOrd(\''+OrderId+'\',\''+LinkID+'\')">'+OrdName+'</a>';
			innerHTML+='</li>'
		}
	}
	innerHTML+='</ul>'; 
	height=(JsonData.length)*40;
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title,
		"width":width,
		"height":height
	}
}
function DelLinkMasterOrd(OrderId,AdmId){
	
}
//卡消费
function CardBillClick() {
	var AdmStr=GetSelPatKW();
	if (AdmStr == "") { 
		$.messager.alert("提示", "缺少患者信息!"); 
		return false; 
	}
	if ((AdmStr!="")&&(AdmStr.split("!").length>1)){
		$.messager.alert("提示", "只能单个患者进行卡消费!");
		return false;
	}
    var EpisodeID = AdmStr;
    //tkMakeServerCall("web.DHCDocOrderListCommon","ComonItemWinte",EpisodeID)
	var ret=tkMakeServerCall("web.DHCDocNurseBatchSupplementOrd","GetCardBillNeedInfo",EpisodeID);
    var PatientID = ret.split(String.fromCharCode(1))[0];
    //var CardNo = ret.split(String.fromCharCode(1))[1];
    var PAAdmType= ret.split(String.fromCharCode(1))[4];
    if (PAAdmType=="I") {
	    $.messager.alert("提示", "住院患者不能进行预扣费!");
		return false;
	}
	
    DHCACC_GetCardBillInfo(PatientID,function(CardInfo){
		var CardNo=CardInfo.split("^")[0];
		var CardTypeRowId=CardInfo.split("^")[1];
		if (CardNo==""){
			$.messager.alert("提示", "无效的卡信息!"); return; 
		}
		if (ServerObj.CheckOutMode == 1) {
		    $.messager.confirm('提示', '是否确认扣费?', function(r){
				if (r){
					var CardTypeDefine = tkMakeServerCall("web.UDHCOPOtherLB","ReadCardTypeDefineListBroker1",CardTypeRowId);
					if ($("#CardBillCardTypeValue").length==0) {
						$('body').append("<input id='CardBillCardTypeValue' name='CardBillCardTypeValue' type='hidden' value='"+CardTypeDefine+"'>");
					}else{
						$("#CardBillCardTypeValue").val(CardTypeDefine);
					}
					
				     //var insType = GetPrescBillTypeID();
				    var insType = tkMakeServerCall("DHCDoc.Common.pa","GetDefaultBillTypeByPa",PatientID)
			        var oeoriIDStr = "";
			        var guser = session['LOGON.USERID'];
			        var groupDR = session['LOGON.GROUPID'];
			        var locDR = session['LOGON.CTLOCID'];
			        var hospDR = session['LOGON.HOSPID'];
			        var rtn = checkOut(CardNo, PatientID, EpisodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR);
			        CardBillAfterReload();
				}
			});
	    }else{
		 	var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" +  EpisodeID + "&SelectPatRowId=" + PatientID + "&CardTypeRowId=" + CardTypeRowId;
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
	});
    return;
	
}
function CardBillAfterReload(){
    if (parent.refreshBar){
    	parent.refreshBar();
    }else if(parent.parent.refreshBar){
        parent.parent.refreshBar();
    }
}
function ShowCancelMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"C")) return false;
   var title=$g("撤销(DC)医嘱");
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("C");
   var iconCls="icon-w-edit";
   createModalDialog("OrdDiag",title, 380, 210,iconCls,$g("撤销(DC)"),Content,"MulOrdDealWithCom('C')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
function ShowUnUseMulOrdWin(){
   if (!CheckIsCheckOrd()) return false;
   var SelOrdRowStr=GetSelOrdRowStr();
   if (!CheckOrdDealPermission(SelOrdRowStr,"U")) return false;
   var title=$g("作废医嘱");
   destroyDialog("OrdDiag");
   var Content=initDiagDivHtml("U")
   var iconCls="icon-w-edit";
   createModalDialog("OrdDiag",title, 380, 210,iconCls,$g("作废"),Content,"MulOrdDealWithCom('U')");
   InitOECStatusChReason();
   $('#OECStatusChReason').next('span').find('input').focus();
}
function InitOECStatusChReason(){
	 var cbox = $HUI.combobox("#OECStatusChReason", {
		required:true,
		editable: true,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'id',
	  	textField:'text',
	  	data:eval("("+ServerObj.OECStatusChReasonJson+")")
	});
}
//医嘱处理公共方法,以type区分不同功能
function MulOrdDealWithCom(type){
   /*
   type入参说明
   ---处理医嘱
   C:撤销医嘱
   U:作废医嘱
   */
   var date="",time="";
   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
   var pinNum="";
   var ReasonId="",Reasoncomment="";
   if ((type=="C")||(type=="U")){
	   ReasonId=$("#OECStatusChReason").combobox("getValue");
	   Reasoncomment=$("#OECStatusChReason").combobox("getText");
	   if (ReasonId==Reasoncomment) ReasonId="";
	   else if (ReasonId!="") Reasoncomment="";
	   if ((ReasonId=="")&&(Reasoncomment=="")){
		   $.messager.alert("提示","请选择或者填写原因!","info",function(){
			   $('#OECStatusChReason').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if ((Reasoncomment!="")&&(Reasoncomment.indexOf("^")>=0)){
			$.messager.alert("提示","撤销原因分隔符^是系统保留符号,请更换成其他符号!",function(){
				$('#OECStatusChReason').next('span').find('input').focus();
			});
			return false;
	   }
   }
   /*if ((type=="C")||(type=="U")){
		if (ExeCASigin("")==false){
			return false;
		} 
   }*/
   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
   if ($("#winPinNum").length>0){
	   pinNum=$("#winPinNum").val();
	   if (pinNum==""){
		   $.messager.alert("提示","密码不能为空!","info",function(){
			   $("#winPinNum").focus();
		   });
		   return false;
	   }
   }
   var SelOrdRowStr=GetSelOrdRowStr();
   $.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdDealWithCom",
	    OrderItemStr:SelOrdRowStr,
	    date:date,
	    time:time,
	    type:type,
	    pinNum:pinNum,
	    ExpStr:ExpStr
	},function(val){
		var alertCode=val.split("^")[0];
		if ((type=="U")&&(alertCode=="-901")){
			$.messager.alert("提示",val.split("^")[1]);
			alertCode="0";
		}
		if (alertCode=="0"){
			/*if ((type=="S")||(type=="C")||(type=="U")){             //2018-9-4 fxn ca签名
				ExeCASigin(SelOrdRowStr);  
			}*/
			LoadSupplementedOrd();
			destroyDialog("OrdDiag");
		}else{
			$.messager.alert("提示",val);
			return false;
		}
	});
}
function initDiagDivHtml(type){
   if((type=="C")||(type=="U")){
	   var html="<div id='DiagWin' style='margin-top: 5px;'>"
		   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
		   		html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 "+$g("请选择原因")
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
		        html +="	 </tr>"
		       
		   		html +="	 <tr>"
		       		html +="	 <td class='r-label'>"
		       			html +="	 "+$g("密码")
		       		html +="	 </td>"
		       		html +="	 <td>"
		       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true' onkeydown='DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")' />"
		       		html +="	 </td>"
		       	html +="	 </tr>"
		       	
		   html +="	</table>"
	   html += "</div>"
   }
   return html;
}
function CheckIsCheckOrd(){
   var SelOrdRowArr=$("#tabSupplementedOrd").datagrid('getChecked'); //医嘱处理以勾选为准,未勾选代表不处理
   if (SelOrdRowArr.length==0){
	   $.messager.alert("提示","没有勾选医嘱!")
	   return false;
   }
   var Length=0
   $.each(SelOrdRowArr,function(Index,RowData){
	    var OEORIRowId=RowData.OEORIRowId;
	    if ((OEORIRowId!="")&&(OEORIRowId.indexOf("||")>=0)){
			++Length;
		}
   });
   if (Length==0){
	   $.messager.alert("提示","没有勾选医嘱!");
	   return false;
   }
   return true;
}
function GetSelOrdRowStr(){
   var SelOrdRowStr=""
   var SelOrdRowArr=$("#tabSupplementedOrd").datagrid('getChecked');
   for (var i=0;i<SelOrdRowArr.length;i++){
	   var OEORIRowId=SelOrdRowArr[i].OEORIRowId;
	   if ((OEORIRowId=="")||(OEORIRowId.indexOf("||")<0)){
		    continue;  
	   }
	   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].OEORIRowId;
	   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].OEORIRowId;
   }
   return SelOrdRowStr;
}
function CheckOrdDealPermission(SelOrdRowStr,type){
   var rtn=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"CheckMulOrdDealPermission",
	    OrderItemStr:SelOrdRowStr,
	    date:"",
	    time:"",
	    type:type,
	    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
	},false);
   if (rtn!=0){
	   $.messager.alert("提示",rtn);
	   return false;
   }else{
	   return true;
   }
}
function DiagDivKeyDownHandle(HandleType,EventType){
  if (HandleType=="Confirm"){
     if (window.event.keyCode=="13"){
        MulOrdDealWithCom(EventType);
        return false;
     }
  }
}
///得到菜单参数
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
function getRowIndex(target){
	var tr =$(target).closest("tr.datagrid-row");
	return parseInt(tr.attr("datagrid-row-index")); 
}
function ChangeLinkOrderOperation(index){
	var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderSeqNoMain=rows[index]["rowid"];
	var OrderOperationCode=rows[index]["OrderOperationCode"];
	for (var i=index+1;i<rows.length;i++) {
		var OrderMasterSeqNo=rows[i]["OrderMasterSeqNo"];
		if (OrderMasterSeqNo==OrderSeqNoMain) {
			var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:i,field:'OrderOperation'});
			$(OrderRecDepObj.target).combobox('select',OrderOperationCode);
		}
		if (OrderMasterSeqNo=="") return;
	}
}
function ChangeLinkOrderRecDept(index){
	var rows = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var OrderSeqNoMain=rows[index]["rowid"];
	var OrderRecDepRowid=rows[index]["OrderRecDepRowid"];
	for (var i=index+1;i<rows.length;i++) {
		var OrderMasterSeqNo=rows[i]["OrderMasterSeqNo"];
		if (OrderMasterSeqNo==OrderSeqNoMain) {
			var OrderRecDepObj=PageLogicObj.m_ordlistDataGrid.datagrid('getEditor', {index:i,field:'OrderRecDep'});
			$(OrderRecDepObj.target).combobox('select',OrderRecDepRowid);
		}
		if (OrderMasterSeqNo=="") return;
	}
}

function GetOrderSeqArr(rowid){
	var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	var selOrderSeqNo=rowids[rowid]["id"];
	var selOrderMasterSeqNo=rowids[rowid]["OrderMasterSeqNo"];
	
	var rowidArr = [];
    rowidArr.push(selOrderSeqNo);
	for (var i=0;i<rowids.length;i++) {
		var OrderSeqNo=rowids[i]["id"];
		if ( selOrderSeqNo == OrderSeqNo) continue;
		var OrderMasterSeqNo=rowids[i]["OrderMasterSeqNo"];
		if ((selOrderSeqNo == OrderMasterSeqNo) || (selOrderMasterSeqNo==OrderSeqNo) ||((selOrderMasterSeqNo!="")&&(selOrderMasterSeqNo==OrderMasterSeqNo))){
			rowidArr.push(OrderSeqNo);
		}
	}
	return rowidArr;
}
function GetUnSaveOrdCount(){
	var DataArry = PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	return DataArry.length;
}
function FindByLogDepCheckChange(e){
	var itemsArr=$("#selPatKW").keywords('options').items;
	if ((itemsArr.length>1)&&(GetUnSaveOrdCount()>0)){
		$.messager.confirm('确认','切换取接收科室模式将导致当前未审核记录的接收科室不正确，是否清除未审核记录?',function(r){    
		    if (r){    
		        ClearGridData();
		    }
		    $("#searchItem").focus();  
		}); 
	}
}
function ChgFindByLogDepCheckStatus(){
	var itemsArr=$("#selPatKW").keywords('options').items;
	var _$FindByLogDep=$("#FindByLogDep");
	_$FindByLogDep.checkbox('enable');
	if (itemsArr.length>1) {
		if (!_$FindByLogDep.checkbox('getValue')) {
			_$FindByLogDep.checkbox('check')
		}
		_$FindByLogDep.checkbox('disable');
	}
}
function GetParamAdm(){
	var Adm="";
	var AdmStr=GetSelPatKW();
	var AdmStrArr=AdmStr.split("!");
	if ((AdmStr!="")&&(AdmStrArr.length==1)) Adm=AdmStrArr[0];
	return Adm;
}
function SetScreenSum() {
	var UnSavedSum = 0
	var rows=PageLogicObj.m_ordlistDataGrid.datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var editors = PageLogicObj.m_ordlistDataGrid.datagrid('getEditors', i);
		if (editors.length >0) {
			UnSavedSum=parseFloat(UnSavedSum) + parseFloat(editors[2].target.val());
		}else{
			UnSavedSum=parseFloat(UnSavedSum) + parseFloat(rows[i].OrderSum);
		}
	}
	$("#ScreenBillSum").val(fomatFloat(UnSavedSum,2));
}
// num为传入的值，n为保留的小数位
function fomatFloat(num,n){   
    var f = parseFloat(num);
    if(isNaN(f)){
        return false;
    }   
    f = Math.round(num*Math.pow(10, n))/Math.pow(10, n); // n 幂   
    var s = f.toString();
    var rs = s.indexOf('.');
    //判定如果是整数，增加小数点再补0
    if(rs < 0){
        rs = s.length;
        s += '.'; 
    }
    while(s.length <= rs + n){
        s += '0';
    }
    return s;
} 
function InitTempFrame()
{
	var TempHeight=ServerObj.TempHeightScale?($('#layoutMain').height()*ServerObj.TempHeightScale/100):400;
	var TempWidth=ServerObj.TempWidthScale?($('#layoutMain').width()*ServerObj.TempWidthScale/100):300;
    var src="oeorder.entry.template.csp?TemplateRegion="+ServerObj.TemplateRegion+"&EditMode=0";
    if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
    var content="<iframe id='templateFrame' name='templateFrame' width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
    if(ServerObj.TemplateRegion=='window'){
        $('<div id="templateWin"></div>').appendTo('body').window({
            title:$g('医嘱模板'),
            minimizable:false,
            maximizable:false,
            closable:false,
            closed:false,
            modal:false,
            width:TempWidth,
            height:$(window).height()-150,
            content:content,
            onCollapse:function(){
                $(this).window('resize',{
                    width: 100
                }).window('move',{
                    top:$(window).height()-100,
                    left:$(window).width()-150
                });
            },
            onExpand:function(){
                $(this).window('resize',{
                    width: TempWidth
                }).window('move',{
                    top:100,
                    left:$(window).width()-350
                });
            }
        }).window('move',{left:$(window).width()-330});
        if(ServerObj.DefCollapseTemplate=='on') $('#templateWin').window('collapse');
    }else{
        $('#layoutMain').layout('add',{
            region:ServerObj.TemplateRegion,
            border:false,
            collapsible:false,
            split:true,
            width:TempWidth,
            height:TempHeight,
            style:{'overflow':'hidden'},
            content:content
        });
    }
    $('#templateFrame').parent().css({'overflow':'hidden'});
}
//模板编辑模式切换
function TemplateModeChange(mode)
{
	var TempWidth=ServerObj.TempWidthScale?($('#layoutMain').width()*ServerObj.TempWidthScale/100):300;
    var width=mode?TempWidth:800;
    if(ServerObj.TemplateRegion=='window'){
        $('#templateWin').window('resize',{
            width: width
        }).window('move',{
            top:100,
            left:$(window).width()-width-10
        });
    }else if(['north','south'].indexOf(ServerObj.TemplateRegion)>-1){
    }else{
        $('#layoutMain').layout('panel',ServerObj.TemplateRegion).panel('resize',{width:width});
        $('#layoutMain').layout('resize');
        return;
    }
}
//模版选择医嘱
function addSelectedFav(itemid,text,note,partInfo,callBackFun) {
	var ItemType=itemid.indexOf("||")>-1?'ARCIM':'ARCOS';
	var ProcNote=note||'';
    var OrderBodyPartLabel=partInfo||'';
    if (ItemType == "ARCIM") {
		var OrdParamsArr=new Array();
		OrdParamsArr.push({
			OrderARCIMRowid:itemid,
			ItemDefaultRowId:"",
			OrderBodyPartLabel:OrderBodyPartLabel,
			OrderDepProcNote:ProcNote
		});
		var rowid=GetNewrowid();
		new Promise(function(resolve,rejected){
			AddItemToList(rowid,OrdParamsArr,"obj","",resolve);
		}).then(function(RtnObj){
			var rowid=RtnObj.rowid;
			var returnValue=RtnObj.returnValue;
		})
    } else {
        OSItemListOpen(itemid, "", "YES", "", "");
        if(callBackFun) callBackFun();
    }
}

/* 修改按钮可用状态 */
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}

//取上一行ID 不传参数取当前最后一行
function GetPreRowId(rowid) {
    var prerowid = "";
    var rowids = PageLogicObj.m_ordlistDataGrid.datagrid("getRows")
    if ($.isNumeric(rowid) == true) {
        for (var i = rowids.length; i >= 0; i--) {
            if (rowids[i]['id'] == rowid) {
                if (i == 0) {
                    prerowid = rowids[i]['id'];
                } else {
                    prerowid = rowids[i - 1]['id'];
                }
                break;
            }
        }
    }
    if (prerowid == "") {
        if (rowids.length == 0) {
            prerowid = ""
        } else {
            prerowid = rowids[rowids.length - 1]['id'];
        }
    }
    return prerowid;
}