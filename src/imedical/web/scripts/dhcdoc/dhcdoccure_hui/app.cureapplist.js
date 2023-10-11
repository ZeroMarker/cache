var CureApplyDataGrid;
var DCARowId="";
var $dg;
var idsArray = new Array();
$(document).ready(function(){	
	$dg = $("#tabCureApplyList");
	Init();
	InitEvent();
	PageHandle();		
	CureApplyDataGridLoad();
	
});

function Init(){
	//卡类型列表
    var CardTypeObj=$HUI.combobox('#cardType',{      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCardType&ResultSetType=array",
	});	
	InitCureApplyDataGrid();
}

function InitEvent(){
	$('#btnFind').bind('click', function(){
		CureApplyDataGridLoad();
	});
	
	$('#btnClear').bind('click', function(){
		ClearHandle();
	});
	$('#patNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var patNo=$("#patNo").val();
			if(patNo!=""){
			for (var i=(10-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#patNo").val(patNo);
				var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
			}else{
				var PatientID="";
			}
			$("#PatientID").val(PatientID);
			CureApplyDataGridLoad();
		}
	});
    
	$('#patName').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureApplyDataGridLoad();
		}
	});
    
    $('#cardNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{  
			if ($("#patNo").val()!="")$("#patNo").val("");
			var cardType=$("#cardType").combobox('getValue');
			if (cardType=="") return;
			var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			if (cardTypeInfo=="") return;
			var cardNoLength=cardTypeInfo.split("^")[16];
			//alert(cardNoLength);
			var cardNo=$("#cardNo").val();
			if(cardNo=="") return;
			if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
				for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
					cardNo="0"+cardNo;
				}
			}
			$("#cardNo").val(cardNo);
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			if(PatientID=="")
			{
				alert("卡无效");
				return;
			}
			$("#PatientID").val(PatientID);
			CureApplyDataGridLoad();
		}
	});
	$('#btnReadCard').bind('click', function(){
		ReadCardClick();
	});  
	$('#btnReadInsuCard').bind('click', function(){
		ReadInsuCardClick();
	});
	$('#btnSearchApp').bind('click', function(){
		ReadInsuCardClick();
	});
}

function PageHandle(){
	if(ServerObj.myTriage=="Y"){
		$HUI.checkbox("#Distributed",{
			onChecked:function(e,val){
				$HUI.checkbox("#ALLDis").uncheck();	
				setTimeout("CureApplyDataGridLoad();",10)
			}	
		})
		$HUI.checkbox("#ALLDis",{
			onChecked:function(e,val){
				$HUI.checkbox("#Distributed").uncheck();	
				setTimeout("CureApplyDataGridLoad();",10)
			}	
		})		
	}else{
		$HUI.checkbox("#CancelDis",{
			onChecked:function(e,val){
				$HUI.checkbox("#FinishDis").uncheck();
				setTimeout("CureApplyDataGridLoad();",10)	
			}	
		})
		$HUI.checkbox("#FinishDis",{
			onChecked:function(e,val){
				$HUI.checkbox("#CancelDis").uncheck();
				setTimeout("CureApplyDataGridLoad();",10)
			}	
		})	
		ControlButton(true);
	}	
}

