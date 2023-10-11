/**
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/
var grid;
function gethead()
{
		var GetHead=document.getElementById('GetHead');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		return hh[0];
		//debugger;
}
var modeldata=[['DHCNUR1','外科护理记录'],['DHCNUR2','危重护理记录'],['DHCNUR4','产科护理记录'],['DHCNUR5','外科护理记录(沈阳)']];
var store = new Ext.data.SimpleStore({
    fields: ['abbr', 'state'],
    data : modeldata
});
function BodyLoadHandler(){
		setsize("mygridpl","gform","mygrid");
		//fm.doLayout(); 
		var but1=Ext.getCmp("mygridbut1");
		but1.hide();
		var but=Ext.getCmp("mygridbut2");
		but.setText("删除");
		but.on('click',save);
 
		grid=Ext.getCmp('mygrid');
		grid.setTitle(gethead());
		var combo = new Ext.form.ComboBox({
		  id:'mygridmodel',
			//hiddenName : 'abbr',
		  store: store,
		  valueField: 'abbr',
		  displayField:'state',
		  typeAhead: true,
		  mode: 'local',
		  triggerAction: 'all',
		  emptyText:'按模版查询...',
		  selectOnFocus:true,
			width:120
		});
		var mydate=new Date();
		var tobar=grid.getTopToolbar();
		tobar.addItem(
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'mygridstdate',
				value:(diffDate(new Date(),0))
			},
			{
				xtype:'timefield',
				width:100,
				format: 'H:i',
				value:'0:00',
				id:'mygridsttime'
			},
			{
				xtype:'datefield',
				format: 'Y-m-d',
				id:'mygridenddate',
				value:diffDate(new Date(),1)
			},
			{
				xtype:'timefield',
				width:100,
				id:'mygridendtime',
				format: 'H:i',
				value:'0:00'
			},
			{
				xtype:'checkbox',
				id:'mygriddateflag',
				boxLabel: '按时间查询'
			},combo
		);
		tobar.addButton(
			{
				className: 'new-topic-button',
				text: "查询",
				handler:find,
				id:'mygridSch'
			}
		);
	//tobar.render(grid.tbar);
	tobar.doLayout();
}
var REC=new Array();
function find(){
	REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var objDateFlag = Ext.getCmp("mygriddateflag");
	var DateFlag="N";
	if (objDateFlag.checked==true) DateFlag="Y";
	var Model = Ext.getCmp("mygridmodel");
	//alert(Ext.get('abbr').dom.value);
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^"+ DateFlag + "^"+ Model.getValue();
	//alert(parr);
	//debugger;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurseRecordComm:GetChangeLableRec", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}

function AddRec(a,b,c,d,e,f,g,h,i,j)
{
	//debugger;
	REC.push({
		LableId:a,
		LableDesc:b,
		MoudleName:c,
		CareDate:d,
		CareTime:e,
		RecUser:f,
		RecDate:g,
		RecTime:h,
		NurRecId:i,
		rw:j
	});
}


function save()
{
 	var grid=Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var LableRecDelete=document.getElementById('LableRecDelete');
	if(len < 1)
	{
		return;
	}
	else
	{
		var rw = rowObj[0].get("rw");
		var parr=rw+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
		//alert(parr)
		var ee=cspRunServerMethod(LableRecDelete.value,parr);
		if (ee!="0")
		{
			alert(ee);
			return;	
		}
	}
	find();
} 
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
}
function diffDate(val,addday){
	var year=val.getFullYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };









  


 
