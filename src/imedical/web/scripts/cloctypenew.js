/// 描述:新科室类型设置
///hisui界面改造
var SelectedRow = 0;
var preRowID=0; 
//界面入口
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
//初始化查询头面板
function initTopPanel()
{
	initButton(); //按钮初始化 add by wy 2019-4-25
	showBtnIcon('BFind^BSave',false); //modified by LMH 20230209 动态设置是否极简显示按钮图标
	initButtonWidth();
	setRequiredElements("Loc")
	defindTitleStyle();
	initLookUp(); //初始化放大镜
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
//下拉多选框改为combogrid modified by wy 2019-2-16 需求：824591
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
			{field:'TName',title:'描述',width:70,align:'center',width:50},
			{field:'TCode',title:'代码',width:70,align:'center',width:50}
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
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			var IDs=list[7].split("#");
			var Strs=list[6].split("#");
			setElement("LocDR",list[0]);
			setElement("Loc",list[1]);			//科室
			setElement("Hospital",list[2]);		//院区
			setElement("TypeIDTwo",list[3]);	
			setElement("GroupIDTwoDR",list[4]);	//科室职能
			setElement("GroupIDTwo",list[5]);	//科室职能
			//setElement("GroupIDThreeDR",list[6]);	//类型id3
			$('#GroupIDThree').combogrid('setValues',IDs)
			setElement("TypeIDThree",Strs);
			//setElement("GroupIDThree",str);	//库房属性
			setElement("TypeIDOne",list[9]);
			setElement("GroupIDOneDR",list[10]);	//类型id1
			setElementEnabled();    //add by wy 2019-2-16
			setElement("GroupIDOne",list[11]);	//科室
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
	setElement("LocDR",""); 		//科室id
	setElement("Loc","");			//科室
	setElement("Hospital","");		//院区
	setElement("TypeIDOne","");		//类型id1
	setElement("GroupIDOneDR","");		//类型id1
	setElement("GroupIDOne","");	//分组id1
	setElement("TypeIDTwo","");		//类型id2
	setElement("GroupIDTwoDR","");		//类型id2
	setElement("GroupIDTwo","");	//科室职能
	setElement("TypeIDThree","");	//类型id3
	setElement("GroupIDThreeDR","");	//类型id3
	setElement("GroupIDThree","");	//分组id3
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
	        GroupIDOne:getElementValue("GroupIDOneDR"),   //modifed by wy 2018-12-14 需求:767587
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
		//fitColumns:true, //modified by LMH 20230210 UI 列少默认向左对齐
    	columns:[[
    	{field:'TLocDR',title:'TLocDR',width:50,hidden:'true'},    
        {field:'TLocDesc',title:'科室',width:160,align:'center'}, //modified by LMH 20230210 UI 修改宽度
        {field:'THospital',title:'院区',width:195,align:'center'},
        {field:'Title1',title:'科室库房',width:160,align:'center'},  //modified by LMH 20230210 UI 修改宽度
        {field:'Title2',title:'科室职能',width:100,align:'center'},    
        {field:'Title3',title:'库房属性',width:100,align:'center'},
        {field:'TLocCode',title:'科室代码',width:100,align:'center',hidden:'true'},    
        {field:'TRemark',title:'备注',width:70,align:'center'},    
        {field:'TManageUser',title:'管理员',width:100,align:'center'},
        {field:'TLocation',title:'位置',width:100,align:'center'},    
        {field:'TTel',title:'联系电话',width:100,align:'center'},    
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
		messageShow('alert','error','提示',"请选择一行!");
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
                text: '正在保存中...'
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
            $.messager.popover({msg:"保存成功",type:'success'});
			ClearElement();
			disableElement("BSave",true);	// MZY0025	1318615		2020-05-13
            }   
            else {
               $.messager.popover({msg:"保存失败",type:'error'});
               return;
               }
           }
           
  
        })
}
function CombinData()
{
	var combindata=getElementValue("LocDR");//科室
  	combindata=combindata+"^"+getElementValue("TypeIDOne");		//类型id
  	combindata=combindata+"^"+getElementValue("GroupIDOneDR");	//分组id
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
	     setElement("GroupIDTwo","");	//科室职能
		 disableElement("GroupIDThree",false);}
	  else{
		 disableElement("GroupIDThree",true);
		 setElement("GroupIDThreeDR","");	//add by wy 2019-5-17 886422
	     setElement("GroupIDThree","");	//分组id3
		 disableElement("GroupIDTwo",false);}
	}