//var LabLoc = new Ext.form.ComboBox({id:'LabLoc',width:100,store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}), 
//	displayField:'desc',valueField:'id',allowBlank: true,	mode:'local',	value:'',forceSelection : true,triggerAction:'all'});
var TransId = document.getElementById('TransId').value; //Ext.getCmp('TransId');
var TransNo = document.getElementById('TransNo').value; //Ext.getCmp('TransNo');
var EditFlag = document.getElementById('EditFlag').value;
function BodyLoadHandler()
{
	setsize("mygridpl","gform","mygrid");
	grid=Ext.getCmp('mygrid');
    grid.setTitle("标本出科明细");
    var tobar=grid.getTopToolbar();
	tobar.addItem("标本号:",{xtype:'textfield',width:'150',id:'labNo'},
								"-",{xtype:'button',width:"50",text:'增加',handler:addLab,icon:'../images/uiimages/edit_add.png'},
								"-",{xtype:'button',width:"50",text:'删除',handler:DeAll,icon:'../images/uiimages/edit_remove.png'}
							);
	var labNo=Ext.getCmp("labNo");//focus(false,1000);
	labNo.focus(true,100);
	labNo.on('specialkey', cmbkey);
	if(EditFlag=="false"){
		tobar.setVisible(false);
		labNo.hide();
	}
    var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	grid.store.on("beforeLoad",BeforeLoad);
	find();
	grid.getBottomToolbar().hide();//Ext.get(window).on('beforeunload',function(e){return (window.event.returnValue=e.returnValue='确认离开当前页面？！！')});
	window.onresize=function(){
		window.location.reload();
	}
}

function BeforeLoad()
{
	grid.store.baseParams.carryId=TransId;
}
function cmbkey(field, e) {
	if (e.getKey() == Ext.EventObject.ENTER) {
          addLab();
	}
}
function addLab(){
	var labNo=Ext.getCmp("labNo").getValue();
	//var TransNo = Ext.getCmp('TransNo').getValue();
	//alert("TransNo:"+TransNo);
	var ret=tkMakeServerCall("Nur.NurseCarry","LabnoRelateCarryNo",labNo,TransNo,session['LOGON.CTLOCID']);
	ret=ret.split("@");
	if(ret[0]!="0"){
		alert(ret[1]);
		var labNo=Ext.getCmp("labNo");//focus(false,1000);
		labNo.focus(true,100);
		labNo.setValue('');
		return;
		}
	else{
		find();
		opener.find();
		return;
		}
}
function find()
{
	grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:1000}});
} 
function DeAll()
{
	var mygrid = Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	//var store = mygrid.store;	
	var len = rowObj.length;
	if (len < 1) {
		alert("请选择需要删除的数据!")
		return;
	} else {
		Ext.Msg.confirm('系统提示','确定要删除吗？',
		  function(btn){
			if(btn=='yes'){
				for (var i = 0; i < len; i++) {
					//alert(store.getAt(i).get('par'))
					var labNo = rowObj[i].get("CarryLabNo");
					var TransNo=rowObj[i].get("CarryNo");
					if((labNo!="")&&(TransNo!="")){
						deleteLabNew(labNo,TransNo);
					}
				}
				find();
				opener.find();
			}
		},this);
	}

}
function deleteLabNew(labNoNew,TransNoNew){
			var ret=tkMakeServerCall("Nur.NurseCarry","DtLnoRelteCNo",labNoNew,TransNoNew);
			ret=ret.split("@");
			if(ret[0]!="0"){alert(ret[1]);}
			//else{find();opener.find();}
}
function deleteLab(){
		var grid=Ext.getCmp("mygrid");
		var objRow=grid.getSelectionModel().getSelections();
		if (objRow.length == 0) {
			return;
		}
		else {
			var labNo = objRow[0].get("CarryLabNo");
			var TransNo=objRow[0].get("CarryNo");
			var ret=tkMakeServerCall("Nur.NurseCarry","DtLnoRelteCNo",labNo,TransNo);
			ret=ret.split("@");
			if(ret[0]!="0"){alert(ret[1]);}
			else{find();opener.find();}
	}
	
}