var tableList=new Array();
var tEvaluate=new Array();
var CurApproveFlowID="";
var FromDeptStr=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503014")
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

function initDocument()
{
	initUserInfo();
	initMessage("Maint");
	initLookUp();		//初始化放大镜
	defindTitleStyle();
	//设备名称放大镜显示前事件
	initButton();
	$("#ReminderFlag").checkbox({
		onCheckChange:function(){
			if(this.checked){
				setElement("ReminderPattern",1);
				BFind_Clicked();
			}
			else{
				setElement("ReminderPattern",0);
				BFind_Clicked();
			}
		}
	})
	initMaintWaitListDataGrid();  //Modefied by zc 2022-4-8
}
//Modefied by zc 2022-4-8 begin
function BPopoverAction_Clicked()
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","ReturnJsonAction")
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ActionItem.push({text:'不限',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[1]
		ActionItem.push({text:text,id:id});
	}
	$('#BPopoverAction').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
		url:'#ActionItem',
		closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		dismissible:false, //Modified  By QW20210220 BUG:QW0092 测试需求:1743633
		onShow: function($element) {
			$HUI.keywords("#ActionItemDetail").select(getElementValue("ActionPattern"));
		}
    });
    $("#ActionItemDetail").keywords({
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:ActionItem
	                }
	            ]
	        }
	    ]
	});
	$("#BActionSure").click(function(){
		var ActionItemKeyObj=$HUI.keywords("#ActionItemDetail").getSelected();
		setElement("ActionPattern",ActionItemKeyObj[0].id);
		BFind_Clicked();
		$('#BPopoverAction').webuiPopover('hide');
	});
}
function BPopoverEmergency_Clicked()
{
	var EmergencyItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","ReturnJsonEmergency")
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	EmergencyItem.push({text:'不限',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[1]
		EmergencyItem.push({text:text,id:id});
	}
	$('#BPopoverEmergency').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
    	closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		url:'#EmergencyItem',
		dismissible:false, //Modified  By QW20210220 BUG:QW0092 测试需求:1743633
		onShow: function($element) {
			$HUI.keywords("#EmergencyItemDetail").select(getElementValue("EmergencyPattern"));
		}
    });
    $("#EmergencyItemDetail").keywords({
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:EmergencyItem
	                }
	            ]
	        }
	    ]
	});
	$("#BEmergencySure").click(function(){
		var EmergencyItemKeyObj=$HUI.keywords("#EmergencyItemDetail").getSelected();
		setElement("EmergencyPattern",EmergencyItemKeyObj[0].id);
		$('#BPopoverEmergency').webuiPopover('hide');
		BFind_Clicked();
	});
}
function BPopoverManageType_Clicked()
{
	var ManageTypeItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","ReturnJsonManageType")
	Vallist=Vallist.replace(/\\n/g,"\n");
	
	ManageTypeItem.push({text:'不限',id:'0'});
	var list=Vallist.split("&");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[2]
		ManageTypeItem.push({text:text,id:id});
	}
	$('#BPopoverManageType').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
    	closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		url:'#ManageTypeItem',
		dismissible:false, //Modified  By QW20210220 BUG:QW0092 测试需求:1743633
		onShow: function($element) {
			$HUI.keywords("#ManageTypeItemDetail").select(getElementValue("ManageTypeID"));
		}
    });
    $("#ManageTypeItemDetail").keywords({
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:ManageTypeItem
	                }
	            ]
	        }
	    ]
	});
	$("#BManageTypeSure").click(function(){
		var ManageTypeItemKeyObj=$HUI.keywords("#ManageTypeItemDetail").getSelected();
		setElement("ManageTypeID",ManageTypeItemKeyObj[0].id);
		$('#BPopoverManageType').webuiPopover('hide');
		BFind_Clicked();
	});
}
function BPopoverMainter_Clicked()
{
	$('#BPopoverMainter').webuiPopover({
		width:200,//can be set with  number
    	height:'auto',//can be set with  number
    	closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		url:'#MainterItem',
		dismissible:false,  //Modified  By QW20210220 BUG:QW0092 测试需求:1743633
		onShow: function($element) {
			//$element.css( 'z-index','1' ); //Modified  By QW20210129 BUG:QW0089 测试需求:1743648
			$HUI.keywords("#MainterItemDetail").select(getElementValue("UserPattern"));
			if(getElementValue("UserPattern")=="4") $("#MaintUser").lookup("enable");
		}
    });
    $("#MainterItemDetail").keywords({
	    	onClick:function(v){
			   if(v.id=="4")
			   {
				   	$("#MaintUser").lookup("enable");
				}else{
					$("#MaintUser").lookup("disable");
					setElement("MaintUserDR","");
					setElement("MaintUser","");
				}
			},
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'本人',id:'2'},
							{text:'他人',id:'3'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'指定维修人',id:'4'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BMainterSure").click(function(){
		var mainterItemKeyObj=$HUI.keywords("#MainterItemDetail").getSelected();
		setElement("UserPattern",mainterItemKeyObj[0].id);
		BFind_Clicked();
		$('#BPopoverMainter').webuiPopover('hide');
	});
}
function BPopoverLoc_Clicked()
{
	$('#BPopoverLoc').webuiPopover({
		width:'auto',//can be set with  number
    	height:'auto',//can be set with  number
    	closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		url:'#LocItem',
		dismissible:false,  //Modified  By QW20210220 BUG:QW0092 测试需求:1743633
		onShow: function($element) {
			$HUI.keywords("#LocItemDetail").select(getElementValue("LocPattern"));
			if(getElementValue("LocPattern")=="3") $("#UseLoc").lookup("enable");
		}
    });
    $("#LocItemDetail").keywords({
	    	onClick:function(v){
			   if(v.id=="3")
			   {
				   	$("#UseLoc").lookup("enable");
				}else{
					$("#UseLoc").lookup("disable");
					setElement("UseLocDR","");
					setElement("UseLoc","");
				}
			},
	    	singleSelect:true,
			items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'本科',id:'2'},
							{text:'指定科室',id:'3'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BLocSure").click(function(){
		var locItemKeyObj=$HUI.keywords("#LocItemDetail").getSelected();
		setElement("LocPattern",locItemKeyObj[0].id);
		BFind_Clicked();
		$('#BPopoverLoc').webuiPopover('hide');
		});
}
function BPopoverDate_Clicked()
{
	$("#BPopoverDate").webuiPopover({
		width:'auto',//can be set with  number
    	height:'auto',//can be set with  number
		url:'#DateItem',
		closeable:true,//显示关闭按钮
    	padding:true,//内容填充
		dismissible:false, //Modified  By QW20210129 BUG:QW0089 测试需求:1743633
		onShow: function($element) {
			$HUI.keywords("#DateItemDetail").select(getElementValue("DatePattern"));
			if(getElementValue("DatePattern")=="8") 
			{
				disableElement("StartDate",false);
			   	disableElement("EndDate",false);
			}
		}
    });
    $("#DateItemDetail").keywords({
	    onClick:function(v){
		   if(v.id=="8")
		   {
			   	disableElement("StartDate",false);
			   	disableElement("EndDate",false);
			}else{
				disableElement("StartDate",true);
			   	disableElement("EndDate",true);
			   	setElement("StartDate","");
			   	setElement("EndDate","");
			}
		},
	    singleSelect:true,
		items:[
	        {
	            text:"筛选条件",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'不限',id:'1'},
							{text:'近3天',id:'2'},
							{text:'近7天',id:'3'},
							{text:'近两周',id:'4'},
							{text:'近1月',id:'5'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'超一周',id:'6'},
							{text:'超一月',id:'7'}
						]
	                },{
	                    text:'',
	                    type:"section", 
	                    items:[
							{text:'指定日期',id:'8'}
						]
	                }
	            ]
	        }
	    ]
	});
	$("#BDateSure").click(function(){
		var dateItemKeyObj=$HUI.keywords("#DateItemDetail").getSelected();
		setElement("DatePattern",dateItemKeyObj[0].id);
		BFind_Clicked();
		$('#BPopoverDate').webuiPopover('hide');
	});
}
function setSelectValue(vElementID,rowData)
{
	//Modefied by zc 2022-4-8 begin
	if (vElementID=="UseLoc")
	{
		setElement("UseLocDR",rowData.TRowID)
	}
	else if (vElementID=="MaintUser")
	{
		setElement("MaintUserDR",rowData.TRowID)
	}
	//Modefied by zc 2022-4-8 end
}

