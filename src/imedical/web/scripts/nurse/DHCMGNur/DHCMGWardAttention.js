/**
 * @author Qse
 */
var col=new Array();
var dataset=new Array();
var datafield=new Array();
var selections ;
var CurrAdm="";
var CurrGrid;
var CurrRowIndex;

cspRunServerMethod(GetHead,"GetColmHead",AttTyp);
var colM=new Ext.grid.ColumnModel(col);
var rightClick = new Ext.menu.Menu(  {
                id : 'rightClickCont',
                items : [  {
                    id:'rMenu1',
                    text : '病历',
                    handler:rMenuFn1
                },  {
                    id:'rMenu2',
                    text : '护理病历'
                    //handler:rMenu2
                }]
            });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          CurrGrid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
 function rowClickFn(grid, rowIndex, e)  {
              //alert('你单击了' + rowIndex);
            }
function rMenuFn1()
{
     selections = CurrGrid.getSelectionModel().getSelections();
     if (selections[0]){
	 	CurrAdm=selections[0].get("Adm");
	 	window.open("dhceprredirect.csp?EpisodeID="+CurrAdm,"htm",'toolbar=no,location=no,directories=no,resizable=yes');
	 }
}

function GetColmHead(a1,a2)
{   
    col.push({
		header: a1,
		dataIndex: a2,
		sortable: true
	}
	)
	datafield.push(a2);
}
var attenitm=new Array();
cspRunServerMethod(getattentionData,AttTyp,WardTree,AttItem,"add");


function add(a1, a2){
	attenitm.push({
		xtype:'panel',
		id: a1,
		title: a2,
		region:'center',
		height:1000,
		layout:'fit',
		closable:false,
		items:[getgriddata(a1)]
	})
}
var subttab=new Ext.TabPanel({
	activeTab : 0,//
   	autoTabs: true,
   	//resizeTabs:true, 
   	height:560,
   	width:700,
   	enableTabScroll:true,
 	items:attenitm
});

Ext.onReady(function(){ 
new Ext.Viewport({
	enableTabScroll:true,
	items:subttab
})
subttab.setActiveTab(3);
});

 
function adddata(a,b,c,d,e,f,g)
{
	dataset.push({
		BedCode: a,
		PatName: b,
		admdate:c,
		Sex: d,
		Age: e,
		Diag: f,
		Adm:g
	});
}
function getgriddata(itmid)
{
 	dataset=new Array();
 	cspRunServerMethod(getAttenionDetail,WardTree,itmid,"adddata");
 	var store=new Ext.data.JsonStore({data:dataset,fields:datafield});

 	var grid = new Ext.grid.GridPanel({
  		title:"",
  		height:200,
  		width:600, 
 		cm:colM,
		store:store,
 		autoExpandColumn:2
	}); 
	grid.addListener('rowcontextmenu', rightClickFn);
	grid.addListener('rowclick', rowClickFn);
	grid.addListener('rowdblclick', rowClickFn);
	return grid;
}

  