function ClearHandle(){
	$("#cardNo").val("");
	$("#patNo").val("");
	$("#patName").val("");
	$("#PatientID").val("");
	$("#StartDate").datebox("setValue","");	
	$("#EndDate").datebox("setValue","");	
	/*$('#CancelDis').attr('checked',false);
	$('#FinishDis').attr('checked',false);
	$('#Distributed').attr('checked',false);
	$('#ALLDis').attr('checked',false);*/
	var ops={checked:false};
	$HUI.checkbox("#CancelDis",ops);
	$HUI.checkbox("#FinishDis",ops)
	$HUI.checkbox("#Distributed",ops)
	$HUI.checkbox("#ALLDis",ops)
	
}
function ControlButton(val){
	if(val==true){
		$('#btnExecOrd').linkbutton({    
		    disabled: true  
		}); 
		$('#btnExecOrd').unbind()
		$('#btnCancelExecOrd').linkbutton({    
		    disabled: true
		});	
		$('#btnCancelExecOrd').unbind()
	}else{
		$('#btnExecOrd').linkbutton({    
		    disabled: false  
		}); 

		$('#btnCancelExecOrd').linkbutton({    
		    disabled: false
		});
		$('#btnExecOrd').unbind();
		$('#btnCancelExecOrd').unbind();
		$('#btnCancelExecOrd').bind('click', function(){
			 CancelExecOrd();
    	});	
		$('#btnExecOrd').bind('click', function(){
			 ExecOrdClick();
    	});	
	}
}
function InitCureApplyDataGrid()
{
	// Toolbar
	var cureApplyToolBar = [/*{
		id:'BtnCall',
		text:'叫号',
		iconCls:'icon-add',
		handler:function(){
			FormMatterPatName();		 
		}
	},'-',{
		id:'BtnClear',
		text:'清屏', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	},'-',*/{
		id:'BtnDetailView',
		text:'申请单浏览', 
		iconCls:'icon-search',  
		handler:function(){
			OpenApplyDetailDiag();
		}
	}
	];
	// 治疗记录申请单Grid
	CureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		//pageNumber:0,
		pageSize : 5,
		pageList : [5,10,50,100],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					{field:'RowCheck',checkbox:true},     
        			{field:'PatNo',title:'登记号',width:35,align:'center'},   
        			{field:'PatName',title:'姓名',width:30,align:'center'
					},   
        			{field:'PatSex',title:'性别',width:10,align:'center'},
        			{field:'PatAge',title:'年龄',width:10,align:'center'},
        			{field:'PatTel',title:'联系电话',width:45,align:'center'},
        			{field:'AdmType',title:'就诊类型',width:25,align:'center'},
        			{field:'AdmDep',title:'就诊科室',width:40,align:'center'},    
        			{field:'ArcimDesc',title:'治疗项目',width:50,align:'center'},
        			{field:'OrdQty',title:'数量',width:20,align:'center'}, 
        			{field:'OrdBillUOM',title:'单位',width:20,align:'center'}, 
					{field:'OrdPrice',title:'总金额',width:20,align:'center'}, 
					{field:'OrdBilled',title:'是否缴费',width:30,align:'center',
        				styler: function(value,row,index){
							if (value == "否"){
								return 'background-color:#ffee00;color:red;';
							}
						}
					},
        			{field:'OrdReLoc',title:'接收科室',width:40,align:'center'},   
        			{field:'ApplyStatus',title:'申请单状态',width:30,align:'center'},
        			{field:'ApplyUser',title:'申请医生',width:30,align:'center'},
        			{field:'ApplyDateTime',title:'申请时间',width:30,align:'center'},
        			{field:'ApplyAppedTimes',title:'已预约次数',width:20,align:'center',hidden:(ServerObj.myTriage=="Y")?true:false},
        			{field:'ApplyNoAppTimes',title:'未预约次数',width:20,align:'center',hidden:(ServerObj.myTriage=="Y")?true:false},
        			{field:'ApplyFinishTimes',title:'已治疗次数',width:20,align:'center',hidden:(ServerObj.myTriage=="Y")?true:false},
        			{field:'ApplyNoFinishTimes',title:'未治疗次数',width:20,align:'center',hidden:(ServerObj.myTriage=="Y")?true:false},
					//{field:'ServiceGroup',title:'服务组',width:30,align:'center',hidden:(HiddenLoc.indexOf(session['LOGON.CTLOCID'])<0)?true:false}, //HiddenLoc.indexOf(session['LOGON.CTLOCID'])
					{field:'ServiceGroup',title:'服务组',width:30,align:'center'}, 
					{ field: 'ApplyExec', title: '是否可预约', width: 40, align: 'center',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
						,styler: function(value,row,index){
							if (value.indexOf("直接执行")>=0){
								return 'background-color:#FF6347;';
							}
						}
					},
					{field:'HistoryTriRes',title:'上次分配',width:30,align:'center',hidden:true,hidden:(ServerObj.myTriage=="Y")?false:true},
					//{ field: 'CallStatus', title: '呼叫状态', width: 30, align: 'center',resizable: true},
					{field:'ServiceGroupID',title:'服务组id',width:30,align:'center',hidden:true},
					{field:'ControlFlag',title:'',width:10,align:'center',hidden:true},
        			{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
						   
    			 ]] ,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			loadTabData()
		},
		onCheck:function(rowIndex, rowData){
			//loadTabData()
			var ret=CheckSelectedRow(rowIndex, rowData);
			if(ret){
				loadTabData();
			}
		},
		onUncheck:function(rowIndex, rowData){
			loadTabData();
		},
		onBeforeLoad:function(data){
			//addSelectedGoodsIdToArray();
			//alert(idsArray.length)
		},
		rowStyler:function(index,row){   
	        if (row.CallStatus=="正在呼叫"){   
	            return 'background-color:green;';   
	        }   
	    },
	    onLoadSuccess: function () {   //隐藏表头的checkbox
                $(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .attr("style", "display:none;");
            }  
	});
	$('#tabs').tabs({
       onSelect: function(title,index){
	     loadTabData()
       }
    });

}

