var locColumns=getCurColumnsInfo('PLAT.G.Maint.LocRangeList','','','');  
var masterColumns=getCurColumnsInfo('PLAT.G.Maint.MasterRangeList','','','');  
var equipColumns=getCurColumnsInfo('PLAT.G.Maint.EquipRangeList','','','');  
var statcatColumns=getCurColumnsInfo('PLAT.G.Maint.StatCatRangeList','','','');  
var hasstatcatColumns=getCurColumnsInfo('PLAT.G.Maint.HasStatCatRangeList','','','');  
var equiptypeColumns=getCurColumnsInfo('PLAT.G.Maint.EquipTypeRangeList','','','');  
var hasequiptypeColumns=getCurColumnsInfo('PLAT.G.Maint.HasEquipTypeRangeList','','','');  


jQuery(document).ready
(
	function()
	{
		setTimeout("initEquipRangeDocument();",100);
	}
);
function initEquipRangeDocument()
{
	initButtonWidth();   //add by lmm 2020-04-26 1292188
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
  	if ((SourceID=="")||(SourceID==0)||((SourceType==""))) 
  	{
	initStatCat();
	initEquipType();
	initDataGrid();	  	
  	
  	}
	defindTitleStyle(); 
	hiddenRadioBySourName();
	initKeyWord();
	initRangeButton();
	FillEquipRangeData();
	setEnabled();   //add by zc0053 2019-11-25 按钮灰化
	hiddenTDeleteListColumn();  //add by lmm 2019-01-10 803158
}
///add by lmm 2019-10-29 1040240
///desc:初始化类组类型增加减少按钮
function initRangeButton()
{
	jQuery("#BAddStatCat").linkbutton({iconCls: 'icon-w-arrow-right'});
	jQuery("#BAddStatCat").on("click", BAddStatCat_Clicked);
	jQuery("#BDeleteStatCat").linkbutton({iconCls: 'icon-w-arrow-left'});
	jQuery("#BDeleteStatCat").on("click", BDeleteStatCat_Clicked);
	jQuery("#BAddEquipType").linkbutton({iconCls: 'icon-w-arrow-right'});
	jQuery("#BAddEquipType").on("click", BAddEquipType_Clicked);
	jQuery("#BDeleteEquipType").linkbutton({iconCls: 'icon-w-arrow-left'});
	jQuery("#BDeleteEquipType").on("click", BDeleteEquipType_Clicked);
	
	
}
///add by lmm 2019-10-29 1040240
///desc:类型增加点击事件
function BAddStatCat_Clicked()
{
	AddChangeList("DHCEQStatCat","DHCEQHasStatCat","2")	
	
}
///add by lmm 2019-10-29 1040240
///desc:类型删除点击事件
function BDeleteStatCat_Clicked()
{
	AduceChangeList("DHCEQHasStatCat","DHCEQStatCat")	
	
}
///add by lmm 2019-10-29 1040240
///desc:类组增加点击事件
function BAddEquipType_Clicked()
{
	AddChangeList("DHCEQEquipType","DHCEQHasEquipType","1")	
	
}
///add by lmm 2019-10-29 1040240
///desc:类组删除点击事件
function BDeleteEquipType_Clicked()
{
	AduceChangeList("DHCEQHasEquipType","DHCEQEquipType")	
	
}


///add by lmm 2019-10-29 1040240
///desc:增加列表列
function AddChangeList(FromList,ToList,Type)
{
	var TEquipRangeDR=""
	var rows = $('#'+FromList).datagrid('getSelections');     
	var copyrows = []     
	for(i=0;i<rows.length;i++){copyrows.push(rows[i]);     }     
	for(j=0;j<copyrows.length;j++){           
		var index = $('#'+FromList).datagrid('getRowIndex',copyrows[j])
		$('#'+FromList).datagrid('deleteRow',index)             
		$('#'+ToList).datagrid('appendRow',{                   
         	TRowID : '',
         	TEquipRangeDR:'',
         	TTypeDR : Type,
         	TValueDR : copyrows[j].TRowID,
         	TValue : copyrows[j].TDesc,
         	TAccessFlag:'Y'
		})   
		var TEquipRangeDR=""
	}
	
}
///add by lmm 2019-10-29 1040240
///desc:减少列表列
function AduceChangeList(FromList,ToList)
{
	var rows = $('#'+FromList).datagrid('getSelections');     
	var copyrows = [] 
	var vallist=""    
	for(i=0;i<rows.length;i++){
		if (rows[i].TRowID=="")
		{
			copyrows.push(rows[i]);  
		}
		else
		{
			copyrows.push(rows[i]);
			if (vallist=="")
			{
				var vallist=rows[i].TRowID; 
			} 
			else
			{
				var vallist=vallist+","+rows[i].TRowID; 
			}
 
			
		}   
		
	}     
	//modify by lmm 2020-04-08 messageShow替换
		messageShow("confirm","","","是否删除指定范围数据?","",function(){
			AduceChangeData(FromList,ToList,vallist,copyrows)
			},'');
	
}
function AduceChangeData(FromList,ToList,vallist,copyrows)
{
	if (vallist!="")
	{
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange", "DeleteManageLimitList",vallist);
		if (Rtn!=0)
		{
			messageShow("","","","删除失败！")
			return;
		}		
	}
	
	
	for(j=0;j<copyrows.length;j++){           
		var index = $('#'+FromList).datagrid('getRowIndex',copyrows[j])
		$('#'+FromList).datagrid('deleteRow',index)  
		$('#'+ToList).datagrid('appendRow',{                   
         	TRowID : copyrows[j].TValueDR,
         	TDesc:copyrows[j].TValue,
		})   
	}
	
	
	
	
	
}

