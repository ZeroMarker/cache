
//����	DHCPERoomManagerEdit.hisui.js
//����	������ҵ���
//����	2020.10.16
//������  xy

$(function(){
			
	InitCombobox();
	

	$("#RoomPlace").combobox({
		
       onSelect:function(){
			BReload_click();
	}
	});

	$("#BActive").click(function() { 
	
		if($.trim($("#BActive").text())==$g("����")){
			 ActiveRoom(); 
		}if($.trim($("#BActive").text())==$g("����")){
			 UnActiveRoom();
		}
     }); 
  

	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			SetButtonName(vaule);	
			BReload_click();	
			}
			
	});
	
	//ˢ��
	$("#BReload").click(function() {	
		BReload_click();		
        });  
   
   
     $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			RegNo_click();
			}
	});
  
	//���ҵ���
	$("#BRoomAdjust").click(function() {	
		BRoomAdjust_click();		
        });  
   
	//����λ�øı�
	$("#BRoomPlace").click(function() {	
		BRoomPlace_click();		
        }); 
	
	websys_setfocus("RegNo")
	
	SetDefaultRoomPlace();  //Ĭ������λ��
	
	InitRoomManagerGrid(); 
	
    
})


function RegNo_click()
{ 
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
			"CTLocID":CTLocID
		}, false);
		
			$("#RegNo").val(iRegNo)
	} 
	if (iRegNo=="") {
			$.messager.popover({msg: "������ǼǺ�", type: "info"});
		   return false;
	}
	
	//�Ƿ����δ�����¼��ѡ�񵽴����
	var RegisterRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetRegisterRecordNew",iRegNo);
	if (RegisterRecord.split("^")[0]!="0"){
			$.messager.popover({msg: RegisterRecord.split("^")[1], type: "info"});
			return false;
		}
	RegisterRecord=RegisterRecord.split("^")[1];
	//alert(RegisterRecord)
	if (RegisterRecord!="")
	{
			var ArriveRecord="";
			var RecordArr=RegisterRecord.split("^");
			if (RecordArr.length>1){
					OpenRegisterRecord(iRegNo);	
			
			}else{
				
				ArriveRecord=RegisterRecord;
				if(ArriveRecord!=""){
					GetNextRoomInfo(ArriveRecord);
				}
				
			}
			
	}
	else{
			//�Ƿ����δ�����¼��ѡ�񵽴����
			var ArriveRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetArrivedRecord",iRegNo);
			//alert(ArriveRecord+"ArriveRecord")
			//var ArriveRecord="";
			var RecordArr=ArriveRecord.split("^");
			if (RecordArr.length>1){
					OpenArrivedRecord(iRegNo);	
			
			}else{
				
				//alert(ArriveRecord)
				if(ArriveRecord!=""){
					SetNextRoomInfo(ArriveRecord);
				}
				
			}
		
	}
		

}
var OpenArrivedRecord= function(RegNo){
    
    $HUI.window("#ArrivedRecordWin",{
        title:"������Ϣ�б�",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var ArrivedPIADMLisObj = $HUI.datagrid("#ArrivedRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.PreIADMEx",
            QueryName:"FindPIADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID'],
			ArrivedFlag:"Y"
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
        	{field:'PIADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'����'},
            {field:'RegNo',width:120,title:'�ǼǺ�'},
            {field:'HPNo',width:120,title:'�����'},
            {field:'AdmDate',width:100,title:'����'},
            {field:'StatusDesc',width:100,title:'״̬'},
            {field:'GName',width:200,title:'��������'},
            {field:'TeamName',width:120,title:'��������'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	       GetNextRoomInfo(rowData.PIADM)
	           
  				}
        
        })
    
}

var OpenRegisterRecord= function(RegNo){
    
    $HUI.window("#RegisterRecordWin",{
        title:"������Ϣ�б�",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var PIADMLisObj = $HUI.datagrid("#RegisterRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.PreIADMEx",
            QueryName:"FindPIADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID']
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
        	{field:'PIADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'����'},
            {field:'RegNo',width:120,title:'�ǼǺ�'},
            {field:'HPNo',width:120,title:'�����'},
            {field:'AdmDate',width:100,title:'����'},
            {field:'StatusDesc',width:100,title:'״̬'},
            {field:'GName',width:200,title:'��������'},
            {field:'TeamName',width:120,title:'��������'}
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	       GetNextRoomInfo(rowData.PIADM)
	           
  				}
        
        })
    
}

function GetNextRoomInfo(PIADM)
{
	   //�ж��Ƿ�δ���ѡ��Ƿ��������δ�ܼ�ļ�¼
		var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","HadNoGenRecord",PIADM);
		if (ret!=""){
			$.messager.alert("��ʾ",ret,"info"); 
			return false;
		}else{
			var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IAdmArrived",PIADM);
			}
		var ret=tkMakeServerCall("web.DHCPE.RoomManager","InsertRoomByPIADM",PIADM);
		var ret=ret.split("^");
		$("#NextRoomInfo").val(ret[1]);
		BReload_click();
		
}
function SetNextRoomInfo(PIADM)
{
	    
		var ret=tkMakeServerCall("web.DHCPE.RoomManager","InsertRoomByPIADM",PIADM);
		var ret=ret.split("^");
		$("#NextRoomInfo").val(ret[1]);
		BReload_click();
}

//����λ�øı�
function BRoomPlace_click()
{
	//var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEChangeRoomPlace";
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1300,height=640,hisui=true,title=����λ�øı�')
	var lnk="dhcpechangeroomplace.hisui.csp";
	 websys_lu(lnk,false,'width=1270,height=730,hisui=true,title='+$g("����λ�øı�"))

}

//���ҵ���
function BRoomAdjust_click()
{
	//var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEAdmRoomRecord";
	var lnk="dhcpeadmroomrecord.hisui.csp"
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1027,height=630,hisui=true,title='+$g("���ҵ���"))
	
}

function SetButtonName(vaule)
{
	//alert(vaule)
	if(vaule==true)
	{
		$("#BActive").linkbutton({text:$g("����")});
	}else{
		$("#BActive").linkbutton({text:$g("����")});
	}
	
}


function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}

function Active(ActiveFlag)
{
	
	var ID=""
	 var objtbl = $("#RoomManagerGrid").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPERoomManager")
	    if (TSelect=="1"){
		     if(ID=="") {var ID=objtbl[i].TRoomID;}
		     else{var ID=ID+"^"+objtbl[i].TRoomID;}
		     	   
	    } 
	}

	
	if (ID==""){
		$.messager.alert("��ʾ","��ѡ������","info");
		
		return false;
	}
	var encmeth=GetValue("ActiveRoomClass");
   	for (var j=0;j<ID.split("^").length;j++)
	{
		
		var rtn=cspRunServerMethod(encmeth,ID.split("^")[j],ActiveFlag);
		
		var Arr=rtn.split("^");
		if (Arr[0]=="-1"){
			alert(Arr[1]);
		}
	}
	BReload_click();

}

function BReload_click()
{
	var LocID=session['LOGON.CTLOCID'];
	var iRoomPlace=$("#RoomPlace").combobox('getValue');
	if (iRoomPlace==""){
		$.messager.alert("��ʾ","��ѡ������λ��","info")
		return false;
	}
	var iNoActive="Y";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive){iNoActive="N";}
	else{iNoActive="Y";}
	
	$("#RoomManagerGrid").datagrid('load', {
		ClassName: 'web.DHCPE.RoomManager',
		QueryName: 'FindRoomPerson',
		VIPLevel:iRoomPlace,
		NoActive:iNoActive,
		LocID:LocID	
	});
	
}


