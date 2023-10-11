var editFlag = true;
function BodyLoadHandler()
{
	setsize("mygridpl","gform","mygrid");
	grid=Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for (var i = 0; i < len; i++) {
		if (grid.getColumnModel().getDataIndex(i) == 'rw') {
			grid.getColumnModel().setHidden(i, true);
		}
	}
  grid.setTitle("转科查询");
  var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	tobar.addItem("开始日期：",{xtype:'datefield',id:'mygridstdate',value:diffDate(new Date(),-3)},"-",
	    					"结束日期：",{xtype:'datefield',id:'mygridenddate',value:diffDate(new Date(),1)},"-"
							,{xtype:'button',width:"50",text:'查询',handler:find,icon:'../images/uiimages/search.png'},"-"
							,{xtype:'button',width:"50",text:'取消转移',handler:CancelExchange,icon:'../images/uiimages/blue_arrow.png'},"-"
							);
	var botTobar=grid.getBottomToolbar();
	botTobar.hide();
	grid.store.on("beforeLoad",BeforeLoad);
	find();
	window.onresize=function(){
		window.location.reload();
	};
}
function BeforeLoad()
{
	var StDate = Ext.getCmp("mygridstdate");
	var Enddate = Ext.getCmp("mygridenddate");
	grid.store.baseParams.DateS=StDate.value;
	grid.store.baseParams.DateE=Enddate.value;
	grid.store.baseParams.WardDr=session['LOGON.WARDID'];
}

function find()
{
	grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:1000}});
}

Ext.onReady(function(){})
function CancelExchange(){
	    var grid=Ext.getCmp("mygrid");
		var objRow=grid.getSelectionModel().getSelections();
		if (objRow.length == 0) {
			return;
	    }
		else {
			var Status=objRow[0].get("Status");	
			var rw=objRow[0].get("rw");	
			if(Status!="申请"){
				alert("非申请状态不可取消转移！");
				return;
			}
			var ret=tkMakeServerCall("Nur.DHCNurTransAudit","CancelTrans",rw,session['LOGON.USERID']);
						ret=ret.split("@");
						//alert(ret)
						if(ret[0]!="0"){
							alert(ret[1]);
						}else{
							
							alert("取消转移成功!")
							find();
							return;
						}
		}
}
