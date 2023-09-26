if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
     document.getElementsByTagName('head')[0].appendChild(script);
}
var CureExecDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();
	CureExecDataGridLoad();
})

function Init(){
	InitCureExecDataGrid();	
}

function InitEvent(){
	$HUI.checkbox("#OnlyNoExcute",{
		onChecked:function(e,val){
			setTimeout("CureExecDataGridLoad();",10)
		},
		onUnchecked:function(e,val){
			setTimeout("CureExecDataGridLoad();",10)
		},
	})	
}

function InitCureExecDataGrid()
{
	CureExecDataGrid=$('#tabCureExecList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		//url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEORERowID",
		pageSize:10,
		pageList : [10,25,50],
		columns :[[ 
					{field:'RowCheck',checkbox:true},
					{field:'ApplyDate',title:'��������',width:130,align:'left'},  
        			{field:'DCARowId',title:'',width:1,hidden:true}, 
        			{field:'DCRRowId',title:'',width:1,hidden:true},
        			{field:'PapmiNo',title:'�ǼǺ�',width:100},   
        			{field:'PatientName',title:'����',width:80},
        			{field:'ArcimDesc',title:'������Ŀ',width:280,align:'left'},  
        			{field:'OEOREExStDate',title:'Ҫ��ִ��ʱ��',width:130,align:'left'},
        			{field:'OEOREQty',title:'ִ������',width:80,align:'left'} ,
        			{field:'OEOREStatus',title:'ִ��״̬',width:100,align:'left'},
        			{field:'OEOREUpUser',title:'ִ����',width:100,align:'left'},
        			{field:'OEOREExDate',title:'����ʱ��',width:130,align:'left'} ,
        			{field:'OEOREType',title:'ҽ������',width:100,align:'left'} ,
        			{field:'ApplyStatus',title:'����״̬',width:100,align:'left'} ,
        			{field:'ApplyStatusCode',title:'ApplyStatusCode',width:100,align:'left',hidden:true} ,
        			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}    
    			 ]] ,
    	//toolbar : cureExecToolBar,
	});
}
function CureExecDataGridLoad()
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var CheckOnlyNoExcute="";
	var OnlyNoExcute=$("#OnlyNoExcute").prop("checked");
	if (OnlyNoExcute){CheckOnlyNoExcute="ON"};
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		QueryName:"FindCureExecList",
		'DCARowId':DCARowIdStr,
		'OnlyNoExcute':CheckOnlyNoExcute,
		Pagerows:CureExecDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureExecDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	CureExecDataGrid.datagrid("clearChecked");
	CureExecDataGrid.datagrid("clearSelections");
}


