/// ����:�¿�����������
///hisui�������
var SelectedRow = 0;
var preRowID=0; 
//�������
$(function(){
	initDocument();
});
function initDocument()
{
	initPanel();
}
function initPanel()
{ 

	initTopPanel();
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	initButton(); //��ť��ʼ�� add by wy 2019-4-25
	showBtnIcon('BFind^BSave',false); //modified by LMH 20230209 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonWidth();
	setRequiredElements("Loc")
	defindTitleStyle();
	initLookUp(); //��ʼ���Ŵ�
	singlelookup("GroupIDOne","PLAT.L.LocGroupType","",GetGroupIDOne)
	singlelookup("GroupIDTwo","PLAT.L.LocGroupType","",GetGroupIDTwo)
	initGroupIDThreeData();
	initDHCEQClocTypeNewData();
	$("#GroupIDOne").lookup({
           onSelect:function(index,rowData){
	       setElement("GroupIDOneDR",rowData.TRowID);
	       setElement("GroupIDOne",rowData.TName);			
	       setElementEnabled();
	       }
	})
	disableElement("BSave",true);	// MZY0025	1318615		2020-05-13
}
//������ѡ���Ϊcombogrid modified by wy 2019-2-16 ����824591
function initGroupIDThreeData()
{
		$("#GroupIDThree").combogrid({
		panelWidth: 450, 
		multiple: true,
		rownumbers: true,
		idField:'TRowID',
		textField:'TName',
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQ.Plat.CTLocType',
			QueryName:'GetLocGroupType',
			Arg1:'3',
			ArgCnt:1
			},
		columns:[[
			{field:'ck',checkbox:true},
			{field:'TRowID',title:'rowid',width:30,align:'center',hidden:true},
			{field:'TName',title:'����',width:70,align:'center',width:50},
			{field:'TCode',title:'����',width:70,align:'center',width:50}
		]],
});
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}
function setSelectValue(vElementID,item)
{
	//modifed by wy 2018-12-28 791163
	var OptionsObj=$("#"+vElementID).lookup("options")
	setElement(vElementID+"DR",item[OptionsObj.idField])
}
function GetGroupIDOne(item)
{
	setElement("GroupIDOne",item.TName);			
	setElement("GroupIDOneDR",item.TRowID); 			
}
function GetGroupIDTwo(item)
{
	setElement("GroupIDTwo",item.TName);			
	setElement("GroupIDTwoDR",item.TRowID);			
}
function GroupIDThree(item)     //add by wy 2019-2-16
{
	setElement("GroupIDThree",item.TName);			
	setElement("GroupIDThreeDR",item.TRowID);			
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function DHCEQClocTypeNew_OnClickRow()
{	
     var selected=$('#tDHCEQClocTypeNew').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.TLocDR;
        if(preRowID!=SelectedRowID)
        {
	         ClearElement();
	    	 setElement("LocDR",SelectedRowID)
	    	 FillData(SelectedRowID);
             preRowID=SelectedRowID;
             disableElement("BSave",false);	// MZY0025	1318615		2020-05-13
         }
         else
         {
             ClearElement();
             disableElement("GroupIDThree",false);
		     disableElement("GroupIDTwo",false);
             $('#tDHCEQClocTypeNew').datagrid('unselectAll');
             SelectedRowID = 0;
             preRowID=0;
             disableElement("BSave",true);	// MZY0025	1318615		2020-05-13
         }
     }
}	
function FillData(RowID)
{
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTLocType',
			MethodName:'GetEQLocDetailByID',
			Arg1:"",
			Arg2:"",
			Arg3:RowID,
			ArgCnt:3
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			var IDs=list[7].split("#");
			var Strs=list[6].split("#");
			setElement("LocDR",list[0]);
			setElement("Loc",list[1]);			//����
			setElement("Hospital",list[2]);		//Ժ��
			setElement("TypeIDTwo",list[3]);	
			setElement("GroupIDTwoDR",list[4]);	//����ְ��
			setElement("GroupIDTwo",list[5]);	//����ְ��
			//setElement("GroupIDThreeDR",list[6]);	//����id3
			$('#GroupIDThree').combogrid('setValues',IDs)
			setElement("TypeIDThree",Strs);
			//setElement("GroupIDThree",str);	//�ⷿ����
			setElement("TypeIDOne",list[9]);
			setElement("GroupIDOneDR",list[10]);	//����id1
			setElementEnabled();    //add by wy 2019-2-16
			setElement("GroupIDOne",list[11]);	//����
			setElement("Remark",list[12]);
			setElement("ManageUserDR",list[13]);
			setElement("ManageUser",list[14]);
			setElement("Location",list[15]);
			setElement("Tel",list[16]);
			setElement("Hold1",list[17]);
			setElement("Hold2",list[18]);
			setElement("Hold3",list[19]);
			setElement("Hold4",list[20]);
			setElement("Hold5",list[21]);
		}
	});
}
function ClearElement()
{
	setElement("LocDR",""); 		//����id
	setElement("Loc","");			//����
	setElement("Hospital","");		//Ժ��
	setElement("TypeIDOne","");		//����id1
	setElement("GroupIDOneDR","");		//����id1
	setElement("GroupIDOne","");	//����id1
	setElement("TypeIDTwo","");		//����id2
	setElement("GroupIDTwoDR","");		//����id2
	setElement("GroupIDTwo","");	//����ְ��
	setElement("TypeIDThree","");	//����id3
	setElement("GroupIDThreeDR","");	//����id3
	setElement("GroupIDThree","");	//����id3
	setElement("Remark","");
	setElement("ManageUserDR","");
	setElement("ManageUser","");
	setElement("Location","");
	setElement("Tel","");
	setElement("Hold1","");
	setElement("Hold2","");
	setElement("Hold3","");
	setElement("Hold4","");
	setElement("Hold5","");
}
function BFind_Clicked()
{
	var groupID=$('#GroupIDThree').combogrid('getValues').toString();   //add by wy 2019-01-11
	$HUI.datagrid("#tDHCEQClocTypeNew",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTLocType",
	        QueryName:"EQLocDetail",
	        QXType:getElementValue("QXType"),
	        AllLocFlag:GetCheckValue("AllLocFlag"),
	        Loc:getElementValue("Loc"),
	        Hospital:getElementValue("Hospital"),
	        GroupIDOne:getElementValue("GroupIDOneDR"),   //modifed by wy 2018-12-14 ����:767587
	        GroupIDTwo:getElementValue("GroupIDTwoDR"),
	        GroupIDThree:groupID,         
	        UnCheckFlag:GetCheckValue("UnCheckFlag")
	    }
	}) 
   
}
function initDHCEQClocTypeNewData()
{
	var groupID=$('#GroupIDThree').combogrid('getValues').toString();  //add by wy 2019-01-11
	$HUI.datagrid("#tDHCEQClocTypeNew",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTLocType",
	        QueryName:"EQLocDetail",
	        QXType:getElementValue("QXType"),
	        AllLocFlag:GetCheckValue("AllLocFlag"),		// Mozy		1057066		2019-10-26
	        Loc:getElementValue("Loc"),
	        Hospital:getElementValue("Hospital"),
	        GroupIDOne:getElementValue("GroupIDOneDR"),  //modifed by wy 2018-12-14
	        GroupIDTwo:getElementValue("GroupIDTwoDR"),
	        GroupIDThree:groupID,
	        UnCheckFlag:GetCheckValue("UnCheckFlag")	// Mozy		1057066		2019-10-26
	    },
	    fie:true,
	    singleSelect:true,
		//fitColumns:true, //modified by LMH 20230210 UI ����Ĭ���������
    	columns:[[
    	{field:'TLocDR',title:'TLocDR',width:50,hidden:'true'},    
        {field:'TLocDesc',title:'����',width:160,align:'center'}, //modified by LMH 20230210 UI �޸Ŀ��
        {field:'THospital',title:'Ժ��',width:195,align:'center'},
        {field:'Title1',title:'���ҿⷿ',width:160,align:'center'},  //modified by LMH 20230210 UI �޸Ŀ��
        {field:'Title2',title:'����ְ��',width:100,align:'center'},    
        {field:'Title3',title:'�ⷿ����',width:100,align:'center'},
        {field:'TLocCode',title:'���Ҵ���',width:100,align:'center',hidden:'true'},    
        {field:'TRemark',title:'��ע',width:70,align:'center'},    
        {field:'TManageUser',title:'����Ա',width:100,align:'center'},
        {field:'TLocation',title:'λ��',width:100,align:'center'},    
        {field:'TTel',title:'��ϵ�绰',width:100,align:'center'},    
        {field:'THold1',title:'THold1',width:50,align:'center',hidden:'true'},
        {field:'THold2',title:'THold2',width:60,align:'center',hidden:'true'},    
        {field:'THold3',title:'THold3',width:100,align:'center',hidden:'true'},    
        {field:'THold4',title:'THold4',width:100,align:'center',hidden:'true'},
        {field:'THold5',title:'THold5',width:100,align:'center',hidden:'true'},    
    	]],
    	onClickRow : function (rowIndex, rowData) {
        	DHCEQClocTypeNew_OnClickRow();
   	 	},
    	pagination:true,
    	pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]   
	});

}
function BSave_Clicked(){
	var selected=$('#tDHCEQClocTypeNew').datagrid('getSelected');   //add by wy 2018-12-28 791854
	if (!selected)
	{
		messageShow('alert','error','��ʾ',"��ѡ��һ��!");
		return;
	}
    if (checkMustItemNull()) return;
    var plist=CombinData();
    $.ajax({
            url :"dhceq.jquery.method.csp",
            type:"POST",
            data:{
                ClassName:"web.DHCEQ.Plat.CTLocType",
                MethodName:"UpdateEQLocDetail",
                Arg1:plist,
                ArgCnt:1
            },
            beforeSend: function () {
                $.messager.progress({
                text: '���ڱ�����...'
                });
            },
           	error:function(XMLHttpRequest, textStatus, errorThrown){
                        alertShow(XMLHttpRequest.status);
                        alertShow(XMLHttpRequest.readyState);
                        alertShow(textStatus);
                    },
            success:function (data, response, status) {
            $.messager.progress('close');
            if (data>0) { 
            $('#tDHCEQClocTypeNew').datagrid('reload'); 
            $.messager.popover({msg:"����ɹ�",type:'success'});
			ClearElement();
			disableElement("BSave",true);	// MZY0025	1318615		2020-05-13
            }   
            else {
               $.messager.popover({msg:"����ʧ��",type:'error'});
               return;
               }
           }
           
  
        })
}
function CombinData()
{
	var combindata=getElementValue("LocDR");//����
  	combindata=combindata+"^"+getElementValue("TypeIDOne");		//����id
  	combindata=combindata+"^"+getElementValue("GroupIDOneDR");	//����id
  	combindata=combindata+"^"+getElementValue("TypeIDTwo");
  	combindata=combindata+"^"+getElementValue("GroupIDTwoDR");
	combindata=combindata+"^"+getElementValue("TypeIDThree");
  	combindata=combindata+"^"+$('#GroupIDThree').combogrid('getValues').toString();
	combindata=combindata+"^"+getElementValue("Remark");
	combindata=combindata+"^"+getElementValue("ManageUserDR");
	combindata=combindata+"^"+getElementValue("Location");
	combindata=combindata+"^"+getElementValue("Tel");
	combindata=combindata+"^"+getElementValue("Hold1");
	combindata=combindata+"^"+getElementValue("Hold2");
	combindata=combindata+"^"+getElementValue("Hold3");
	combindata=combindata+"^"+getElementValue("Hold4");
	combindata=combindata+"^"+getElementValue("Hold5");
  	return combindata;
}
function setElementEnabled(){
      if(getElementValue("GroupIDOneDR")=="1"){
		 disableElement("GroupIDTwo",true);
		 setElement("GroupIDTwoDR","");		//add by wy 2019-5-17 886422
	     setElement("GroupIDTwo","");	//����ְ��
		 disableElement("GroupIDThree",false);}
	  else{
		 disableElement("GroupIDThree",true);
		 setElement("GroupIDThreeDR","");	//add by wy 2019-5-17 886422
	     setElement("GroupIDThree","");	//����id3
		 disableElement("GroupIDTwo",false);}
	}