///add by lmm 2019-10-29 1040240
///desc:定义关键词选项
function hiddenRadioBySourName()
{
	keyrows=[]
	var SourceName=getElementValue("SourceName")
	switch(SourceName){
		case "MeteragePlan":   //modify by mwz 2019-12-16 MWZ0024
			keyrows=[{text:'指定科室',id:'LimitLoc'},     //add by lmm 2020-05-13
						{text:'指定设备',id:'LimitEquip'},         
						{text:'指定设备项',id:'LimitItem'}]  
		break;
		case "InspectPlan":
			keyrows=[{text:'指定类组',id:'LimitEquipType'},
							{text:'指定类型',id:'LimitStatCat'},         
							{text:'指定科室',id:'LimitLoc'},         
							{text:'指定设备',id:'LimitEquip'},         
							{text:'指定设备项',id:'LimitItem'},         
							{text:'指定科室及设备项',id:'LimitLocItem'}]  

		break;
		case "MaintPlan":   //modify by mwz 2019-12-16  MWZ0024
			keyrows=[{text:'指定科室',id:'LimitLoc'},         
							{text:'指定设备',id:'LimitEquip'},         
							{text:'指定设备项',id:'LimitItem'},         
							{text:'指定科室及设备项',id:'LimitLocItem'}]  
		break;
		default :
		break;
	}
	
}
///add by lmm 2019-10-29 1040240
///desc:初始化关键字
function initKeyWord()
{
	$("#redkw").keywords({
	singleSelect:true,     
	labelCls:'red',     
	items:keyrows,     
	onClick:function(id){
		//setTimeout("CheckContrl("+id+");",100);
		//alertShow("id"+id.id)
		//setTimeout("CheckContrl("+id+");",1000);
		CheckContrl(id) 
	 
	 },     
	 });
}

/*
 *Description:勾选框控制列表是否隐藏
 *author:李苗苗
*/
///modify by lmm 2020-01-03 1040240
function CheckContrl(Keyword)
{
		$('#div-DHCEQLoc').hide()
		$('#div-DHCEQMastitem').hide()
		$('#div-DHCEQEquip').hide()
		$('#div-DHCEQEquipType').hide()
		$('#div-DHCEQStatCat').hide()
		$('#div-DHCEQItemLoc').hide()   //add by lmm 2019-12-27
	if(Keyword.id=="LimitLoc")
	{
		$('#div-DHCEQItemLoc').show()
		$('#div-DHCEQLoc').show()
		$('#div-DHCEQLoc').width('100%')
		$('#panel-DHCEQLoc').panel({width:'99%'});
		$('body').layout('resize');


		$('#DHCEQLoc').datagrid('reload');

	}
	else if(Keyword.id=="LimitItem")
	{
		$('#div-DHCEQItemLoc').show()
		$('#div-DHCEQMastitem').show()
		//modify by lmm 2020-02-10 1040239
		$("#span-BMastite").attr("style","position:absolute;right:1%;top:10px;");
		$('#div-DHCEQMastitem').width('100%')
		$('#panel-DHCEQMastitem').panel({width:'99%'});
		
		$('body').layout('resize');
		
		$('#DHCEQMastitem').datagrid('reload');

	}
	else if(Keyword.id=="LimitEquip")
	{

		
		$('#div-DHCEQEquip').show()
		$('#DHCEQEquip').datagrid('reload');

	}
	else if(Keyword.id=="LimitLocItem")
	{
		
		$('#div-DHCEQItemLoc').show()
		$('#div-DHCEQLoc').show()
		$('#div-DHCEQMastitem').show()
		//modify by lmm 2020-02-10 1040239
		$("#span-BMastite").attr("style","position:absolute;right:51%;top:10px;");
		$('#div-DHCEQLoc').width('49.5%')
		$('#div-DHCEQMastitem').width('49.5%')
		
		$('#panel-DHCEQLoc').panel({width:'48.5%'});
		$('#panel-DHCEQMastitem').panel({width:'48.5%'});
		$('body').layout('resize');

		$('#DHCEQLoc').datagrid('reload');
		$('#DHCEQMastitem').datagrid('reload');

	}
	else if(Keyword.id=="LimitStatCat")
	{

		$('#div-DHCEQStatCat').show()
		initStatCat();
		$('#DHCEQStatCat').datagrid('reload');
		$('#DHCEQHasStatCat').datagrid('reload');
		

	}
	else if(Keyword.id=="LimitEquipType")
	{

		$('#div-DHCEQEquipType').show()
		initEquipType();
		$('#DHCEQEquipType').datagrid('reload');
		$('#DHCEQHasEquipType').datagrid('reload');


	}
	else
	{
		$('#div-DHCEQLoc').hide()
		$('#div-DHCEQMastitem').hide()
		$('#div-DHCEQEquip').hide()
		$('#div-DHCEQEquipType').hide()
		$('#div-DHCEQStatCat').hide()
	}
	return
	
}
///未使用方法删除  modify by lmm 2020-01-03 方法名：changeDatagridWidth