function addSelectedGoodsIdToArray(){
	 var rows = $dg.datagrid('getSelections');
	 if(rows.length>0){
	     $.each(rows,function(i,row){
	         if(idsArray.length == 0){
	             idsArray.push(row.DCARowId);
	         }else{
	             for(var index=0;index<idsArray.length;index++){
	                 if(idsArray[index] == row.DCARowId){
	                     break;
	                 }
	                if(index == idsArray.length-1){
	                     idsArray.push(row.DCARowId);
	                     break;
	                 }
                 }
             }
         });
     }
 }
 
function CheckSelectedRow(rowIndex, rowData){
	var selected=CureApplyDataGrid.datagrid('getRows'); 
	var SelServiceGroup=selected[rowIndex].ServiceGroup;
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var ApplyExec=selected[rowIndex].ApplyExec;
	var length=rows.length;
	var finflag=0;
	for(var i=0;i<length;i++){
		var MyServiceGroup="";
		var MyServiceGroup=rows[i].ServiceGroup;
		if(SelServiceGroup!=MyServiceGroup){
			$.messager.alert("错误","一次选择只能选中相同服务组的申请单！",'err')
			CureApplyDataGrid.datagrid("uncheckRow",rowIndex);
			finflag=1;
			break;		
		}
	}
	if(finflag==1)return false;
	return true;
}

function loadTabData()
{
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var DCARowId="";DCARowIdStr="";
	var ControlVal=0;
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var ApplyExec=rows[i].ApplyExec;
		var Billed=rows[i].OrdBilled;
		//var ControlVal=rows[i].ControlFlag;
		if(rows[i].ControlFlag==1){
			ControlVal=1;	
		}
		if(DCARowIdStr==""){
			DCARowIdStr=DCARowIds;
		}else{
			DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
		}
	}
	if(ControlVal==1){
		ControlButton(false);
	}else{
		ControlButton(true);	
	}
	_SELECT_DCAROWID=DCARowIdStr;
	var title = $('.tabs-selected').text();
	var href=""
	if (title=="预约") 
	{href="doccure.applyreslist.hui.csp?OperateType=ZLYY&DCARowId="+DCARowId+"&DCARowIdStr="+DCARowIdStr;}
	else if (title=="预约列表") 
	{href="doccure.applyapplist.hui.csp?OperateType=ZLYY&DCARowId="+DCARowId+"&DCARowIdStr="+DCARowIdStr;}
	else if (title=="可分配资源列表") 
	{href="doccure.triagereslist.hui.csp?OperateType=ZLYY&DCARowId="+DCARowId+"&DCARowIdStr="+DCARowIdStr;}
	else if (title=="分配列表") 
	{href="doccure.curetriagelist.hui.csp?OperateType=ZLYY&DCARowId="+DCARowIdStr+"&DCARowIdStr="+DCARowIdStr;}
	if(href=="")return;
	if(window.frames["applyreslist"]){
		var fAppDate=window.frames["applyreslist"].test();
		href=href+"&AppDate="+fAppDate;
	}
	refreshTab({tabTitle:title,url:href}); 
}

