
//����	DHCPEPreSetting.hisui.js
//����	���ǰ̨����
//����	2021.02.20
//������  xy
$(function(){
		
	InitCombobox();
	
	InitPreSettingGrid();
   
    //����
	$("#BSave").click(function() {	
		BSave_click();		
        });
     
    
   
})

function BSave_click()
{
	//����
	var NowLoc=$("#NowLoc").combogrid("getValue");
	if (($("#NowLoc").combogrid('getValue')==undefined)||($("#NowLoc").combogrid('getText')=="")){var NowLoc="";}
	if(NowLoc=="") 
	{
		$.messager.alert("��ʾ","��ѡ����Ҫ���õĿ���!","info");
		return;
	}
	
	if(NowLoc!="")
	{
		if (($("#NowLoc").combogrid('getValue'))==($("#NowLoc").combogrid('getText')))  {
			$.messager.alert("��ʾ","����ѡ����ȷ!","info");
			return false;
		}
		
	}
	
	
	//���޸ķѱ�ȫ��
	var str=$("#FeeTypeSuperGroup").combobox('getValue')
	if (($("#FeeTypeSuperGroup").combobox('getValue')==undefined)||($("#FeeTypeSuperGroup").combobox('getText')=="")){var str="";}
	if(str=="")
	{
			$.messager.alert("��ʾ","�޸ķѱ�ȫ��ѡ����ȷ!","info");
			return false;	
	}
	if(str!="")
	{	
		if (($("#FeeTypeSuperGroup").combobox('getValue'))==($("#FeeTypeSuperGroup").combobox('getText')))  {
			$.messager.alert("��ʾ","�޸ķѱ�ȫ��ѡ����ȷ!","info");
			return false;
		}	
	}
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"FeeTypeSuperGroup",str);

	//��Ҫ�Զ�����
	var AutoArrived=$("#AutoArrived").combobox("getValues");
	var strarray=["N","N","N","N"]
	for(var i=0;i<AutoArrived.length;i++)
	{
		if(AutoArrived[i]=="1")	strarray.splice(0,1,"Y")
		if(AutoArrived[i]=="2")	strarray.splice(1,1,"Y")
		if(AutoArrived[i]=="3")	strarray.splice(2,1,"Y")
		if(AutoArrived[i]=="4")	strarray.splice(3,1,"Y")
	}
	var str=strarray.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AutoArrived",str);
	
	//ԤԼ��ӡѡ��
	var DefPrintType=$("#DefPrintType").combobox("getValues");
	var strarray=["N","N","N","N"]
	for(var i=0;i<DefPrintType.length;i++)
	{
		if(DefPrintType[i]=="1")	strarray.splice(0,1,"Y")
		if(DefPrintType[i]=="2")	strarray.splice(1,1,"Y")
		if(DefPrintType[i]=="3")	strarray.splice(2,1,"Y")
		if(DefPrintType[i]=="4")	strarray.splice(3,1,"Y")
	}
	var str=strarray.join("^");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"DefPrintType",str);
	
	
	//δ���������ӡ
	var str=$("#AllowPrint").switchbox("getValue");
	if(str) str="Y";
	else str="N";  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"AllowPrint",str);
	
	//���쵥��ӡ��ִ����Ŀ
	var str=$("#IsPrintEItem").switchbox("getValue");
	if(str) str="Y";
	else str="N";   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsPrintEItem",str);
	
	//�ձ���Ƿ��ӡȡ����ƾ��
	var str=$("#IsPGetReportPT").switchbox("getValue");
	if(str) str="Y";
	else str="N" ;  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsPGetReportPT",str);
	
	//�ձ���������
	var str=$("#IsAddItem").switchbox("getValue");
	if(str) str="Y";
	else str="N";  
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"IsAddItem",str);
	
	//��콨��
	var str=$("#CardRelate").switchbox("getValue");
	if(str) str="Yes";
	else str="No";  	
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CardRelate",str);
	
	//��콨������
	var str=$("#CardType").combobox("getValue");
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CardType",str); 
	
	//ԤԼʱ��д�����ʾ�
	var str=$("#IfPreSurvey").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"PreSurvey",str);
	
	//�����ɼ��걾
	var str=$("#CollectSpecOne").switchbox("getValue");
	if(str) str="Y"
	else str="N"   
	tkMakeServerCall("web.DHCPE.HISUICommon","SetSettingByLoc",NowLoc,"CollectSpecOne",str);
	


	$.messager.alert("��ʾ","���óɹ�!","success");
	
	$("#PreSettingGrid").datagrid('load',{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindPreSettingNew",
			HospID:session['LOGON.HOSPID']
		});	

		BClear_click();	
}

//����
function BClear_click(){
	
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-combogrid").combogrid("setValue","");
	$(".hisui-switchbox").switchbox("setValue",true);
	
}