function initStatCat()
{
	
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
	var list=""
  	if ((SourceID!="")||(SourceID!=0)) {
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetEquipRangelistStr",SourceID,SourceType,"2");
  	}
		$HUI.datagrid("#DHCEQStatCat",{ 
	    url:$URL, 
	    border:false,
		//fitColumns:true,autoSizeColumn:true,  //modify by lmm 2019-11-19 LMM0049
		striped : true,
		fit:true,
		toolbar:"#tb",
	    cache: false,
	    singleSelect:false,   
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.DHCEQCManageLimit",
	        QueryName:"GetValue",
	        Type:'2',
	        ValueIDStr:list,
	        InFlag:'off'
	    },
	    
	    columns:statcatColumns,
		});	
	
	
}


function initEquipType()
{
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
	var list=""
  	if ((SourceID!="")||(SourceID!=0)) {
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetEquipRangelistStr",SourceID,SourceType,"1");
  	}
	
		$HUI.datagrid("#DHCEQEquipType",{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
	    cache: false,
	    singleSelect:false,   
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.DHCEQCManageLimit",
	        QueryName:"GetValue",
	        Type:'1',
	        ValueIDStr:list,
	        InFlag:'off'
	    },
	    columns:equiptypeColumns,
		});	
	
	
}

function initStatCatKeyWord()
{
	$("#DHCEQStatCat").keywords({     
	singleSelect:false,     
	labelCls:'blue',     
	items:[{text:'指定类组',id:'LimitEquipType',style:{'width':'130px'}},
							{text:'指定类型',id:'LimitStatCat',style:{'width':'130px'}},         
							{text:'指定科室',id:'LimitLoc',width:'250px'},         
							{text:'指定设备',id:'LimitEquip'},         
							{text:'指定设备项',id:'LimitItem'},         
							{text:'指定科室及设备项',id:'LimitLocItem'}],     
	onClick:function(id){
		//CheckContrl(id) 
	 
	 },     
	 });
	$("#DHCEQHasStatCat").keywords({     
	singleSelect:false,     
	labelCls:'blue',     
	items:keyrows,     
	onClick:function(id){
		//CheckContrl(id) 
	 
	 },     
	 });
	
}