function CureApplyDataGridLoad()
{
	var patNo=$("#patNo").val();
	var cardNo=$("#cardNo").val();
	if(patNo!=""){
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
	}else if((cardNo!="")&&(cardNo!=undefined)){
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo)
	}else{
		var PatientID="";
		$("#PatientID").val(PatientID);
	}
	var patName=$("#patName").val()
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var TriageFlag=ServerObj.myTriage;
	
	var DisCancelFlag="";
	var FinishDisFlag="";
	if(TriageFlag=="Y"){
		var Distributed=$HUI.checkbox("#Distributed").getValue()
		if (Distributed){DisCancelFlag="Y"}
		var ALLDis=$HUI.checkbox("#ALLDis").getValue()
		if (ALLDis){FinishDisFlag="Y"}
	}else{
		var CancelDis=$HUI.checkbox("#CancelDis").getValue()
		if (CancelDis){DisCancelFlag="Y"}
		var FinishDis=$HUI.checkbox("#FinishDis").getValue()
		if (FinishDis){FinishDisFlag="Y"}
	}

	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'outCancel':DisCancelFlag,
		'FinishDis':FinishDisFlag,
		'PatName':patName,
		'TriageFlag':TriageFlag,
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		Pagerows:CureApplyDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureApplyDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	CureApplyDataGrid.datagrid("uncheckAll");
}

function OpenApplyDetailDiag()
{
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("提示","请选择一个申请单");
			return;
	}else if (rows.length>1){
	     	$.messager.alert("错误","您选择了多个申请单！",'err')
	     	return;
     }
	var DCARowId=""
	var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureApplyDataGrid.datagrid('getRows'); 
	var DCARowId=selected[rowIndex].DCARowId;
	if(DCARowId=="")
	{
			$.messager.alert('Warning','请选择一条申请单');
			return false;
	}
	var href="doccure.apply.hui.csp?DCARowId="+DCARowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:70em;dialogheight:35em;status:no;center:1;resizable:yes");
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
	    var _refresh_ifram = refresh_tab.find('iframe')[0];  
	    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
		if(typeof websys_writeMWToken=='function') refresh_url=websys_writeMWToken(refresh_url);   
	    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}
function ReadCardClick()
{
	var cardType=$("#cardType").combobox('getValue');
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    //alert(CardInform)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			document.getElementById('cardNo').value=""
			break;
		default:
			document.getElementById('cardNo').value=myary[1] //myary[2]
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			if(PatientID=="")
			{
				 alert("卡无效");
				 return;
			}
			$("#PatientID").val(PatientID);
			CureApplyDataGridLoad();
			break;
	}
		
    
}
function ReadInsuCardClick()
{
	$("#cardType").combobox('setValue',4)
	var cardType=$("#cardType").combobox('getValue');
	var CardInform=DHCACC_ReadMagCard(cardType,"","","");
	var myary=CardInform.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			document.getElementById('cardNo').value=""
			break;
		
		default:
			document.getElementById('cardNo').value=myary[1];
			/*
			var myrtn=DHCACC_GetAccInfo("",myary[1],"","PatInfo");
			var myary=myrtn.split("^");
			var rtn=myary[0];
			AccAmount=myary[3];
			//alert(myrtn)

			switch (rtn){
			case "-200": //卡无效
				alert("卡无效");
				document.getElementById('PatientNo').value=""
				websys_setfocus("PatientNo");
				break;
			default:
				//alert(myrtn)
				document.getElementById('PatientNo').value=myary[5]
				return Find_click();
				websys_setfocus("PatientNo");
				break;
				}*/
			break;
	}
}
  
function ExecOrdClick(){
	var myType="E";
	UpdateExecOrd(myType);	
	CureApplyDataGridLoad();
	ControlButton(true);
}