function SetPreDataByLoc(loc)
{
	//���޸ķѱ�ȫ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"FeeTypeSuperGroup");
	$("#FeeTypeSuperGroup").combobox("setValue",ret)
	//��Ҫ�Զ�����
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AutoArrived");
	var str=ret.split("^")
	var retarray=new Array();
	for(var i=0;i<str.length;i++)
	{
		if(str[i]=="Y")
		{ 
			retarray.push(i+1);
			var checkid="AutoArrived"+(i+1)
			$("#"+checkid).attr("checked",true);
		}
	}
	$("#AutoArrived").combobox("setValues",retarray);
	
	//ԤԼ��ӡѡ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"DefPrintType");
	var str=ret.split("^")
	var retarray=new Array();
	for(var i=0;i<str.length;i++)
	{
		if(str[i]=="Y")
		{ 
			retarray.push(i+1);
			var checkid="DefPrintType"+(i+1)
			$("#"+checkid).attr("checked",true);
		}
	}
	$("#DefPrintType").combobox("setValues",retarray);
	
	//���쵥��ӡ��ִ����Ŀ
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPrintEItem");
	if(ret=="Y")	$("#IsPrintEItem").switchbox("setValue",true);
	else	$("#IsPrintEItem").switchbox("setValue",false)
	
	//δ���������ӡ
		var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"AllowPrint");
	if(ret=="Y")	$("#AllowPrint").switchbox("setValue",true);
	else	$("#AllowPrint").switchbox("setValue",false)
	
	//�ձ���Ƿ��ӡȡ����ƾ��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsPGetReportPT");
	if(ret=="Y") $("#IsPGetReportPT").switchbox("setValue",true);
	else	$("#IsPGetReportPT").switchbox("setValue",false)

	//�ձ���������
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"IsAddItem");
	if(ret=="Y") $("#IsAddItem").switchbox("setValue",true);
	else	$("#IsAddItem").switchbox("setValue",false)
	
	//��콨��
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardRelate");
	if(ret=="Yes")	$("#CardRelate").switchbox("setValue",true);
	else	$("#CardRelate").switchbox("setValue",false);
	
	//��콨������
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CardType");
	$("#CardType").combobox("setValue",ret);
	
	//ԤԼʱ��д�����ʾ�
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"PreSurvey");
	if(ret=="Y")	$("#IfPreSurvey").switchbox("setValue",true);
	else	$("#IfPreSurvey").switchbox("setValue",false);

	//�����ɼ��걾
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",loc,"CollectSpecOne");
	if(ret=="Y") $("#CollectSpecOne").switchbox("setValue",true);
	else	$("#CollectSpecOne").switchbox("setValue",false);

	
}


function InitPreSettingGrid()
{
	$HUI.datagrid("#PreSettingGrid",{
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
		queryParams:{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindPreSettingNew",
			HospID:session['LOGON.HOSPID']

		},
		columns:[[
		{field:'Loc',title:'Loc'},
		{field:'LocDesc',title:'����'},
		{field:'FeeTypeSuperGroup',title:'���޸ķѱ�ȫ��'},
		{field:'AutoArrived',title:'��Ҫ�Զ�����'},
		{field:'DefPrintType',title:'ԤԼ��ӡѡ��'},
		{field:'AllowPrint',title:'δ���������ӡ'},
		{field:'IsPrintEItem',title:'���쵥��ӡ��ִ����Ŀ'},
		{field:'IsAddItem',title:'�ձ���������'},
		{field:'IsPGetReportPT',title:'�ձ���Ƿ��ӡȡ����ƾ��'},
		{field:'CardRelate',title:'��콨��'},
		{field:'CardType',title:'��콨������'},
		{field:'PreSurvey',title:'ԤԼʱ��д�����ʾ�'},
		{field:'CollectSpecOne',title:'�����ɼ��걾'}
		]],
		onSelect: function (rowIndex, rowData) {
			   
			var loc=rowData.Loc;
			var LocDesc=rowData.LocDesc;
			$('#NowLoc').combogrid('grid').datagrid('reload',{'q':LocDesc});
			setValueById("NowLoc",loc)
			SetPreDataByLoc(loc)	
				
					
		}
		
			
	})

}


function InitCombobox()
{
	
	//����
	var NowLocObj = $HUI.combogrid("#NowLoc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		},
		
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}
			
			
			
		]]
	});
	

	//���޸ķѱ�ȫ��
	var FeeTypeSuperGroupObj = $HUI.combobox("#FeeTypeSuperGroup",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.hospId = session['LOGON.HOSPID'];
		}

		});
		
		
	//��Ҫ�Զ�����
	//����ҽ������^��ӡ�����Ƿ��Զ�����^�����������Զ�����^��ӡָ����
	var AutoArrived = $HUI.combobox("#AutoArrived",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		rowStyle:'checkbox',
		data:[
			{id:'1',text:'ҽ������'},
			{id:'2',text:'��ӡ����'},
			{id:'4',text:'��ӡָ��'}
		]	
	});
	
	//ԤԼ��ӡѡ��
		var DefPrintType = $HUI.combobox("#DefPrintType",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		rowStyle:'checkbox',
		data:[
			{id:'1',text:'������Ϣ����'},
			{id:'2',text:'ָ����'},
			{id:'3',text:'��������'},
			{id:'4',text:'�������'}
		]	
		
	});
	
	
	//��콨������
	var CardTypeObj = $HUI.combobox("#CardType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCardType&ResultSetType=array",
		valueField:'id',
		textField:'cardtype'
	});
	
}