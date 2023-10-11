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
	var EquipeCatTree =tkMakeServerCall("web.DHCEQ.Plat.LIBTree","GetBaShowListStr",getElementValue("MasterItem"))
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
	        QueryName:"GetEquipList",
	        ItemDR:"",
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
	    		hidden:'true'
	    	},
	    	{
	    		field:"TName",
	    		title:"�豸����"
	    	},
	    	{
	    		field:"TNo",
	    		title:"�豸���"
	    	},
	    	{
	    		field:"TModel",
	    		title:"����"
	    	},
	    	{
	    		field:"TProvider",
	    		title:"��Ӧ��"
	    	},
	    	{
	    		field:"TManuFactory",
	    		title:"��������"
	    	},
	    	{
	    		field:"TOpenCheckDate",
	    		title:"��������"
	    	},
	    	{
	    		field:"TStartDate",
	    		title:"��������"
	    	},
	    	{
	    		field:"TUseLoc",
	    		title:"ʹ�ÿ���"
		    },
	    	{
	    		field:"TWorkLoadNum",
	    		title:"������"
	    	}
    	]], 
		fit:true,
    	pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60], 
		onDblClickRow:function(rowIndex, rowData)
		{	
			if (rowData.TRowID!=""){
				var str="dhceq.ba.equipserviceitem.csp?&EquipDR="+rowData.TRowID+"&ReadOnly=1";  //modify by mwz 20210415 MWZ0046
				showWindow(str,"��������ϸ����","","","icon-w-paper","","","","large")   
			}
		},
		onLoadSuccess: function (data) {
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
	if(nod.click=='true'){
		$HUI.datagrid("#tDHCEQEquipList",{   
		    url:$URL, 
		    queryParams:{
		        ClassName:"web.DHCEQ.Plat.LIBTree",		
		        QueryName:"GetEquipList",
		       	ItemDR:nod.id,
		    }, 
		    onLoadSuccess: function (data) {
			},
			onLoadError:function (data) {
				alert(JSON.stringify(data))
			}
		    });
		    
		 GlobalObj.ID=nod.id  
		    
	}
}