function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}
function Active(ActiveFlag)
{
	
	var ID=""
	var selectrow = $("#RoomManagerGrid").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		if(ID=="") {var ID=selectrow[i].TRoomID;}
		else{var ID=ID+"^"+selectrow[i].TRoomID;}
	}

	if (ID==""){
		$.messager.alert("��ʾ","��ѡ������","info");	
		return false;
	}
	
   	for (var j=0;j<ID.split("^").length;j++)
	{
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ActiveRoom",ID.split("^")[j],ActiveFlag);
		
		var Arr=rtn.split("^");
		if (Arr[0]=="-1"){
			$.messager.alert("��ʾ",Arr[1],"info");
		}
	}
	BReload_click();
}

function InitRoomManagerGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var iNoActive="Y";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive){iNoActive="N";}
	else{iNoActive="Y";}
	
	$HUI.datagrid("#RoomManagerGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPerson",
			VIPLevel:$("#RoomPlace").combobox("getValue"),
			NoActive:iNoActive,
			LocID:LocID
		},
		frozenColumns:[[
            {title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
            {field:'TRoomName',width:300,title:'����'}]],
		columns:[[
			{field:'TRoomID',title:'TRoomID',hidden: true},
			{field:'TNewPerson',width:230,title:'�Ⱥ�����'},
			{field:'TPassPerson',width:230,title:'��������'},
			{field:'TWaitMiniute',width:230,title:'�ȴ�ʱ��(����)'},
			{field:'TDetail',width:220,title:'����',
				formatter:function(value,rowData,rowIndex){	
					if(rowData.PA_ADMDR!=""){
						return "<a href='#'  class='grid-td-text' onclick=BWaitList("+rowIndex+"\)>"+$g("�Ⱥ�����")+"</a>";
					}else{return value}
					
			}},
			{field:'TActive',width:100,title:'����'},	
			
		]]
			
	});
}

function BWaitList(rowIndex)
{
    
    var objtbl = $("#RoomManagerGrid").datagrid('getRows');
    var RoomID=objtbl[rowIndex].TRoomID;
    var RoomDesc=tkMakeServerCall("web.DHCPE.HISUICommon","GetRoomPlaceByID",RoomID);
	var lnk="dhcperoomrecorddetail.hisui.csp"+"?RoomID="+RoomID
		+"&RoomDesc="+RoomDesc
	   ;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=880,height=660,hisui=true,title='+RoomDesc+'--'+$g("�Ⱥ�����"))
}

function InitCombobox()
{
	//����
	   var NameObj = $HUI.combogrid("#Name",{
        panelWidth:690,
        url:$URL+"?ClassName=web.DHCPE.RoomManagerEx&QueryName=SearchRoomDetail",
        mode:'remote',
        delay:200,
        idField:'Hidden',
        textField:'Name',
        onBeforeLoad:function(param){
            param.Name = param.q;
        },
        columns:[[
            {field:'Hidden',hidden:true},
            {field:'RegNo',title:'�ǼǺ�',width:100},
            {field:'Name',title:'����',width:80},
            {field:'Sex',title:'�Ա�',width:60},
            {field:'Age',title:'����',width:60},
            {field:'IDCard',title:'֤����',width:100},
             {field:'GroupDesc',title:'��λ',width:150},
            {field:'RoomName',title:'��������',width:100},
            {field:'RoomStatus',title:'״̬',width:60}

        ]]
        });
        
       //����λ��
        var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
	        panelWidth:200,
	     	url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=GetRoomPlace&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        	valueField:'id',
        	textField:'desc'
        })
      
           
        
}

function SetDefaultRoomPlace(){
	var LocID=session['LOGON.CTLOCID'];
    var UseID=session['LOGON.USERID'];
    
	var VIPNV="";
    var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP",UseID,LocID)
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"I");
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    $('#RoomPlace').combobox('reload');

}