function UpdateExec(Type){
	var rows = CureExecDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ����¼");
		return;
	}
	if(Type=="C"){
		var msg="�Ƿ�ȷ�ϳ���ִ��";
	}else if(Type=="S"){
		var msg="�Ƿ�ȷ��ִֹͣ��"	;
	}else{
		//var msg="�Ƿ�ȷ��ִ��"	;
		OpenCureRecordDiag();
		return ;
	}
	$.messager.confirm('ȷ��',msg,function(r){    
	    if (r){
		    var UserID=session['LOGON.USERID'];
			var DCARowId="";
			var DCARowIdStr="";
			var IncludeNotInpFlag=0;
			var ErrFlag=0;
			var QuitArray=new Array();
			var AllowArray=new Array();
			for(var i=0;i<rows.length;i++){
				var PatientName=rows[i].PatientName;
				var ArcimDesc=rows[i].ArcimDesc;
				var DCARowIds=rows[i].DCARowId;
				var OEOREQty=rows[i].OEOREQty;
				var OEORERowID=rows[i].OEORERowID;
				var OEOREType=rows[i].OEOREType;
				if(Type=="S"){
					if(OEOREType.indexOf("סԺ")<0){
						IncludeNotInpFlag=1;
						continue;	
					}
				}
				if(QuitArray[DCARowIds]){
					continue;	
				}
				var RtnStr=$.cm({
					ClassName:"DHCDoc.DHCDocCure.ExecApply",
					MethodName:"CheckBeforeUpdateExec",
					dataType:"text",
					DCARowId:DCARowIds,
					UserID:session['LOGON.USERID'],
				},false);
				if(RtnStr!=""){
					QuitArray[DCARowIds]=DCARowIds;
					$.messager.alert('��ʾ',PatientName+","+ArcimDesc+","+RtnStr);
					continue;
				}else{
					AllowArray.push(DCARowIds+"^"+OEOREQty+"^"+OEORERowID);
				}
			}
			for(var i=0;i<AllowArray.length;i++){
				var AllowArr=AllowArray[i].split("^");
				var DCARowIds=AllowArr[0];
				var OEOREQty=AllowArr[1];
				var OEORERowID=AllowArr[2];
				var RtnStr=$.cm({
					ClassName:"DHCDoc.DHCDocCure.ExecApply",
					MethodName:"FinishCureApply",
					dataType:"text",
					DCARowId:DCARowIds,
					UserID:session['LOGON.USERID'],
					EexcNum:OEOREQty,
					Type:Type,
					Resource:"",
					OEOREDRStr:OEORERowID,
					LocDeptDr:session['LOGON.CTLOCID']
				},false);
		        //var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.ExecApply","FinishCureApply",DCARowIds,session['LOGON.USERID'],OEOREQty,Type,"",OEORERowID)
				if(RtnStr=="0"){
					//$.messager.show({title:"��ʾ",msg:"���³ɹ�"});	
					//CureExecDataGridLoad();
				}else{
					if(RtnStr.indexOf("����ִ�м�¼����")>0){
						var msgcode=RtnStr.split(" ")[0];
						/*
						/// -303:ִ�м�¼״̬û�б仯, ���øı�
						/// -304:ִ�м�¼�Ѿ�ִ��,����ֹͣ
						/// -302:ִ�м�¼�Ѿ�ֹͣ,������ִ��
						/// -305:ִ�м�¼û��ִ��,����Ҫ����
						/// -306:ִ�м�¼����ʧ��
						/// -307:ִ�м�¼�仯����ʧ��
						/// -308:ִ�м�¼�Ʒѱ仯����ʧ��
						/// -310:ִ�м�¼��չ����ʧ��
						/// -301:ֹͣҽ��ִ�м�¼ʧ��
						/// -310:�Ʒ�״̬��ͬ,���øı�
						/// -311:�Ѿ��˷�,����Ҫ�����
						/// -313:�Ѿ����Ʒ�,����Ҫȡ�����
						/// -314:��ʱҽ��δֹͣ���߳���,����ִֹͣ��
						/// -315:�޸�ִ�м�¼ҽ��״̬ʧ��
						/// -316:�����ϻ�������ʱҽ����ִ�м�¼,������ִ��
						/// -317:����ҽ��ֹͣʱ����ִ�м�¼��������ִ��
						/// -318:�Ѿ���ҩ������ִֹͣ��(�����ż���)
						*/
						var msgdesc=msgcode;
						if(msgcode=="-303")msgdesc="ִ�м�¼״̬û�б仯,�����ٴβ���";
						else if(msgcode=="-302")msgdesc="ִ�м�¼�Ѿ�ֹͣ,������ִ��"
						else if(msgcode=="-304")msgdesc="ֻ��δִ�л��߳���ִ�еļ�¼����ִֹͣ��."
						else if(msgcode=="-305")msgdesc="ִ�м�¼û��ִ��,����Ҫ����"
						else if(msgcode=="-310")msgdesc="ִ�м�¼��չ����ʧ��"
						else if(msgcode=="-316")msgdesc="�����ϻ�������ʱҽ����ִ�м�¼,������ִ��"
						else if(msgcode=="-314")msgdesc="��ʱҽ��δֹͣ���߳���,����ִֹͣ��"
						RtnStr="����ִ�м�¼����,"+msgdesc;
					}
					ErrFlag=1;
					var msg=PatientName+","+ArcimDesc+",����ʧ��:"+RtnStr
					$.messager.alert('��ʾ',msg);
				}
			}
			$.messager.show({title:"��ʾ",msg:"�������"});	
			if(IncludeNotInpFlag==1){
				$.messager.alert("��ʾ","��סԺ��ʱҽ������ִֹͣ��,���Զ�����.");		
			}	
			CureExecDataGridLoad();
	    }    
	});  
}
function OpenCureRecordDiag()
{
	var rows = CureExecDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length>1){
		$.messager.alert("��ʾ","ֻ��Ϊһ��ִ�м�¼����ִ��,�������ִ��,��ѡ������ִ�м�¼����.", 'error');	
		return false;	
	}
	var selected = CureExecDataGrid.datagrid('getSelected');
	var PatientName=selected.PatientName;
	var ArcimDesc=selected.ArcimDesc;
	var DCARowIds=selected.DCARowId;
	var OEOREQty=selected.OEOREQty;
	var OEORERowID=selected.OEORERowID;
	var OEOREType=selected.OEOREType;
	var ApplyStatusCode=selected.ApplyStatusCode;
	var DCRRowId=selected.DCRRowId;
	if(ApplyStatusCode=="C"){
		$.messager.alert("��ʾ","�������ѳ���,�޷�ִ��.", 'error');	
		return false;
	}
	if ((DCRRowId!="")&&(DCRRowId!=undefined)){
		$.messager.alert("��ʾ","��ִ�м�¼��ִ��,������������Ƽ�¼,�����޸�,��ʹ�����ִ�н����޸�.", 'error');	
		return false;
	}
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+OEORERowID+"&source="+"exec";
	websys_showModal({
		url:href,
		title:'������Ƽ�¼', 
		width:760,height:500,
		CallBackFunc:function(ReturnValue){
			websys_showModal("close");
			if (ReturnValue != "" && typeof(ReturnValue) != "undefined") {
				if(ReturnValue){CureExecDataGridLoad();}
			}
		}
	})
}
// ����ִ��
function GenAddCureRecord(){
	var rows = CureExecDataGrid.datagrid("getSelections");
	var length=rows.length;
	var finflag=0;
	var selRowid="";
	for(var i=0;i<length;i++){
		var MyrowIndex = CureExecDataGrid.datagrid("getRowIndex", rows[i]);
		
		var Rowid=rows[i].OEORERowID;
		var DCRRowId=rows[i].DCRRowId;
		var OEOREExStDate=rows[i].OEOREExStDate;
		if ((DCRRowId!="")&&(DCRRowId!=undefined)){
			$.messager.alert("��ʾ",OEOREExStDate+"��ִ�м�¼��ִ��,����������ִ��", 'error');	
			return false;
		}
		var ApplyStatusCode=rows[i].ApplyStatusCode;
		if(ApplyStatusCode=="C"){
			$.messager.alert("��ʾ",OEOREExStDate+"�������ѳ���,�޷�ִ��.", 'error');	
			return false;
		}
		
		// var OEORERowID=rows[i].OEORERowID;
		if(selRowid==""){
			selRowid=Rowid;
		}else{
			selRowid=selRowid+"^"+Rowid;	
		}
				 
	}
	
	if(selRowid!=""){
		$.messager.confirm('ȷ��','����ִ�н�����ϵͳĬ��ȡֵ�������Ƽ�¼����,�Ƿ�ȷ�ϼ�������ִ��?',function(r){    
		    if (r){    
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Record",
					MethodName:"SaveCureRecordBatch",
					"DCRRowIdStr":selRowid,
					"UserDR":session['LOGON.USERID'],
					"LocDeptDr":session['LOGON.CTLOCID'],
					"Source":"E",
				},function testget(value){
					if(value==""){
	   					$.messager.show({title:"��ʾ",msg:"�����ɹ�"});	
	   					CureExecDataGridLoad();
					}else{
						$.messager.alert('��ʾ',"����ʧ��:"+value);
					}
				})
		    }    
		});  
		
	}else{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");		
	}
}
/// ���ִ��
function DetailExecView(){
	var rows = CureExecDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ��ִ�м�¼�鿴");
		return;
	}else if (rows.length>1){
 		$.messager.alert("����","��ѡ���˶��ִ�м�¼��",'err')
 		return;
	}
	var DCRRowId=""
	var rowIndex = CureExecDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureExecDataGrid.datagrid('getRows'); 
	var DCRRowId=selected[rowIndex].DCRRowId;
	//var DCRRowId=myselected[MyrowIndex].DCRRowId;
	if(DCRRowId=="")
	{
		$.messager.alert('Warning','��ִ�м�¼δִ��,����ִ�к������');
		return false;
	}
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+"&source="+"exec";
	websys_showModal({
		url:href,
		title:'�޸����Ƽ�¼', 
		width:760,height:500,
		CallBackFunc:function(ReturnValue){
			websys_showModal("close");
			if (ReturnValue != "" && typeof(ReturnValue) != "undefined") {
				$.messager.show({title:"��ʾ",msg:"�޸����Ƽ�¼�ɹ�!"});
			}
		}
	})	
}
/*
function CreateWindow(param1) {
	//Ĭ�Ͽ��
	var winWidth=250;
	var winHeight=150;
	var ExecType=$("#ExecType").val();
	//alert(ExecType)
	var myTitle="��дִ�д���";
	if(ExecType="C"){
		myTitle="��д����ִ�д���"
	}
	$("#"+param1+"").dialog({
		width:winWidth,    
		height:winHeight,
		title:myTitle,
		closed:false,
		closable:false,
		cache: false,
		modal:true,
		inline:true,
		buttons:[{
			text:'����',
			iconCls:'icon-save',
			handler:function(){
				var returnstr="";				
				var Exec=$("#Exec").val();
				if(Exec==""){
					//$.messager.alert("��ʾ��Ϣ","����д����");
					//return false;	
				}
				var returnstr=Exec;
				window.returnValue=returnstr;
				window.close();
			}
		},{
			text:'ȡ��',
			iconCls:'icon-cancel',
			handler:function(){
				window.returnValue=null;
				window.close();
			}
		}]
	});
}

function SetDefaultDate(){
    var Defaultnumber=$("#DefaultNum").val();
   	$("#Exec").numberbox("setValue",Defaultnumber);  
} 
*/	