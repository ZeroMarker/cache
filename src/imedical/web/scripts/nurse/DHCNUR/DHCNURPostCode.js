var Height = document.body.clientHeight-2;
var Width = document.body.clientWidth-2;
var REC = new Array();
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);

var wardcombo=new Ext.form.ComboBox({
	id:'wardcombo',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
		}),
		baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'}
	}),
	listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('comboward').lastQuery;
			},
			focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]);
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
		},
	//tabIndex:'0',
	listWidth:200,
	//height:18,
	width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 1000,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...'
});
function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp("mygridpl");
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	addTool();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.on('rowdblclick',rowdblclick);
	mygrid.on('rowclick',rowclick);
	Ext.getCmp('updateBtn').disable();
	mygrid.store.on('beforeload',function(){
		var ValidCheck=Ext.getCmp('ValidCheck').getValue();
		var wardid=wardcombo.getValue();
		var parr=wardid+"^"+(ValidCheck?"Y":"N");
		mygrid.store.baseParams.parr=parr;
	});
	findRec();
	mygrid.store.on('load',function(tstore){
		tstore.each(function(r){
			var row=tstore.indexOf(r);
			if(r.get('PostValid')=="Y"){
				mygrid.getView().getCell(row,0).style.backgroundImage="url('../images/uiimages/ok.png')";
				mygrid.getView().getCell(row,0).style.backgroundRepeat='no-repeat';
				mygrid.getView().getCell(row,0).style.backgroundPosition='center';
			}else if(r.get('PostValid')=="N"){
				mygrid.getView().getCell(row,0).style.backgroundImage="url('../images/uiimages/cancel.png')";
				mygrid.getView().getCell(row,0).style.backgroundRepeat='no-repeat';
				mygrid.getView().getCell(row,0).style.backgroundPosition='center';
			}
		})
	});
	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'PostValid'){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}
