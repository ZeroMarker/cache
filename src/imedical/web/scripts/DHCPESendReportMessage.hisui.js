
//����	DHCPESendReportMessage.hisui.js
//����	���������hisui
//����	2019.10.18
//������  xy

$(function(){
		
	InitCombobox();
	
	InitSendReportataGrid();
	    
     //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });  
        

   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				FindSendReportInfo();
				}
	});
	
	//���Ͷ���	
	$("#BSendMessage").click(function() {	
		BSendMessage_click();		
        });  
	
	//
	Info();
	
})

//���Ͷ���	
function BSendMessage_click()
{
	var selectrow = $("#SendReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������

	var ErrRows="",NullTelRows="",ErrTelRows="";
	var Content="";
	var Type="RP"
	var Content=$("#Content").val();

	if(Content==""){
		$.messager.alert("��ʾ","�������ݲ���Ϊ�գ�","info");
		return false;
	}

	if(selectrow.length=="0"){
		$.messager.alert("��ʾ","��ѡ������Ͷ��ŵ���Ա��","info");
		return false;
	}

	for(var i=0;i<selectrow.length;i++)
	{
		var ID=selectrow[i].TID;
		var RegNo=selectrow[i].TRegNo;
		var TTel=$.trim(selectrow[i].TTel);
		 
		
		if (TTel==""){
				NullTelRows=NullTelRows+",��"+(i+1)+"��";
				continue;
			}
		if (!isMoveTel(TTel)){
				ErrTelRows=ErrTelRows+",��"+(i+1)+"��"; 
				continue;
			}
			
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+Content;
			//alert(InfoStr)
			var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
			
			if (ret!=0){
				ErrRows=ErrRows+",��"+(i+1)+"��";
			}else{
				 
				/*var obj=document.getElementById("TSendMessagez"+i);
				if (obj) obj.checked=false;
				var obj=document.getElementById("THadSendMessagez"+i);
				if (obj) obj.innerText="������";
				*/
			}
		}
	
	if ((ErrRows!="")||(NullTelRows!="")||(ErrTelRows!="")){
		if (ErrRows!=""){$.messager.alert("��ʾ","������: "+ErrRows,"info");}
		if (NullTelRows!=""){$.messager.alert("��ʾ","�绰����Ϊ�յ���: "+NullTelRows,"info");}
		if (ErrTelRows!=""){$.messager.alert("��ʾ","�绰����������: "+ErrTelRows,"info");}

	}else{
		BFind_click();
	}
	
}


///�ж��ƶ��绰
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^1(3|4|5|8)\d{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}

function FindSendReportInfo()
{
		var iRegNo=$("#RegNo").val(); 
		if(iRegNo!="") {
	 		var iRegNo=$.m({
				"ClassName":"web.DHCPE.DHCPECommon",
				"MethodName":"RegNoMask",
            	"RegNo":iRegNo
			}, false);
		
			$("#RegNo").val(iRegNo)
		}else{
			 $.messager.alert("��ʾ","������ǼǺ�","info");
			return false;
		}	
		
		var iRegNo=$("#RegNo").val();
		
		var PADMS=tkMakeServerCall("web.DHCPE.FetchReport","GetSRPIADMSByRegNo",iRegNo);
	
		
		if (PADMS.split("^")[0]!="0"){
		
			 $.messager.popover({msg: PADMS.split("^")[1], type: "info"});
			return false;
		}else{
			
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
			$.messager.popover({msg: "û��Ҫ��ɱ���ļ�¼", type: "info"});
			return false;
			}
		var PADMArr=PADM.split("$");
		if (PADMArr.length>2){
           
           openWin(PADM)
		}else{
			
			var ret=tkMakeServerCall("web.DHCPE.FetchReport","FetchReportHisui",PADM.split("$")[0],"C");
			var Arr=ret.split("^");
			if (Arr[0]!=0){
				$.messager.popover({msg: Arr[1], type: "info"});
				return false;
			}
			BFind_click();
			}
		}
	
}


