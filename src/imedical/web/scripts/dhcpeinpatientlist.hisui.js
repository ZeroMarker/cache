
/*
 * FileName:    dhcpeinpatientlist.hisui.js
 * Author:      xueying
 * Date:        20220914
 * Description: סԺ��������б�
 */
 
 $(function(){
	
	//��ʼ���б�
	InitIPatientListGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
   
   	//ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
           
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
     //����סԺ����Ϊ��첡�� 
    SetOtherPatientToHP();
         
})

//����סԺ����Ϊ��첡�� 
function SetOtherPatientToHP(){
    
    var UserID=session['LOGON.USERID'];
   
	if (OtherPAADM!=""){
		var flag=tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",OtherPAADM);
		if(flag=="1"){
			return false;
		}
		var Info=tkMakeServerCall("web.DHCPE.DocPatientFind","GetInfoByPAADM",OtherPAADM);
		var Char_1=String.fromCharCode(1);
		var BaseInfoArr=Info.split(Char_1);
		//alert(BaseInfoArr)
		if (BaseInfoArr[0]!=""){
			var Arr=BaseInfoArr[0].split("^");	
			$.messager.confirm("ȷ��",$g("ȷ��Ҫ��")+Arr[1]+$g("����Ϊ�����Ա��?"), function(r){
				if (r){
					$.m({ ClassName:"web.DHCPE.OtherPatientToHP", MethodName:"Save",PAADM:OtherPAADM,UserID:UserID},function(ReturnValue){
						if (ReturnValue.split("^")[0]=='-1') {
							$.messager.alert("��ʾ",ReturnValue,"info"); 
							return false; 
						}else if (ReturnValue.split("^")[0]=='0') {
							BFind_click(); 
						}
					});	
				}
			});
		}
	}
}
function InitIPatientListGrid(){
	
	
	$HUI.datagrid("#IPatientListGrid",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindPatientList",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			EpisodeID:"",
			ShowDelete:"",
			hospid:session['LOGON.HOSPID'],
		    locid:session['LOGON.CTLOCID']
						
		},
		columns:[[       
		    {field:'TEpisodeID',title:'PAADM',hidden: true},
			{field:'TRegNo',width:140,title:'�ǼǺ�'},
			{field:'TName',width:200,title:'����'},	
			{field:'TSex',width:100,title:'�Ա�'},
			{field:'TAge',width:100,title:'����'},
			{field:'TIDCard',width:260,title:'֤����'},
			{field:'TIDCardDesc',width:180,title:'֤������'},
			{field:'TInDate',width:130,title:'��Ժ����'},
			{field:'THPDate',width:130,title:'�������'},
			{field:'THStatusDesc',width:120,title:'���״̬'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$("#PAADM").val(rowData.TEpisodeID);
			
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


//ɾ��
function BDelete_click(){
	
   var UserID=session['LOGON.USERID'];
   var PAADM=$("#PAADM").val();
   if (PAADM=="")
	{
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼!","info");	
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.OtherPatientToHP", MethodName:"Delete",PAADM:PAADM,UserID:UserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ�ܣ�","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#IPatientListGrid").datagrid('reload');
					$("#PAADM").val("");
				}
			});	
		}
	});
   
   
}
	
//��ѯ
function BFind_click() {
	
	var LocID=session['LOGON.CTLOCID'];
	var HospID=session['LOGON.HOSPID'];
	var iStartDate=$("#StartDate").datebox('getValue');
	var iEndDate=$("#EndDate").datebox('getValue');
	
	 $("#IPatientListGrid").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHP",
			QueryName:"FindPatientList",
			StartDate:iStartDate,
			EndDate:iEndDate,
			EpisodeID:"",
			ShowDelete:"",
			hospid:HospID,
		    locid:LocID
			
		})
		
}


//����
function BClear_click(){
	$("#StartDate,#EndDate").datebox('setValue','');
	$("#PAADM").val("");
	BFind_click();
}