function addTool()
{
	var mygrid = Ext.getCmp("mygrid");
	var tobar = mygrid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but2=Ext.getCmp("mygridbut2");
	but2.hide();
	tobar.addItem("-");
	tobar.addItem("病区",wardcombo);
	if(secGrpFlag=="nurse"||secGrpFlag=="nurhead") 
	{
		wardcombo.store.load({
			params:{start:0,limit:10000},
			callback:function(){
				wardcombo.setValue(session["LOGON.CTLOCID"]);
			}
		}); 
		wardcombo.disable();
	}
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'ValidCheck',boxLabel:'显示作废'}));
	tobar.addItem("-");
	tobar.addButton({
		id:'findbtn',
		text:'查询',
		icon:'../images/uiimages/search.png',
		handler:function(){
			findRec2();
			Ext.getCmp('addBtn').enable();
			Ext.getCmp('updateBtn').disable();
		}
	});
	tobar.addItem("-");
	tobar.addButton({id:'validbtn',text:'作废',icon:'../images/uiimages/cancel.png',handler:setMarks});
	tobar.addItem("-");
	tobar.addButton({id:'cvalidbtn',text:'撤销作废',icon:'../images/uiimages/undo.png',handler:setMarks});
	tobar.addItem('-');tobar.addItem('序号',{xtype:'textfield',id:'sortorder',width:50,maskRe:/^\d+$/});
	tobar.addItem('-');tobar.addButton({id:'changebtn',text:'保存',icon:'../images/uiimages/filesave.png',handler:changeRec});
	//tobar.addItem("-");tobar.addButton({id:'distrupost',text:'分配到病区',handler:distruPost});
	var tobar2=new Ext.Toolbar();
	tobar2.addItem("-");tobar2.addItem("代码",new Ext.form.TextField({id:'PostCode',width:128}));
	tobar2.addItem("-");tobar2.addItem("名称",new Ext.form.TextField({id:'PostDesc',width:100}));
	tobar2.addItem("-");tobar2.addItem("人数",new Ext.form.TextField({id:'PostPerNum',width:30,value:1,regex:/\d+$/}));
	tobar2.addItem("-");tobar2.addItem("小时数",new Ext.form.TextField({id:'PostHours',width:30,value:8,regex:/^((\d)|(1\d)|(2[0-4]))$/}));
	tobar2.addItem("-");tobar2.addItem("包含夜班小时",new Ext.form.TextField({id:'PostNightHours',width:30,value:0,regex:/\d+$/,listeners:{
		blur:function(t,e){var tvalue=t.getValue(); var posthours=Ext.getCmp('PostHours').getValue(); if(parseInt(tvalue)>parseInt(posthours)){alert('包含夜班小时不能大于小时数！'); t.setValue(0);}}}}));
	tobar2.addItem("-");tobar2.addItem("开始时间",new Ext.form.TimeField({id:'PostStTime',value:'08:00',format:'H:i',width:60,increment:30}));
	tobar2.addItem("-");tobar2.addItem("结束时间",new Ext.form.TimeField({id:'PostEndTime',value:'17:00',format:'H:i',width:60,increment:30}))
	var tobar3=new Ext.Toolbar();
	tobar3.addItem("-");
	tobar3.addItem('班次分类',new Ext.form.ComboBox({
		id:'PostType',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
			reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
				fields:[{'name':'Desc','mapping':'Desc'},{'name':'rw','mapping':'rw'}]
			}),
			baseParams:{className:'web.DHCNurRosterComm',methodName:'FindCommDicSubData',type:'RecQuery'},
			listeners:{beforeload:function(tstore,e){tstore.baseParams.parr="班次分类";}}
		}),
		//tabIndex:'0',
		listWidth:200,
		//height:18,
		width:100,xtype : 'combo',editable:false,
		displayField : 'Desc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
		minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
	}));
	tobar3.addItem("-");
	tobar3.addItem('岗位分类',new Ext.form.ComboBox({
		id:'PostWorkType',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
			reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
				fields:[{'name':'Desc','mapping':'Desc'},{'name':'rw','mapping':'rw'}]
			}),
			baseParams:{className:'web.DHCNurRosterComm',methodName:'FindCommDicSubData',type:'RecQuery'},
			listeners:{beforeload:function(tstore,e){tstore.baseParams.parr="岗位分类";}}
		}),
		//tabIndex:'0',
		listWidth:200,
		//height:18,
		width:100,xtype : 'combo',editable:false,
		displayField : 'Desc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
		minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
	}));
	tobar3.addItem("-");tobar3.addItem(new Ext.form.Checkbox({id:'PostHoliday',boxLabel:'节假日'}));
	tobar3.addItem("-");tobar3.addItem("备注",new Ext.form.TextField({id:'PostRemarks',width:200}));
	tobar3.addItem("-");tobar3.addButton({id:'addBtn',text:'增加',icon:'../images/uiimages/edit_add.png',handler:saveRec});
	tobar3.addItem("-");tobar3.addButton({id:'updateBtn',text:'修改',icon:'../images/uiimages/pencil.png',handler:updateRec});
	tobar3.addItem("-");tobar3.addButton({id:'cancleBtn',text:'清屏',icon:'../images/uiimages/clearscreen.png',handler:clearRec});
	tobar2.render(mygrid.tbar);
	tobar3.render(mygrid.tbar);
	tobar.doLayout();
}

function CheckValue()
{
	var wardid=wardcombo.getValue();
	if(wardid==""){ Ext.Msg.alert('提示',"请选择病区！"); return false; }
	var postcode=Ext.getCmp('PostCode').getValue();
	if(postcode==""){  Ext.Msg.alert('提示','代码不能为空！'); return false; }
	var postdesc=Ext.getCmp('PostDesc').getValue();
	if(postdesc==""){  Ext.Msg.alert('提示','名称不能为空！'); return false; }
	var postpernum=Ext.getCmp('PostPerNum').getValue();
	if(postpernum==""){  Ext.Msg.alert('提示','人数不能为空！'); return false; }
	var posthours=Ext.getCmp('PostHours').getValue();
	if(posthours==""){  Ext.Msg.alert('提示','小时数不能为空！'); return false; }
	var postnighthours=Ext.getCmp('PostNightHours').getValue();
	if(postnighthours==""){  Ext.Msg.alert('提示','包含夜班小时不能为空！'); return false; }
	var poststtime=Ext.getCmp('PostStTime').getValue();
	if(poststtime==""){  Ext.Msg.alert('提示','开始时间不能为空！'); return false; }
	var postendtime=Ext.getCmp('PostEndTime').getValue();
	if(postendtime==""){  Ext.Msg.alert('提示','结束时间不能为空！'); return false; }
	var posttype=Ext.getCmp('PostType').getValue();
	if(posttype==""){  Ext.Msg.alert('提示','班次分类不能为空！'); return false; }
	var postworktype=Ext.getCmp('PostWorkType').getValue();
	if(postworktype==""){  Ext.Msg.alert('提示','岗位分类不能为空！'); return false; }
	return true;
}