function clearData(vElementID)
{
	var DRElementName=vElementID.split("_")[0]
	setElement(DRElementName,"")
}
///Modefied by zc 2022-4-8 
///初始化右上角待办维修事件数据
function initMaintWaitListDataGrid()
{
 	///Modified By QW20200707 BUG:QW0069 end 
	var Toolbar="";
	var Columns=getCurColumnsInfo('EM.G.Queue.MaintRequest','','','')
	$HUI.datagrid("#tMaintWaitList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.LIBMessages",
	        	QueryName:"GetBussDataByCode",
				BussType:'31',
				GroupID:'',
				UserID:'',
				CurLocDR:'',
				EquipDR:''
		},
		border:false,  //add by zx 2019-06-14 样式改变,去掉边框 Bug ZX0067
	    fit:true,
	    //singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:Columns,
	    //toolbar:html,
	    rowStyler: function(index,row){
		    if (row.TEmergencyFlag=="Y")
		    {
				return 'background-color:#FF0000';
		    }
		},
		pagination:true,
		pageSize:7,
		pageNumber:1,
		pageList:[7,14,21,28,35]
	});
	$('#tMaintWaitList').datagrid('showColumn','TCheck');
}
///Modefied by zc 2022-4-8 
function refreshMaintTable()
{
	//$('#tMaintWaitList').datagrid('reload');	
}
//Modefied by zc 2022-4-8
function BFind_Clicked()
{
	var vData=GetLnk()
	$HUI.datagrid("#tMaintWaitList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.LIBMessages",
	        	QueryName:"GetBussDataByCode",
				BussType:'31',
				GroupID:'',
				UserID:'',
				CurLocDR:'',
				EquipDR:'',
				DatePattern:getElementValue("DatePattern"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				LocPattern:getElementValue("LocPattern"),
				UseLocDR:getElementValue("UseLocDR"),
				UserPattern:getElementValue("UserPattern"),
				UserDR:getElementValue("MaintUserDR"),
				vActionDR:'',
				vData:vData
		}})
	jQuery('#tMaintWaitList').datagrid('unselectAll') 
}
//Modefied by zc 2022-4-8
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^ActionPattern="+getElementValue("ActionPattern");
	lnk=lnk+"^ManageTypeID="+getElementValue("ManageTypeID");
	lnk=lnk+"^EmergencyPattern="+getElementValue("EmergencyPattern");
	lnk=lnk+"^ReminderPattern="+getElementValue("ReminderPattern");
	return lnk
}
//Modefied by zc 2022-4-8
function BReminder_Clicked()
{
	var checkedItems = $('#tMaintWaitList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TBussID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','提示',"未选择维修单！")
		return false;
	}
	var length=selectItems.length;
	var str=""
	var InfoStr=""
	for(i=0;i<selectItems.length;i++)//开始循环
	{
		if (str=="")
		{
			str=selectItems[i];//循环赋值	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","ReminderBuss",'31',str,curUserID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','提示',"催单失败!"+jsonData.Data)
	}
	else
	{
		messageShow('popover','success','提示','催单成功！','','','');
		jQuery('#tMaintWaitList').datagrid('unselectAll') 
		jQuery('#tMaintWaitList').datagrid('reload') 
	}
}