/*
 *Description:设备范围表单数据填充
 *author:李苗苗
*/
function FillEquipRangeData()
{
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
  	if ((SourceID=="")||(SourceID==0)||((SourceType==""))) 
  	{
	$HUI.keywords("#redkw").select("LimitItem");  //关键字添加默认 指定设备项
  	return;
  	}
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetOneEquipRange",SourceID,SourceType);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");
	setElement("EquipRangeDR",list[0]);
	setElement("RangeDesc",list[1]);
	setElement("SourceType",list[2]);
	
	equipTypeList=list[17].split(",");
	var len=equipTypeList.length
    equipTyperows=[]
	for (i=0;i<len;i++)
	{
		equipTyperows.push(equipTypeList[i]);
		
	}
	
	
	setElement("EquipRangeEquipTypeDR",list[19]);
	statCatList=list[20].split(",");
	var len=statCatList.length
    statCatrows=[]
	for (i=0;i<len;i++)
	{
		statCatrows.push(statCatList[i]);
		
	}
	setElement("EquipRangeStatCatDR",list[22]);
		initDataGrid();	
		initStatCat();
		initEquipType();

	if(list[4]=="Y") {$HUI.keywords("#redkw").switchById("LimitEquipType");} 
	if(list[5]=="Y") {$HUI.keywords("#redkw").switchById("LimitStatCat"); }
	if(list[8]=="Y") {$HUI.keywords("#redkw").switchById("LimitEquip"); }
	
	if ((list[7]=="Y")&&(list[9]=="Y"))
	{$HUI.keywords("#redkw").switchById("LimitLocItem"); }
	else if(list[7]=="Y") {$HUI.keywords("#redkw").switchById("LimitLoc"); }
	else if(list[9]=="Y") {$HUI.keywords("#redkw").switchById("LimitItem");} 
	
	
	
	
}
/*
 *Description:列表数据加载
 *author:李苗苗
*/
function initDataGrid()
{
	EquipRangeLocDataGrid("DHCEQLoc","4","科室列表");
	EquipRangeMastitemDataGrid("DHCEQMastitem","6","设备项列表");
	EquipRangeEquipDataGrid("DHCEQEquip","5","设备列表");
	EquipRangeStatCatDataGrid("DHCEQHasStatCat","2","已选指定类型");
	EquipRangeEquipTypeDataGrid("DHCEQHasEquipType","1","已选指定类组");
	
}
/*
 *Description:设备范围限定数据科室列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeEquipTypeDataGrid(EquipRangeListID,Type,title)
{
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+EquipRangeListID,{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
	    cache: false,
	    singleSelect:false,   
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:Type,
	        Value:'',
	    },
		//modify by lmm 2019-06-06 begin	    
	    columns:hasequiptypeColumns,
		});	
				
}
/*
 *Description:设备范围限定数据科室列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeStatCatDataGrid(EquipRangeListID,Type,title)
{
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+EquipRangeListID,{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
	    cache: false,
	    singleSelect:false,   
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:Type,
	        Value:'',
	    },
		//modify by lmm 2019-06-06 begin	    
	    columns:hasstatcatColumns,
		});	
				
}
/*
 *Description:设备范围限定数据科室列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeLocDataGrid(EquipRangeListID,Type,title)
{
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+EquipRangeListID,{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
		fitColumns:true,   //add by lmm 2020-06-05 UI
	    cache: false,
	    singleSelect:true,   
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:Type,
	        Value:'',
	    },
		//modify by lmm 2019-06-06 begin	    
	    columns:locColumns,
		});	
			
	var TDeleteList=$("#DHCEQLoc").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			return '<a href="#"  onclick="deleterow(&quot;'+4+','+row.TRowID+','+index+','+row.TValueDR+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';   //modify by lmm 2019-03-12 840927		
		}
	
}
/*
 *Description:设备范围限定数据设备项列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeMastitemDataGrid(EquipRangeListID,Type,title)
{
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+EquipRangeListID,{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
		fitColumns:true,   //add by lmm 2020-06-05 UI
	    cache: false,
	    singleSelect:true,   
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:Type,
	        Value:'',
	    },
		//modify by lmm 2019-06-06 begin	    
	    columns:masterColumns,
		});
	var TDeleteList=$("#DHCEQMastitem").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			return '<a href="#"  onclick="deleterow(&quot;'+6+','+row.TRowID+','+index+','+row.TValueDR+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';   //modify by lmm 2019-03-12 840927	 	
		}
			
}
/*
 *Description:设备范围限定数据设备列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeEquipDataGrid(EquipRangeListID,Type,title)
{
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+EquipRangeListID,{ 
	    url:$URL, 
	    border:false,
		striped : true,
		fit:true,
		fitColumns:true,   //add by lmm 2020-06-05 UI
	    cache: false,
	    singleSelect:true,   
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:Type,
	        Value:'',
	    },
		//modify by lmm 2019-06-06 begin	    
		columns:equipColumns,
		});
		
	var TDeleteList=$("#DHCEQEquip").datagrid('getColumnOption','TDeleteList');
	TDeleteList.formatter=	function(value,row,index){
			return '<a href="#"  onclick="deleterow(&quot;'+5+','+row.TRowID+','+index+','+row.TValueDR+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';   //modify by lmm 2019-03-12 840927		
		}
}

/*
 *Description:点击添加弹出列表添加界面
 *params:SourceType：列表类型序号
 *author:李苗苗
*/
///add by lmm 2019-02-19 添加回调
function AddgridData(type)
{
	//modify by lmm 2020-03-27 1247420
	var planstatus=getElementValue("vStatus")
	if(type==4)
	{
		url="dhceq.em.maintloclimitlist.csp?"+"&SourceType="+type+"&Planstatus="+planstatus;	
	}
	else if(type==5)
	{
		url="dhceq.em.maintequiplimitlist.csp?"+"&SourceType="+type+"&ComputerFlag="+getElementValue("ComputerFlag")+"&Planstatus="+planstatus;  //modify by lmm 2019-05-30 919160	
	}
	else if(type==6)
	{
		url="dhceq.em.maintmasteritemlimitlist.csp?"+"&SourceType="+type+"&Planstatus="+planstatus;	
	}
	 //modify by lmm 2019-01-26 begin 818786
	 //modify by lmm 2020-01-16 1174148
	var width=""
	var height="" 
	var title="范围限定"
	var icon="icon-w-find"
	var showtype="modal"   //modify by lmm 2019-02-19
	if(type==4)
	{
		showWindow(url,title,width,height,icon,showtype,"","","middle",insertLocRow) //modify by lmm 2020-06-05 UI
	}
	else if(type==5)
	{
		showWindow(url,title,width,height,icon,showtype,"","","middle",insertEquipRow) //modify by lmm 2020-06-05 UI
	}
	else if(type==6)
	{
		showWindow(url,title,width,height,icon,showtype,"","","middle",insertMastitemRow) //modify by lmm 2020-06-05 UI
	}
	 //modify by lmm 2019-01-26 end 818786
	
	
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertLocRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQLoc"
			var morows = $("#"+ComponentID).datagrid("getRows")
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.TValueDR+",";
					}
					 else vallist=vallist+rowData.TValueDR+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].TRowID+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
						 TRowID : '',
						 TEquipRangeDR:TEquipRangeDR,
						 TTypeDR : SourceType,
						 //type : Desc,
						 TValueDR : copyrows[i].TRowID,
						 TValue : copyrows[i].TName,
						 TCode : copyrows[i].TCode,
						 TAccessFlag:'Y'
						})  
					var TEquipRangeDR=""
				}
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertMastitemRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQMastitem"
			var morows = $("#"+ComponentID).datagrid("getRows");
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.TValueDR+",";
					}
					 else vallist=vallist+rowData.TValueDR+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].TRowID+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
				             	TRowID : '',
				             	TEquipRangeDR:TEquipRangeDR,
				             	TTypeDR : SourceType,
				             	//type : Desc,
				             	TValueDR : copyrows[i].TRowID,
				             	TValue : copyrows[i].TName,
				             	TEquipTypeDR : copyrows[i].TEquipTypeDR,
				             	TEquipType : copyrows[i].TEquipType,
				             	TAccessFlag:'Y'
				     })  
			
					var TEquipRangeDR=""
					
				}
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertEquipRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQEquip"
			var morows = $("#"+ComponentID).datagrid("getRows");
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.TValueDR+",";
					}
					 else vallist=vallist+rowData.TValueDR+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].TRowID+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
				             	TRowID : '',
				             	TEquipRangeDR:TEquipRangeDR,
				             	TTypeDR : SourceType,
				             	//type : Desc,
				             	TValueDR : copyrows[i].TRowID,
				             	TValue : copyrows[i].TName,
				             	TNo : copyrows[i].TNo,
				             	TModel : copyrows[i].TModel,
				             	TUseLoc : copyrows[i].TUseLoc,
				             	TLeaveFactoryNo : copyrows[i].TLeaveFactoryNo,
				             	TEquipType : copyrows[i].TEquipType,
				             	TAccessFlag:'Y'
				     })  			
					var TEquipRangeDR=""
					
				}
				
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function deleterow(rowlist)
{
	var rowlist=rowlist.split(",")
	var SourceType=rowlist[0]
	var RowID=rowlist[1]

	if (SourceType==4){
		var ComponentID="DHCEQLoc"
		}
	else if (SourceType==6){
		var ComponentID="DHCEQMastitem"
		}
	else if (SourceType==5){
		var ComponentID="DHCEQEquip"
		}
	//modify by lmm 2019-03-13 begin 840927
	var ValueDR=rowlist[3]
	var rows = $("#"+ComponentID).datagrid('getRows');//获得所有行
	for (var i=0;i<rows.length;i++)
	{
		if(rows[i].TValueDR==ValueDR)
		{
			var index=i;
		}
		
	}
	//modify by lmm 2019-03-13 end 840927
	//add by lmm 2018-11-09 begin 745901
	//modify by lmm 2020-04-08 messageShow替换
		messageShow("confirm","","","是否删除指定范围数据?","",function(){
			deletedata(ComponentID,RowID,SourceType,index)
			},'');
}
function deletedata(ComponentID,RowID,SourceType,index)
{
	//add by lmm 2018-11-09 end 745901
	if(RowID=="")
	{
		$("#"+ComponentID).datagrid('deleteRow',index);
	}
	else
	{
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange", "DeleteManageLimitList",RowID);
		if (Rtn ==0) {
			alertShow("删除成功!")
		//modify by lmm 2019-06-06 begin  更改为hisui的datagrid
		$HUI.datagrid("#"+ComponentID,{ 
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquipRange",
	        QueryName:"GetEquipRangeList",
	        EquipRangeDR:$('#EquipRangeDR').val(),
	        Type:SourceType,
	        Value:'',
	    },
		})
		//modify by lmm 2019-06-06 begin	    

			$("#"+ComponentID).datagrid('reload');
			
			
							
		}
		else
		{
			$.messager.alert('删除失败！',data, 'warning')
			return;
		}
		
	}
		
	
}

