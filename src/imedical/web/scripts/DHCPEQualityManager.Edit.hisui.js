/*
 * FileName: DHCPEQualityManager.Edit.hisui.js
 * Author: xy
 * Date: 2021-12-03
 * Description: �����ϱ�-hisui
 */
 
 var init = function(){
	 
	InitCombobox();
	
	InitQualityManagerGrid();  
    
	 
	 //����
	$("#BSave").click(function() {	
		BSave_click();		
      });
      
     //ɾ�� 
    $("#BDelete").click(function() {		
		BDelete_click();			
     });
	
	//������Ϣ
     $("#ErrDetail").keydown(function(e) {
			if(e.keyCode==13){
				ErrDetail_dblclick();
			}
			
        });
	
	
	//��������
	$("#QMType").combobox({
       onSelect:function(){
			QMType_change();
	}
	});
	
	//��Ŀ
	$("#ItemID").combobox({
       onSelect:function(){
			ItemID_change();
	}
	});

	
 }
 
 


function QMType_change()
{
	
	var QMType=$("#QMType").combobox("getValue");
	
    var ExpStr=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetQMTypeCode",QMType);
    
	var Ret=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetGenName",PAADM,ExpStr);
	var Arr=Ret.split("^");

	$("#ErrUser").combogrid("setValue",Arr[1]);
	
	$("#ErrDetail").val("");
	
	$("#ItemID").combobox("setValue","");
	
	if((ExpStr=="SR")||(ExpStr=="SA"))
	{
		$("#ItemID").combobox("enable");
		
	}else{
		$("#ItemID").combobox("disable"); 
	
	}
		
}

function ItemID_change()
{	
	
	var QMType=$("#QMType").combobox("getValue");
	
	var ExpStr=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetQMTypeCode",QMType);
	
	if ((ExpStr=="")||(ExpStr=="undefined")){
		$.messager.alert("��ʾ","����ѡ���������","info");
		return false;
	}
	if ((ExpStr=="SR")||(ExpStr=="SA")){
		var ItemID=$("#ItemID").combobox("getValue");
		if (ItemID==""){
			$.messager.alert("��ʾ","��ѡ�������Ŀ","info");
			return false;
		}
	
	var UserInfo=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetUserInfo",ItemID,ExpStr);
	var Arr=UserInfo.split("^");
	
	$("#ErrUser").combogrid('grid').datagrid('reload',{'q':Arr[1]});
	$("#ErrUser").combogrid("setValue",Arr[0]);


	}
}

 //����
 function BSave_click() { 

    var QMType=$("#QMType").combobox("getValue");
   
	
    if (QMType==""){
		$.messager.alert("��ʾ","����ѡ���������!","info");
		return false;
	}
    var ExpStr=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetQMTypeCode",QMType);
    
	var ErrDetail=$.trim($("#ErrDetail").val());
	
	var ErrUserID=$("#ErrUser").combogrid("getValue");
	if (ErrUserID==""){
		$.messager.alert("��ʾ","�����˲���Ϊ��!","info");
		return false;
	}
	
	var ID=$("#ID").val();

	var UserID=session['LOGON.USERID']
	
	var ItemID=$("#ItemID").combobox("getValue");
	if (ExpStr=="SR"){
		var ItemID=$("#ItemID").combobox("getValue");
		if(ItemID=="") {
			$.messager.alert("��ʾ","��������Ϊ����¼��ʱ,����ѡ����Ŀ","info"); 
	       return false;
        }
	}
	
	var Remark="";
	var SaveInfo=PAADM+"^"+QMType+"^"+ErrDetail+"^"+Remark+"^"+ErrUserID+"^"+UserID+"^"+ItemID;
	var Ret=tkMakeServerCall("web.DHCPE.QualityManager","Save",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		$.messager.alert("��ʾ","����ɹ�","success");
		
		$("#QualityManagerGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchAllErrByPAADM",
			PAADM:PAADM	
		});	

		Clear_click();

	}else{
		$.messager.alert("��ʾ",Arr[1],"error"); 
		
	} 
}


function Clear_click() {
	
	$("#ID,#ErrDetail").val("");
	$("#ItemID").combobox("setValue","");
	$("#QMType").combobox("setValue","");
	$("#ErrUser").combogrid("setValue","");	
}

