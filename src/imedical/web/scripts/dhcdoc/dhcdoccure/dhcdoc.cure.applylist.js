var cureApplyDataGrid;
var DCARowId=""
$(function(){
	/*
    if (PatientID=="")
	{
		var frm =dhcsys_getmenuform();
        if (frm) 
        {
			EpisodeID=frm.EpisodeID.value;
			PatientID=frm.PatientID.value;
        }
	}
	*/
	InitCureApplyDataGrid();
	
	
});

//初始化
function Int()
{
	loadCureApplyDataGrid()
	IntCatdType()
	$('#btnReadCard').click(ReadCard)
	$('#patNoIn').keydown(patNoInKeyDown) 
	$('#patNoIn').keyup(patNoInkeyup) 
	$('#btnFind').click(loadCureApplyDataGrid)
	$('#cardNo').keydown(cardNoKeyDown)
	$('#cardNo').keyup(cardNokeyUp)
	$('#DocApplayNo').keydown(DocApplayNoKeyDown)
	$('#btnFinish').click(btnFinish) //申请单治疗完成后使用该功能
	
	
	
}

//进行申请单的完成操作
function btnFinish()
{
	var rows = cureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("提示","请选择一个申请单");
			return false;
	}else if (rows.length>1){
	     	$.messager.alert("错误","您选择了多个申请单！",'err')
	     	return false;
     }
	var DCARowId=""
	var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=cureApplyDataGrid.datagrid('getRows'); 
	var DCARowId=selected[rowIndex].DCARowId;
	if(DCARowId=="")
	{
			$.messager.alert('Warning','请选择一条申请单');
			return false;
	}
	var Rtn=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","FinishCureApply",DCARowId,session['LOGON.USERID'])
	if (Rtn==0){
		$.messager.alert('提示','操作成功!');
		return false;
	}else{
		$.messager.alert('错误','操作失败:'+Rtn);
		return false;
		
	}
}

function DocApplayNoKeyDown(e)
{
	if(e.keyCode==13){
		var DocApplayNo=$('#DocApplayNo').val()
		if (DocApplayNo==""){$.messager.alert("提示","请输入有效的申请单号");return false}
		loadCureApplyDataGrid()
	}
	
}
function cardNokeyUp()
{
	var CardNo=$('#cardNo').val()
	if (CardNo==""){
		 $("#patNo").val("");
		 $("#PatientID").val('')
		 
	}
	
}
//卡号回车
function cardNoKeyDown(e)
{
	if(e.keyCode==13)
	 {  
		      $("#patNo").val("");
		      $("#PatientID").val('')
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType==""){$.messager.alert("提示","卡类型不存在!");return false;} 
		      var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			  if (cardTypeInfo==""){ $.messager.alert("提示","卡配置信息获取失败");return false;}
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return false;
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			 $("#cardNo").val(cardNo);
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			 if(PatientID=="")
			 {
				 $("#cardNo").val('');
				 $.messager.alert("提示","卡无效");
				 return false;
			 }
			$("#PatientID").val(PatientID)
			loadCureApplyDataGrid()
			 
	}	
	
}

function patNoInkeyup()
{
	var patNoIn=$("#patNoIn").val()
	if (patNoIn==""){
		$("#PatientID").val('')
	}
	
}
function patNoInKeyDown(e)
{

	if(e.keyCode==13)
	{
		 $("#cardNo").val("");
		  var patNo=$("#patNoIn").val();
		  if(patNo=="") return;
		  for (var i=(10-patNo.length-1); i>=0; i--) {
			patNo="0"+patNo;
		}
		$("#patNoIn").val(patNo);
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		if (PatientID==""){
			$.messager.alert("提示","未查询到登记号对应的患者信息，请确认登记号是否正确!");
			$("#patNoIn").val('');
			$("#PatientID").val('')
			return false
		}
		else{
			
			$("#PatientID").val(PatientID)
			loadCureApplyDataGrid()
		}
		
	}
	
	
}
//读卡
function ReadCard()
{
	$("#cardType").combobox('setValue',2)
	var cardType=$("#cardType").combobox('getValue');
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!");
			$('#cardNo').val('')
			$("#PatientID").val('')
			break;
		default:
			$('#cardNo').val(myary[1])
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			 if(PatientID=="")
			 {
				 $.messager.alert("提示","卡未查询到有效的患者信息!");
				 $("#cardNo").val('');
				 return;
			 }
			 $("#PatientID").val(PatientID)
			 loadCureApplyDataGrid()
			 break;
	}

}
//初始化卡类型
function IntCatdType()
{
	
		//卡类型列表
    $('#cardType').combobox({      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'FindCardType'
						param.ArgCnt =0;
		}  
	});	
	

     $('#cardNo').bind('keydown', function(event){
		  
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()==""){$("#PatientID").val("");}
    });
	
	
	
}