/*
 *Description:检测勾选框勾选，对应列表是否存在数据
 *author:李苗苗
*/
function CheckGridData()
{
	var keyObj=$HUI.keywords("#redkw").getSelected();
	if (keyObj=="")
	{
		jQuery.messager.alert("提示", "无设备范围定义！");
		return true;
	}
	
	var loclen=$("#DHCEQLoc").datagrid("getRows").length
	var mastitemlen=$("#DHCEQMastitem").datagrid("getRows").length
	var equiplen=$("#DHCEQEquip").datagrid("getRows").length
	var statcatlen=$("#DHCEQHasStatCat").datagrid("getRows").length
	var equiptypelen=$("#DHCEQHasEquipType").datagrid("getRows").length
	
	if((keyObj[0].id=="LimitLoc")&&(loclen==0)) 
	{
		jQuery.messager.alert("提示", "科室列表无数据！");
		return true;		
	}
	else if((keyObj[0].id=="LimitEquip")&&(equiplen==0)) 
	{
		jQuery.messager.alert("提示", "设备列表无数据！");
		return true;		
	}
	else if((keyObj[0].id=="LimitItem")&&(mastitemlen==0)) 
	{
		jQuery.messager.alert("提示", "设备项列表无数据！");
		return true;		
	}
	else if((keyObj[0].id=="LimitStatCat")&&(statcatlen==0)) 
	{
		jQuery.messager.alert("提示", "设备类型列表无数据！");
		return true;		
	}
	else if((keyObj[0].id=="LimitEquipType")&&(equiptypelen==0)) 
	{
		jQuery.messager.alert("提示", "设备类组列表无数据！");
		return true;		
	}
	else if((keyObj[0].id=="LimitLocItem")&&((mastitemlen==0)||(loclen==0))) 
	{
		jQuery.messager.alert("提示", "设备项,科室列表无数据！");
		return true;		
	}
	
    if (keyObj[0].id=="LimitLoc")
    {
		if((GetDataGridIDs("DHCEQEquip")!="")||(GetDataGridIDs("DHCEQMastitem")!="")||(GetDataGridIDs("DHCEQHasStatCat")!="")||(GetDataGridIDs("DHCEQHasEquipType")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
    else if (keyObj[0].id=="LimitItem")
    {
		if((GetDataGridIDs("DHCEQEquip")!="")||(GetDataGridIDs("DHCEQLoc")!="")||(GetDataGridIDs("DHCEQHasEquipType")!="")||(GetDataGridIDs("DHCEQHasStatCat")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
    else if (keyObj[0].id=="LimitEquip")
    {
		if((GetDataGridIDs("DHCEQLoc")!="")||(GetDataGridIDs("DHCEQMastitem")!="")||(GetDataGridIDs("DHCEQHasEquipType")!="")||(GetDataGridIDs("DHCEQHasStatCat")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
    else if (keyObj[0].id=="LimitEquipType")
    {
		if((GetDataGridIDs("DHCEQLoc")!="")||(GetDataGridIDs("DHCEQMastitem")!="")||(GetDataGridIDs("DHCEQEquip")!="")||(GetDataGridIDs("DHCEQHasStatCat")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
    else if (keyObj[0].id=="LimitStatCat")
    {
		if((GetDataGridIDs("DHCEQLoc")!="")||(GetDataGridIDs("DHCEQMastitem")!="")||(GetDataGridIDs("DHCEQEquip")!="")||(GetDataGridIDs("DHCEQHasEquipType")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
    else if (keyObj[0].id=="LimitLocItem")
    {
		if((GetDataGridIDs("DHCEQEquip")!="")||(GetDataGridIDs("DHCEQHasEquipType")!="")||(GetDataGridIDs("DHCEQHasStatCat")!=""))
		{
			jQuery.messager.alert("提示", "请检查指定设备范围！");
			return true;
		}
			return false;
	}
	
	
	
		return false;		

}
/*
 *Description:设备数据列表串
 *params:DataGridID：设备数据列表ID
 *author:李苗苗
*/
function GetDataGridIDs(DataGridID)
{
	var rows = $("#"+DataGridID).datagrid("getRows"); //这段代码是获取当前页的所有行。
	var vallist=""
		$.each(rows, function(rowIndex, rowData){
						
			if (vallist=="")
			{ 
				vallist=rowData.TRowID+"^"+rowData.TTypeDR+"^"+rowData.TValueDR+"^"+rowData.TAccessFlag;
			}
			 else 
			{
			 vallist=vallist+"&"+rowData.TRowID+"^"+rowData.TTypeDR+"^"+rowData.TValueDR+"^"+rowData.TAccessFlag; 
			}
		}); 
	return vallist;
}
/*
 *Description:设备范围列表明细串
 *author:李苗苗
*/
function GetEquipRangevalList()
{
	var combindata="";
	var flag=0  //判断是否存在第一串明细数据
	
	var keyObj=$HUI.keywords("#redkw").getSelected();
			
	if(keyObj[0].id=="LimitEquipType")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var EquipTypeStr=GetDataGridIDs("DHCEQHasEquipType")
		combindata=EquipTypeStr;
	}
	if(keyObj[0].id=="LimitStatCat")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var StatCatStr=GetDataGridIDs("DHCEQHasStatCat")
		combindata=combindata+StatCatStr;
	}
	if(keyObj[0].id=="LimitLoc")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var LocStr=GetDataGridIDs("DHCEQLoc")
		combindata=combindata+LocStr;
	}
	if(keyObj[0].id=="LimitEquip")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var EquipStr=GetDataGridIDs("DHCEQEquip")
		combindata=combindata+EquipStr;
	}
	if(keyObj[0].id=="LimitItem")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var MastitemStr=GetDataGridIDs("DHCEQMastitem")
		combindata=combindata+MastitemStr;
	}
	if(keyObj[0].id=="LimitLocItem")
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var LocStr=GetDataGridIDs("DHCEQLoc")
		combindata=combindata+LocStr;
		combindata=combindata+"&";
		var MastitemStr=GetDataGridIDs("DHCEQMastitem")
		combindata=combindata+MastitemStr;

	}
	
	
	
	
	
	return combindata;
	
}
/*
 *Description:设备范围列表串
 *author:李苗苗
*/
function GetEquipRangeval()
{
	var keyObj=$HUI.keywords("#redkw").getSelected();
	
	var combindata="";
  	combindata=getElementValue("EquipRangeDR"); 
	combindata=combindata+"^"+getElementValue("RangeDesc"); 
	combindata=combindata+"^"+getElementValue("SourceType"); 
	combindata=combindata+"^"+getElementValue("RowID") ; 
	
	var EquipTypeFlag="N"
	var StatCatFlag="N"
	var LocFlag="N"
	var EquipFlag="N"
	var ItemFlag="N"
	
	if(keyObj[0].id=="LimitEquipType")
	{
		var EquipTypeFlag="Y"
	}
	else if(keyObj[0].id=="LimitStatCat")
	{
		var StatCatFlag="Y"
	}
	else if(keyObj[0].id=="LimitLoc")
	{
		var LocFlag="Y"
	}
	else if(keyObj[0].id=="LimitEquip")
	{
		var EquipFlag="Y"
	}
	else if(keyObj[0].id=="LimitItem")
	{
		var ItemFlag="Y"
	}
	else if(keyObj[0].id=="LimitLocItem")
	{
		var LocFlag="Y"
		var ItemFlag="Y"
	}

	combindata=combindata+"^"+EquipTypeFlag; 
	combindata=combindata+"^"+StatCatFlag; 
	combindata=combindata+"^N"; 
	combindata=combindata+"^"+LocFlag; 
	combindata=combindata+"^"+EquipFlag ;
	combindata=combindata+"^"+ItemFlag ;
	
	return combindata;
}
function fillEquipRangeCheckBox()
{
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
  	if ((SourceID=="")||(SourceID==0)||((SourceType==""))) return;
	var equipRangelist = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetOneEquipRange",SourceID,SourceType);
	var RowID=getElementValue("SourceID");
	equipRangelist=equipRangelist.replace(/\ +/g,"")	//去掉空格
	equipRangelist=equipRangelist.replace(/[\r\n]/g,"")	//去掉回车换行
	equipRangelist=equipRangelist.split("^");
	setElement("LocFlag",equipRangelist[7]);
	setElement("EquipFlag",equipRangelist[8]);
	setElement("ItemFlag",equipRangelist[9]);

}
function fillLimitRadio()
{
	hiddenObj("div-cequiptype",true)
	hiddenObj("div-equiptype",true)
	hiddenObj("div-cstatcat",true)
	hiddenObj("div-statcat",true)
	if ((getElementValue("LocFlag")==true)&&(getElementValue("ItemFlag")!=true))
	{ 
		$HUI.radio("#LimitLoc").setValue(true);
	}
	if (getElementValue("EquipFlag")==true)
	{ 
		$HUI.radio("#LimitEquip").setValue(true);
	}
	if ((getElementValue("ItemFlag")==true)&&(getElementValue("LocFlag")!=true))
	{ 
		$HUI.radio("#LimitItem").setValue(true);
	}
	if($("#EquipType").combogrid("getValues")!="") 
	{
		hiddenObj("div-cequiptype",false)
		hiddenObj("div-equiptype",false)
		$HUI.radio("#LimitEquipType").setValue(true);
		
	}
	if($("#StatCat").combogrid("getValues")!="") 
	{
		hiddenObj("div-cstatcat",false)
		hiddenObj("div-statcat",false)
		$HUI.radio("#LimitStatCat").setValue(true);
	}
	if ((getElementValue("LocFlag")==true)&&(getElementValue("ItemFlag")==true))
	{ 
		hiddenObj("div-cequiptype",false)
		hiddenObj("div-equiptype",false)
		$HUI.radio("#LimitLocItem").setValue(true);
		$HUI.radio("#LimitLoc").setValue(false);
		$HUI.radio("#LimitItem").setValue(false);
	}
	
	
}


/*
 *Description:设备数据列表串
 *params:DataGridID：设备数据列表ID
 *author:李苗苗
*/
function GetGridIDsForEqu(DataGridID)
{
	var rows = $("#"+DataGridID).datagrid("getRows"); //这段代码是获取当前页的所有行。
	var vallist=""
	
		$.each(rows, function(rowIndex, rowData){
			if (vallist=="")
			{ 
				vallist=rowData.TValueDR
			}
			 else 
			{
			 vallist=vallist+","+rowData.TValueDR
			}
		}); 
	return vallist;
}


///add by lmm 2019-01-10 803158
///描述：隐藏列表删除列
function hiddenTDeleteListColumn()
{
	if(getElementValue("SourceType")==2)
	{
	  	if ((getElementValue("SourceID")=="")||(getElementValue("SourceID")==0)) return;
		var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan",getElementValue("SourceID"));
		list=list.replace(/\ +/g,"")	//去掉空格
		list=list.replace(/[\r\n]/g,"")	//去掉回车换行
		list=list.split("^");
		if(list[25]==2)
		{
			$('#DHCEQLoc').datagrid('hideColumn','TDeleteList')
			$('#DHCEQMastitem').datagrid('hideColumn','TDeleteList')
			$('#DHCEQEquip').datagrid('hideColumn','TDeleteList')
		}
		}
	
}

function EquipList_Clicked()
{
	var EquipTypeStr=GetGridIDsForEqu("DHCEQHasEquipType")
	var StatCatStr=GetGridIDsForEqu("DHCEQHasStatCat")
	var LocStr=GetGridIDsForEqu("DHCEQLoc")
	var EquipStr=GetGridIDsForEqu("DHCEQEquip")
	var MastitemStr=GetGridIDsForEqu("DHCEQMastitem")
	if ((EquipTypeStr=="")&&(StatCatStr=="")&&(LocStr=="")&&(EquipStr=="")&&(MastitemStr==""))
	{
		jQuery.messager.alert("提示", "无设备范围限定！");
		return;
		
	}
	//add by lmm 2018-12-25 begin
	var ComputerFlag=""
	if (getElementValue("SourceName")=="MeteragePlan")
	{
		var ComputerFlag="Y"
	}
	
	url="dhceq.em.maintplanequiprange.csp?"+"&EquipTypeStr="+EquipTypeStr+"&StatCatStr="+StatCatStr+"&LocStr="+LocStr+"&EquipStr="+EquipStr+"&MastitemStr="+MastitemStr+"&ComputerFlag="+ComputerFlag;	
	//add by lmm 2018-12-25 end
	//add by lmm 2019-01-29 begin 820769
	var title="设备明细"
	var icon="icon-w-paper"
	var width=""
	var height=""
	var showtype="modal"  //modify by lmm 2019-02-19
	showWindow(url,title,width,height,icon,showtype,"","","middle") //modify by lmm 2020-06-05 UI
	
}

function SearchHander(value,name)
{
	var SourceID=getElementValue("SourceID");
	var SourceType=getElementValue("SourceType");
	var list=""
  	if ((SourceID!="")||(SourceID!=0)) {
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetEquipRangelistStr",SourceID,SourceType,"2");
  	}
	//alertShow("list"+list+"statcatColumns"+JSON.stringify(statcatColumns))
		$HUI.datagrid("#DHCEQStatCat",{ 
	    url:$URL, 
	    border:false,
		fitColumns:true,autoSizeColumn:true,
		striped : true,
		fit:true,
	    cache: false,
	    singleSelect:false,   
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.DHCEQCManageLimit",
	        QueryName:"GetValue",
	        Type:'2',
	        Desc:value,
	        ValueIDStr:list,
	        InFlag:'off'
	    },
	    
	    columns:statcatColumns,
		});	
	
}

//add by zc0053 2019-11-25 按钮灰化
function setEnabled()
{
	var Status=getElementValue("vStatus");
	if (Status!="0")
	{
		if (Status!="")
		{
			disableElement("BAddEquipType",true)
			disableElement("BDeleteEquipType",true)
			disableElement("BAddStatCat",true)
			disableElement("BDeleteStatCat",true)
		}
	}
	
}