function GetValue()
{
	var parr="";
	var postward=wardcombo.getValue();
	parr=parr+"PostWard|"+postward;
	var postcode=Ext.getCmp('PostCode').getValue();
	parr=parr+"^PostCode|"+postcode;
	var postdesc=Ext.getCmp('PostDesc').getValue();
	parr=parr+"^PostDesc|"+postdesc;
	var postpernum=Ext.getCmp('PostPerNum').getValue();
	parr=parr+"^PostPerNum|"+postpernum;
	var posthours=Ext.getCmp('PostHours').getValue();
	parr=parr+"^PostHours|"+posthours;
	var postnighthours=Ext.getCmp('PostNightHours').getValue();
	parr=parr+"^PostNightHours|"+postnighthours;
	var poststtime=Ext.getCmp('PostStTime').getValue();
	parr=parr+"^PostStTime|"+poststtime;
	var postendtime=Ext.getCmp('PostEndTime').getValue();
	parr=parr+"^PostEndTime|"+postendtime;
	var posttype=Ext.getCmp('PostType').getValue();
	parr=parr+"^PostType|"+posttype;
	var postworktype=Ext.getCmp('PostWorkType').getValue();
	parr=parr+"^PostWorkType|"+postworktype;
	var postholiday=Ext.getCmp('PostHoliday').getValue();
	parr=parr+"^PostHoliday|"+(postholiday==true?"Y":"N");
	var postremarks=Ext.getCmp('PostRemarks').getValue();
	parr=parr+"^PostRemarks|"+postremarks
	return parr;
}

function saveRec()
{
	var wardid=wardcombo.getValue();
	if(wardid=="") 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	if(CheckValue())
	{
		var postcode=Ext.getCmp('PostCode').getValue();
		var parr=wardid+"^"+postcode;
		var ret=tkMakeServerCall("DHCMGNUR.MgNurPost","CheckRepeat",parr);
		if(ret!=0){ alert(ret); return false; }
		var parr=GetValue();
		var a=tkMakeServerCall("DHCMGNUR.MgNurPost","Save",parr);
		//alert(a);
		findRec();
	}
}

function updateRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		Ext.Msg.alert('提示','请选择一行记录进行修改操作！');
		return;
	}
	var row=mygrid.store.indexOf(selections[0]);
	var wardid=wardcombo.getValue();
	if(wardid=="")
 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	if(CheckValue())
	{
		var rw=selections[0].get('rw');
		var parr=GetValue()+"^ID|"+rw;
		var postcode=Ext.getCmp('PostCode').getValue();
		var ret=tkMakeServerCall("DHCMGNUR.MgNurPost","CheckRepeat",wardid+"^"+postcode+"^"+rw);
		if(ret!=0){ alert(ret); return false; }
		var a=tkMakeServerCall("DHCMGNUR.MgNurPost","Save",parr);
		findRec();
		mygrid.getSelectionModel().selectRow(row);
	}
	Ext.getCmp('addBtn').enable();
	Ext.getCmp('updateBtn').disable();
}
function clearRec(){
	Ext.getCmp('PostCode').setValue('');
	Ext.getCmp('PostDesc').setValue('');
	Ext.getCmp('PostPerNum').setValue(1);
	Ext.getCmp('PostHours').setValue(8);
	Ext.getCmp('PostNightHours').setValue(0);
	Ext.getCmp('PostStTime').setValue('08:00');
	Ext.getCmp('PostEndTime').setValue('17:00');
	//Ext.getCmp('PostType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostType').setRawValue('白班');}});
	//Ext.getCmp('PostWorkType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostWorkType').setRawValue('病房');}});
	Ext.getCmp('PostType').setValue('');
	Ext.getCmp('PostWorkType').setValue('');
	Ext.getCmp('PostHoliday').setValue(false);
	Ext.getCmp('sortorder').setValue('');
	Ext.getCmp('addBtn').enable();
	Ext.getCmp('updateBtn').disable();
}
function findRec()
{
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({params:{start:0,limit:10}});
}
function findRec2()
{
	var wardid=wardcombo.getValue();
	if(wardid=="")
 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({params:{start:0,limit:10}});
}
function SplitStr(Str)
{
	var array=new Array();
	var StrArr=Str.split("^");
	for(i=0;i<StrArr.length;i++)
	{
		var StrArr2=StrArr[i].split("|");
		array[StrArr2[0]]=StrArr2[1];
	}
	return array;
}

