jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

var GlobalObj = {
	ID : "0",
	Job: ""
}

function initDocument()
{
	GlobalObj.Job=getElementValue("Job");	
	defindTitleStyle();
	initDHCEQEquipList();			
	initTree();  
	jQuery('#BFind').on("click", initTree);
}
function initTree()
{
	var EquipeCatTree =tkMakeServerCall("web.DHCEQ.Plat.LIBTree","GetServiceItemByEquipID",getElementValue("EquipDR"),getElementValue("ServiceItem"))
	$('#tDHCEQCEquipCatTree').tree({
		data:JSON.parse(EquipeCatTree),
		onClick: function (node) {
			NodeClickHandler(node)
		},
		lines:true,
	})
}
function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBTree",   
	        QueryName:"GetPatientList",
	        ServiceItemDR:"",
	        EquipDR:getElementValue("EquipDR")
	    },
	    border:false,
		striped:true,
	    cache:false,
	    //singleSelect:true,
		//fitColumns:true,
		pagination:true,
    	columns:[[
    		{
	    		field:"TRowID",
	    		title:"TRowID",
	    		hidden:true
	    	},
	    	{
	    		field:"PatientName",
	    		title:"患者姓名"
	    	},
	    	{
	    		field:"PatientAge",
	    		title:"患者年龄"
	    	},
	    	{
	    		field:"PatientSex",
	    		title:"患者性别",
	    		
	    	},
	    	{
	    		field:"UseDate",
	    		title:"使用日期",
	    		
	    	},
	    	{
	    		field:"PatientWorkLoadNum",
	    		title:"工作量",
	    		
	    	},
	    	{
	    		field:"PatientWorkLoadFee",
	    		title:"费用",
	    		
	    	},

    	]], 
		fit:true,
    	pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onDblClickRow:function(rowIndex, rowData)
		{	
		},
		onLoadSuccess: function (data) {
		},
		onLoadError:function(data){
			alert(JSON.stringify(data))
		}
});
}

function NodeClick(id)
{
	var nod=new Node(id);	
	NodeClickHandler(nod);
}

function NodeClickHandler(nod)
{
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBTree",		
	        QueryName:"GetPatientList",
	        ServiceItemDR:nod.id,
	        EquipDR:getElementValue("EquipDR")
	    }, 
	     onLoadSuccess: function (data) {
		}
	    });
	    
	 GlobalObj.ID=nod.id  
	    
}