//�����¼����
var openWin = function(PIADMs){
	
	$("#myWin").show();
	
	$HUI.window("#myWin",{
		title:"�����¼",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:1000,
		height:390
	});
	
	
	
	var PIADMSQueryTabObj = $HUI.datagrid("#PIADMSQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [], //������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		queryParams:{
			ClassName:"web.DHCPE.PreIADMEx",
			QueryName:"SearchPreIADM",
			
			PIADMs:PIADMs,	
		},
		frozenColumns:[[
			{field:'PIBIPAPMINo',width:100,title:'�ǼǺ�'},
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
		    {field:'PIADMPIBIDR',title:'PIADMPIBIDR',hidden: true}, 
			{field:'PIADMPIBIDRName',width:100,title:'����'},
			{field:'PIADMPGADMDRName',width:300,title:'��������'},
			{field:'PIADMPGTeamDRName',width:150,title:'��������'},
			{field:'PIADMPEDateBegin',width:100,title:'�������'},
			{field:'PIADMOldHPNo',width:120,title:'����'},
			{field:'BSendReport',title:'��ɱ���',width:80,align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.id!=""){
						return "<span style='cursor:pointer;' class='icon-ok' title='��ɱ���' onclick='SendReport("+rowData.id+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"  title="��ɱ���" border="0" onclick="SendReport('+rowData.id+')"></a>';
					
					}
				}},	
		]],
		onSelect: function (rowIndex, rowData) {
			
				
			
		}
		
			
	})
	
	
	
}

//��ɱ���
function SendReport(PIADM)
{
	var ret=tkMakeServerCall("web.DHCPE.FetchReport","FetchReportHisui",PIADM,"C");
			var Arr=ret.split("^");
			if (Arr[0]!=0){
				 $.messager.alert("��ʾ",Arr[1],"info");
			    return false;
			
			}
			BFind_click();
	
}


function Info()
{
	var IFOLD="";
	var IFOLD=$("#IFOLD").checkbox('getValue');
	if(IFOLD){var IFOLD="Y";}
	else{var IFOLD="";}
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	
	var LocID=session['LOGON.CTLOCID'];
	var MessContent=tkMakeServerCall("web.DHCPE.FetchReport","GetContent",IFOLD,VIPLevel,LocID);

	$("#Content").val(MessContent);
}


//�������
function CancelSendReport(ID)
{
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ�����������","info");
		return false;
		}
		
	$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"CancelFetchReport",ID:ID,CurStatus:"C"},function(ReturnValue){
				
				var ret=ReturnValue.split("^");
				if (ret[0]!="0") {
					$.messager.alert("��ʾ",ret[1]+",�����������","info");
				}else{
					$.messager.alert("��ʾ","�����ɹ�","success");
					BFind_click();
				}
				});
		}
	});
	
	
}
//��ѯ
function BFind_click(){
	
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#SendReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchCmopleteReport",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			NoFetchReport:$HUI.checkbox('#NoFetchReport').getValue() ? "on" : "",
			HadSendMessage:$HUI.checkbox('#HadSendMessage').getValue() ? "on" : "",
			IFOLD:$HUI.checkbox('#IFOLD').getValue() ? "on" : "",
			})
	
}


function InitSendReportataGrid()
{
	$HUI.datagrid("#SendReportQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchCmopleteReport",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			NoFetchReport:$HUI.checkbox('#NoFetchReport').getValue() ? "on" : "",
			HadSendMessage:$HUI.checkbox('#HadSendMessage').getValue() ? "on" : "",
			IFOLD:$HUI.checkbox('#IFOLD').getValue() ? "on" : "",
		},
		frozenColumns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'BCancelSendReport',title:'����',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if((rowData.TID!="")&&(rowData.TSendUser!="")){
						return "<span style='cursor:pointer;' class='icon-cancel' title='����' onclick='CancelSendReport("+rowData.TID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="����" border="0" onclick="CancelSendReport('+rowData.TID+')"></a>';
					
					}
				}},
			{field:'TRegNo',width:100,title:'�ǼǺ�'},
			{field:'TName',width:80,title:'����'},
		]],
		columns:[[
	
		    {field:'TID',title:'ReportID',hidden: true},
			{field:'TSex',width:45,title:'�Ա�'},
			{field:'TBirth',width:100,title:'��������'},
			{field:'TSendUser',width:80,title:'�����'},
			{field:'TSendDate',width:100,title:'�������'},
			{field:'TReportStatus',width:100,title:'����״̬'},
			{field:'TAppDate',width:100,title:'����Լ��'},
			{field:'TTel',width:120,title:'�绰'},
			{field:'THadSendMessage',width:80,title:'����״̬'},
			{field:'TMessageDate',width:100,title:'����ʱ��'},
			{field:'RptPrtDate',width:100,title:'��ӡ����'},
			{field:'TVIPLevel',width:80,title:'VIP�ȼ�'},
			{field:'TGroupName',width:200,title:'��������'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}

function InitCombobox()
{
	  // VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	})
	
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function()
		{
			
			
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100},
		
		]]
		})
		
		
	
}