//ɾ��
function BDelete_click()
{
	var encmeth="",ID="",UserID="";
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert("��ʾ","����ѡ��Ҫɾ���ļ�¼","info");
		return false;
	}
	
	var UserID=session['LOGON.USERID']
    var Ret=tkMakeServerCall("web.DHCPE.CT.QualityManager","Delete",ID,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		$.messager.alert("��ʾ","ɾ���ɹ�","success"); 
		
		$("#QualityManagerGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchAllErrByPAADM",
			PAADM:PAADM	
		});	
		
		Clear_click();
	
	}else{
		$.messager.alert("��ʾ",Arr[1],"info");
	} 
}

 function InitCombobox(){
	 
	//��������	
	var QMTypeObj = $HUI.combobox("#QMType",{
		url:$URL+"?ClassName=web.DHCPE.CT.QualityManager&QueryName=SearchQMType&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'ID',
		textField:'Desc'
		});
		
	//������
	var ErrUserObj = $HUI.combogrid("#ErrUser",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSER",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'SSUSR_RowId',
		textField:'SSUSR_Name',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'SSUSR_RowId',title:'ID',width:40},
			{field:'SSUSR_Name',title:'����',width:200},
			{field:'SSUSR_Initials',title:'����',width:150}	
				
		]],
		onLoadSuccess:function(){
			
		}

		});	
		 
	//��Ŀ
	var ItemIDObj = $HUI.combobox("#ItemID",{
		url:$URL+"?ClassName=web.DHCPE.CT.QualityManager&QueryName=FindItemByPAADM&ResultSetType=array&UserID="+session['LOGON.USERID']+"&PAADM="+PAADM,
		valueField:'ItemID',
		textField:'ARCIMDesc'
		});
 }
 
 function InitQualityManagerGrid(){
	 
	 $HUI.datagrid("#QualityManagerGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false, //����Ϊ true����������ƻ�������ż��ʹ�ò�ͬ����ɫ��
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 50,
		pageList : [50,100,150],
		queryParams:{
			ClassName:"web.DHCPE.CT.QualityManager",
			QueryName:"SearchAllErrByPAADM",
			PAADM:PAADM
			
		},
		columns:[[

			{field:'TID',title:'ID',hidden: true},
			{field:'TQMTypeID',title:'QMTypeID',hidden: true},
			{field:'TQMType',width:100,title:'��������'},
			{field:'TErrDetail',width:150,title:'������Ϣ'},
			{field:'TARCIMDesc',width:100,title:'��Ŀ'},
			{field:'TSatus',width:80,title:'״̬'},
			{field:'TErrUserID',title:'ErrUserID',hidden: true},
			{field:'TErrUser',width:100,title:'������'},
			{field:'TCreateUser',width:100,title:'���ִ�����'},
			{field:'TCreateDate',width:100,title:'��������'},
			{field:'TUpdateUser',width:100,title:'������'},
			{field:'TUpdateDate',width:100,title:'��������'},
			{field:'TItemID',title:'ItemID',hidden: true}
				
	 
	 	]],
	 	onSelect: function (rowIndex, rowData) {
		 	
		 	$("#ID").val(rowData.TID);
		 	
		 	$("#ErrUser").combogrid('grid').datagrid('reload',{'q':rowData.TErrUser});
		 	
		 	$("#ErrUser").combogrid("setValue",rowData.TErrUserID);
		 	
		 	$("#ItemID").combobox("setValue",rowData.TItemID);
		 	
		 	$("#ErrDetail").val(rowData.TErrDetail);
		 	
		 	$("#QMType").combobox("setValue",rowData.TQMTypeID);

		},
		onDblClickRow:function (rowIndex, rowData) {
			 
			var ExpStr=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetQMTypeCode",rowData.TQMTypeID);
			if((ExpStr=="SA")||(ExpStr=="SR")||(ExpStr=="GA")||(ExpStr=="GR")){
				ErrDetail_dblclick();
			}
			
		}
	 })
 }
 
 
 
function ErrDetail_dblclick()
{
	var ItemID=$("#ItemID").combobox("getValue");
	var QMType=$("#QMType").combobox("getValue");	 
	var ExpStr=tkMakeServerCall("web.DHCPE.CT.QualityManager","GetQMTypeCode",QMType);	 	
	//alert( ExpStr)
 	$("#FindErrDetailWin").show();
 	var LocListWin = $HUI.dialog("#FindErrDetailWin", {
        width: 550,
        modal: true,
        height: 400,
        iconCls: '',
        title: '������������',
        resizable: true,
        onOpen: function() {

            var gridObj = $HUI.datagrid("#FindErrDetailGrid", {
                url: $URL,
                fit: true,
                border: false,
                pagination: false,
                showPageList: false,
                showRefresh: false,
                singleSelect: false,

                queryParams: {
                    ClassName: "web.DHCPE.CT.QualityManager",
                    QueryName: "FindErrDetail",
                    PAADM: PAADM,
                    ExpStr: ExpStr,
                    ItemID:ItemID
                    
                },
                columns: [[
					{ field: 'STDesc', title: 'վ��', width: 100 },
					{ field: 'ErrDetail', title: '������Ϣ', width: 320},
					{ field: 'UserID', hidden: true},
					{ field: 'UserName', title: '������', width: 90 }
                ]],
                onDblClickRow:function (rowIndex, rowData) {
			 		
		 			$("#ErrDetail").val(rowData.ErrDetail);
					if ((ExpStr!="GA")&&(ExpStr!="GR")){
						//$("#ErrUser").combogrid('grid').datagrid('reload',{'q':rowData.UserName});
		 				$("#ErrUser").combogrid("setValue",rowData.UserID);
					}
			
			},
                onLoadSuccess: function(rowData) {

                }
            });


        }


    });

}
 $(init);