function rowdblclick(grid,row,e)
{
	var clickrow=grid.store.getAt(row);
	var postid=clickrow.get('rw');
	var postValid=clickrow.get('PostValid');
	if(postValid=="N"){
		Ext.Msg.alert('提示','作废代码不能修改！');
		return;	
	}
	var ret=tkMakeServerCall("DHCMGNUR.MgNurPost","getValue",postid);
	var array=SplitStr(ret);
	wardcombo.store.load({params:{start:0,limit:1000},callback:function(){wardcombo.setValue(array['PostWard']);}})
	Ext.getCmp('PostCode').setValue(array['PostCode']);
	Ext.getCmp('PostDesc').setValue(array['PostDesc']);
	Ext.getCmp('PostPerNum').setValue(array['PostPerNum']);
	Ext.getCmp('PostHours').setValue(array['PostHours']);
	Ext.getCmp('PostNightHours').setValue(array['PostNightHours']);
	Ext.getCmp('PostStTime').setValue(array['PostStTime']);
	Ext.getCmp('PostEndTime').setValue(array['PostEndTime']);
	Ext.getCmp('PostType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostType').setValue(array['PostType']);}});
	Ext.getCmp('PostWorkType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostWorkType').setValue(array['PostWorkType']);}});
	if(array['PostHoliday']=="Y") Ext.getCmp('PostHoliday').setValue(true);
	else Ext.getCmp('PostHoliday').setValue(false);
	Ext.getCmp('PostRemarks').setValue(array['Remarks']);
	Ext.getCmp('sortorder').setValue(array['PostOrder'])
	Ext.getCmp('updateBtn').enable();
	Ext.getCmp('addBtn').disable();
}

function rowclick(grid,row,e)
{
	var clickrow=grid.store.getAt(row);
	var postvalid=clickrow.get('PostValid');
	if(postvalid=="N")
	{ 
		//Ext.getCmp('distrupost').disable();
		Ext.getCmp('validbtn').disable();
		Ext.getCmp('cvalidbtn').enable();
	}
	if(postvalid=="Y")
	{
		//Ext.getCmp('distrupost').enable();
		Ext.getCmp('validbtn').enable();
		Ext.getCmp('cvalidbtn').disable();
	}
}
function setMarks(b,e)
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		Ext.Msg.alert('提示',"请选择一条记录");
		return;
	}
	var rw=selections[0].get('rw');
	var valid="N";
	if(b.id=="cvalidbtn") valid="Y";
	var parr=rw+"^"+valid;
	if(valid=="N"){
		if (confirm('确定作废选中的项？')) {
			var a=tkMakeServerCall("DHCMGNUR.MgNurPost","SetValid",parr);
		Ext.Msg.alert('提示',a);
		findRec();
		}
	}
    if(valid=="Y"){
		if (confirm('确定撤销作废选中的项？')) {
			var a=tkMakeServerCall("DHCMGNUR.MgNurPost","SetValid",parr);
		Ext.Msg.alert('提示',a);
		findRec();
		}
	}	
}

function distruPost()
{
	var wardid=wardcombo.getValue();
	if(wardid==""){	Ext.Msg.alert('提示',"请选择病区!");	return; }
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0){ Ext.Msg.alert('提示','请至少选择一条岗位记录！'); return; }
	var parr="";
	for(var i=0;i<selections.length;i++)
	{
		var rw=selections[i].get('rw');
		if(parr=="") parr="PostWard|"+wardid+"^PostID|"+rw;
		else  parr=parr+"@"+"PostWard|"+wardid+"^PostID|"+rw;
	}
	if(parr!="")
	{
		var ret=tkMakeServerCall("DHCMGNUR.MgNurWardPost","MultSave",parr);
	}
}

function changeRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		Ext.Msg.alert('提示',"请选择一条记录");
		return;
	}
	var rw=selections[0].get('rw');
	var order=Ext.getCmp('sortorder').getValue();
	if(order==""){ Ext.Msg.alert('提示',"序号不能为空！"); return;}
	var parr=rw+"^"+order;
	var a=tkMakeServerCall("DHCMGNUR.MgNurPost","ChangeOrder",parr);
	findRec();
}