//初始化申请单Table
function InitCureApplyDataGrid()
{
	// Toolbar
	var cureApplyToolBar = [{
		id:'BtnDetailView',
		text:'申请单浏览', 
		iconCls:'icon-search',  
		handler:function(){
			OpenApplyDetailDiag();
		}
	}
	,'-',{
		id:'BtnClear',
		text:'清屏', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	}];
	// 治疗记录申请单Grid fit : true,
	cureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"DCARowId",
		pageNumber:0,
		pageSize : 0,
		pageList : [5],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
		
					{field:'RowCheck',checkbox:true},
					{field:'PapmiNo',title:'患者登记号',width:150,align:'center'},
					{field:'PatName',title:'患者姓名',width:100,align:'center'},
					{field:'Sex',title:'性别',width:50,align:'center'},
					{field:'Tel',title:'患者电话',width:150,align:'center'},  
					{field:'GovNo',title:'身份证',width:100,align:'center',hidden:true},
					{field:'DocCurNO',title:'申请单编号',width:150,align:'center'},
        			{field:'ArcimDesc',title:'申请名称',width:200,align:'center'},
        			{field:'OrdStatus',title:'医嘱状态',width:80,align:'center',hidden:true},
        			{field:'OrdBillUOM',title:'计价单位',width:100,align:'center'}, 
        			{field:'OrdReLoc',title:'接收科室',width:150,align:'center'},   
        			{field:'ApplyStatus',title:'状态',width:80,align:'center',
        				styler:function(value,row,index){
	        				if (value=="取消"){
		        				return 'color:red'	
		        			}
	        			}
        			},
        			{field:'ApplyUser',title:'下单医生',width:120,align:'center'},
        			{field:'AppLoc',title:'下单科室',width:120,align:'center'},
        			{field:'ApplyDateTime',title:'申请时间',width:200,align:'center'},
        			{field:'OrdQty',title:'申请数量',width:100,align:'center'}, 
        			{field:'ApplyAppedTimes',title:'已约次数',width:100,align:'center'},
        			{field:'ApplyNoAppTimes',title:'未约次数',width:100,align:'center'},
        			{field:'ApplyFinishTimes',title:'已治疗',width:100,align:'center'},
        			{field:'ApplyNoFinishTimes',title:'未治疗',width:100,align:'center'},
        			{field:'ApplyRemarks',title:'备注',width:150,align:'center'},
        			{field:'ApplyPlan',title:'治疗方案',width:150,align:'center'},
        			{field:'Adm',title:'就诊号',width:150,align:'center'},
        			{field:'InsertDate',title:'申请单日期',width:100,align:'center',hidden:true},
        			{field:'InsertTime',title:'申请单时间',width:100,align:'center',hidden:true},
        			
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true},
        			{field:'OrdReLocId',title:'OrdReLocId',width:100,hidden:true}	   
    			 ]] ,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			//alert()
			loadTabData()
		}
	});
	$('#tabs').tabs({
  onSelect: function(title,index){
	loadTabData()
  }
});

}

//查询 申请单列表
function loadCureApplyDataGrid()
{
	//EpisodeID
	var DisCancel=""
	var DisFinish=""
	var PatientID=$("#PatientID").val()
	var CancelDis=$("#CancelDis").prop("checked")
	if (CancelDis){DisCancel="Y"}
	var FinishDis=$("#FinishDis").prop("checked")
	if (FinishDis){DisFinish="Y"}
	var DocApplayNo=$('#DocApplayNo').val()
	
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindCureApplyList';
	queryParams.Arg1 ="";
	queryParams.Arg2 =PatientID;
	queryParams.Arg3 =session['LOGON.CTLOCID'];
	queryParams.Arg4 =DisCancel;
	queryParams.Arg5 =DocApplayNo;
	queryParams.Arg6 =DisFinish;
	queryParams.ArgCnt =6;
	var opts = cureApplyDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyDataGrid.datagrid('load', queryParams);
	cureApplyDataGrid.datagrid('unselectAll');
}
//查询申请单对应的治疗记录
function loadTabData()
{
		var rows = cureApplyDataGrid.datagrid("getSelections");
		var DCARowId=""
		if (rows.length==1)
		{
		var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=cureApplyDataGrid.datagrid('getRows'); 
		var DCARowId=selected[rowIndex].DCARowId;
		}
		var title = $('.tabs-selected').text();
		var href=""
		if (title=="预约") 
		{href="dhcdoc.cure.applyreslist.csp?OperateType=YS&DCARowId="+DCARowId;}
		else if (title=="预约列表") 
		{href="dhcdoc.cure.applyapplist.csp?OperateType=YS&DCARowId="+DCARowId;}
		else if (title=="治疗记录列表") 
		{href="dhcdoc.cure.curerecordlist.csp?OperateType=YS&DCARowId="+DCARowId;}
		//alert(href);
		if(href=="")return;
		refreshTab({tabTitle:title,url:href}); 
}

function OpenApplyDetailDiag()
{
	var rows = cureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
			$.messager.alert("提示","请选择一个申请单");
			return;
	}else if (rows.length>1){
	     	$.messager.alert("错误","您选择了多个申请单！",'err')
	     	return;
     }
	var DCARowId=""
	var rowIndex = cureApplyDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=cureApplyDataGrid.datagrid('getRows'); 
	var DCARowId=selected[rowIndex].DCARowId;
	if(DCARowId=="")
	{
			$.messager.alert('Warning','请选择一条申请单');
			return false;
	}
	
	var href="dhcdoc.cure.apply.csp?DCARowId="+DCARowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#ApplyDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "治疗申请单",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });*/ 
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
    var _refresh_ifram = refresh_tab.find('iframe')[0];  
    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}  