function CancelExecOrd(){
	var myType="C";
	UpdateExecOrd(myType);
	CureApplyDataGridLoad();
	ControlButton(true);
}
 function UpdateExecOrd(InType){
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("提示","请选择一个申请单");
			return;
	}else if (rows.length>1){
	     	//$.messager.alert("错误","您选择了多个申请单！",'err')
	     	//return;
     }
	var DCARowId="";
	var DCARowIdStr=""
	
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var OrdBilled=rows[i].OrdBilled;
		var ApplyExec=rows[i].ApplyExec;
		var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
		if((ApplyExec.indexOf("直接执行")<0)||(OrdBilled=="否")){
			//CureApplyDataGrid.datagrid("uncheckRow",rowIndex);
			//continue;
		}else{
			if(DCARowIdStr==""){
				DCARowIdStr=DCARowIds;
			}else{
				DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
			}
		}
	}	
	if(DCARowIdStr==""){
		$.messager.alert('提示','未有可执行的申请');
		return false;	
	}
	var ExecType=InType;
	var DefaultNum=1;
	if(ExecType=="E"){
		//DefaultNum=selected[rowIndex].OrdQty;
	}
	var href="doccure.exec.hui.csp?ExecType="+ExecType+"&DefaultNum="+DefaultNum+"&DCARowIdStr="+DCARowIdStr;
	var ReturnValue=window.showModalDialog(href,"","dialogWidth:1050px;dialogHeight:650px;status:no;center:1;resizable:yes");
 } 
 
 function FormMatterPatName(val,row){
	//以下程序仅支持东华叫号接口
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var DCAARowId="",DCARowId="",DCAOEOREDR=""
	if (rows.length>=1)
	{
		var succsss=true;
		for(var i=0;i<rows.length;i++){
			var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
			var selected=CureApplyDataGrid.datagrid('getRows'); 
			var DCARowId=selected[rowIndex].DCARowId;
			//DCAOEOREDR=selected[rowIndex].OEOREDR;
			var PatName=selected[rowIndex].PatName;
			var treatID=selected[rowIndex].ServiceGroupID;
			//alert(DCAARowId)
			//return;
			/*
			深圳市中医院  治疗室 叫号接口
			web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
			callinfo          请 张三 进入治疗室
			user              userID
			computerIP        计算机IP
			treatID           治疗类型ID   
			*/
			var callinfo="请"+PatName+"进入治疗室";
			var computerIP=GetComputerIp()
			var loguser=session['LOGON.USERID'];
			var logloc=session['LOGON.CTLOCID'];
			var ret="0"; 
			//alert(callinfo+";"+loguser+";"+computerIP+";"+callinfo+";"+logloc+";"+treatID);
			var ret=tkMakeServerCall("web.DHCVISVoiceCall","InsertVoiceQueue",callinfo,loguser,computerIP,"A","LR","N",callinfo,logloc,"",treatID)
			//alert("InsertVoiceQueue+"+ret)
			if(ret=="0"){
				var callret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","UpdateTreatCallStatus",DCARowId,"Y")
				if(callret!=0){
					var errmsg=PatName+"更新呼叫状态失败";
					$.messager.alert("错误", errmsg, 'error')
					succsss=false;
					return false;
				}else{
					//alert("呼叫成功")
					//$.messager.alert("提示", "呼叫成功")
				}
			}else{
				var errmsg=PatName+"呼叫失败:"+ret
				$.messager.alert("错误", errmsg, 'error')
				succsss=false;
				return false;
			}
		}
		if(succsss==true){
			$.messager.alert("提示", "呼叫成功")		
		}
	}else{
		$.messager.alert("错误", "请选择一位病人再呼叫.", 'error')
		 return false;
	}
}

function GetComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //连接本机服务器
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
   var e = new Enumerator (properties);
   var p = e.item ();

   for (;!e.atEnd();e.moveNext ())  
   {
  	var p = e.item ();  
 	//document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
	ipAddr=p.IPAddress(0); 
	if(ipAddr) break;
	}

	return ipAddr;
}

function RefreshDataGrid(){
	if(CureApplyDataGrid){
		CureApplyDataGridLoad();
		CureApplyDataGrid.datagrid('unselectAll');	
	}
}