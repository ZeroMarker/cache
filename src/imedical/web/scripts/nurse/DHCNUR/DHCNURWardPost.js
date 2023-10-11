var fheight = document.body.clientHeight-5;
var fwidth = document.body.clientWidth-3;

//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);

var wardcombo=new Ext.form.ComboBox({
	id:'wardcombo',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
		}),
		baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'},
		listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('wardcombo').lastQuery;
			}
		}
	}),
	tabIndex:'0',listWidth:'200',height:18,width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...'
});

function BodyLoadHandler()
{
	var postgridpl=Ext.getCmp("postgridpl");
	postgridpl.setHeight(fheight);
	postgridpl.setWidth(fwidth);
	postgridpl.setPosition(0,0);
	//Ext.getCmp('postgrid').on('rowdblclick',setRec);
	addTool();
	var postgrid=Ext.getCmp('postgrid');
	postgrid.store.on('beforeload',function(){
		var wardid=wardcombo.getValue();
		var chkvalue=Ext.getCmp('ValidCheck').getValue()?"Y":"N";
		postgrid.store.baseParams.parr=wardid+"^"+chkvalue;
	});
	postgrid.on('rowdblclick',rowdblclick);
}
function addTool()
{
	var postgrid = Ext.getCmp("postgrid");
	var tobar = postgrid.getTopToolbar();
	Ext.getCmp("postgridbut1").hide();
	Ext.getCmp("postgridbut2").hide();
	tobar.addItem("-");tobar.addItem('病区',wardcombo)
	if(secGrpFlag=="nurhead")
	{
		var parr = session['LOGON.CTLOCID'];
		wardcombo.store.load({param:{start:0,limit:1000},callback:function(){wardcombo.setValue(parr)}});;
		wardcombo.disable();
		findRec();
	}
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'ValidCheck',boxLabel:'显示作废'}));
	tobar.addItem('-');tobar.addButton({id:'findbtn',text:'查询',handler:findRec});
	if((secGrpFlag=="hlb")||(secGrpFlag=="hlbzr")||(secGrpFlag=="demo"))
	{
	//	tobar.addItem('-');tobar.addButton({id:'addbtn',text:'病区岗位增加',handler:addRec});
		tobar.addItem('-');tobar.addButton({id:'statusbtn',text:'作废',handler:statusRec});
		tobar.addItem('-');tobar.addButton({id:'unstatusbtn',text:'撤销作废',handler:statusRec});
	}
	tobar.addItem('-');tobar.addItem('序号:',new Ext.form.TextField({id:'OrderText',width:50,maskRe:/^\d+$/}));
	tobar.addItem('-');tobar.addButton({id:'changebtn',text:'保存',handler:changeRec});
	if((secGrpFlag=="hlb")||(secGrpFlag=="hlbzr")||(secGrpFlag=="demo"))
	{
	var tobar2=new Ext.Toolbar();
	tobar2.addItem("-");tobar2.addItem("代码:",new Ext.form.TextField({id:'PostCode',width:100}));
	tobar2.addItem("-");tobar2.addItem("名称:",new Ext.form.TextField({id:'PostDesc',width:100}));
	tobar2.addItem("-");tobar2.addItem("人数:",new Ext.form.TextField({id:'PostPerNum',width:30,value:'',regex:/\d+$/}));
	tobar2.addItem("-");tobar2.addItem("小时数:",new Ext.form.TextField({id:'PostHours',width:30,value:'',regex:/^((\d)|(1\d)|(2[0-4]))$/}));
	tobar2.addItem("-");tobar2.addItem("包含夜班小时:",new Ext.form.TextField({id:'PostNightHours',width:30,value:'',regex:/\d+$/}));
	//	blur:function(t,e){var tvalue=t.getValue(); var posthours=Ext.getCmp('PostHours').getValue(); if(parseInt(tvalue)>parseInt(posthours)){alert('包含夜班小时不能大于小时数！'); t.setValue(0);}}}}));
	tobar2.addItem("-");tobar2.addItem("开始时间",new Ext.form.TimeField({id:'PostStTime',value:'',format:'H:i',width:80,increment:30}));
	tobar2.addItem("-");tobar2.addItem("结束时间",new Ext.form.TimeField({id:'PostEndTime',value:'',format:'H:i',width:80,increment:30}))
	var tobar3=new Ext.Toolbar();
	tobar3.addItem("-");
	tobar3.addItem('班次分类：',new Ext.form.ComboBox({
		id:'PostType',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
			reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
				fields:[{'name':'Desc','mapping':'Desc'},{'name':'rw','mapping':'rw'}]
			}),
			baseParams:{className:'web.DHCNurRosterComm',methodName:'FindCommDicSubData',type:'RecQuery'},
			listeners:{beforeload:function(tstore,e){tstore.baseParams.parr="班次分类";}}
		}),
		tabIndex:'0',listWidth:'200',height:18,width:100,xtype : 'combo',editable:false,
		displayField : 'Desc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
		minChars : 1,pageSize : 10,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...'
	}));
	tobar3.addItem("-");
	tobar3.addItem('岗位分类：',new Ext.form.ComboBox({
		id:'PostWorkType',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
			reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
				fields:[{'name':'Desc','mapping':'Desc'},{'name':'rw','mapping':'rw'}]
			}),
			baseParams:{className:'web.DHCNurRosterComm',methodName:'FindCommDicSubData',type:'RecQuery'},
			listeners:{beforeload:function(tstore,e){tstore.baseParams.parr="岗位分类";}}
		}),
		tabIndex:'0',listWidth:'200',height:18,width:100,xtype : 'combo',editable:false,
		displayField : 'Desc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
		minChars : 1,pageSize : 10,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...'
	}));
	tobar3.addItem("-");tobar3.addItem(new Ext.form.Checkbox({id:'PostHoliday',boxLabel:'节假日'}));
	tobar3.addItem("-");tobar3.addItem("备注:",new Ext.form.TextField({id:'PostRemarks',width:200}));
	tobar3.addItem("-");tobar3.addButton({id:'addBtn',text:'增加',icon:'../Image/light/add.png',handler:savePostRec});
	tobar3.addItem("-");tobar3.addButton({id:'updateBtn',text:'修改',icon:'../Image/light/write.png',handler:updateRec});
	tobar3.addItem("-");tobar3.addButton({id:'cancleBtn',text:'清空',icon:'../Image/light/refuse.ico',handler:clearRec});
	tobar2.render(postgrid.tbar);
	tobar3.render(postgrid.tbar);
	}
	tobar.doLayout();
}

function saveRec()
{
	var wardid=Ext.getCmp('wardcombo2').getValue();
	if(wardid=="")
	{
		alert("请选择病区!");
		return;
	}
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0){ alert('请选择要添加到病区的岗位！'); return; }
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
	if(Ext.getCmp('postwin')!=null)
	{
		Ext.getCmp('postwin').close();
	}
}
function addRec()
{
	if(Ext.getCmp('postwin')!=null)
	{
		Ext.getCmp('postwin').close();
	}
	var DHCNURPostCodeT130=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'PostCode','mapping':'PostCode'},{'name':'PostDesc','mapping':'PostDesc'},{'name':'PostPerNum','mapping':'PostPerNum'},{'name':'PostHours','mapping':'PostHours'},{'name':'PostNightHours','mapping':'PostNightHours'},{'name':'TypeDesc','mapping':'TypeDesc'},{'name':'PostStTime','mapping':'PostStTime'},{'name':'PostEndTime','mapping':'PostEndTime'},{'name':'WorkTypeDesc','mapping':'WorkTypeDesc'},{'name':'PostHoliday','mapping':'PostHoliday'},{'name':'Remarks','mapping':'Remarks'},{'name':'PostValid','mapping':'PostValid'},{'name':'PostOrder','mapping':'PostOrder'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'DHCMGNUR.MgNurPost',methodName:'FindPostData',type:'RecQuery'}});
	var aa=cspRunServerMethod(pdata1,"","DHCNURPostCode","","");
	var arr=eval(aa);
	var window= new Ext.Window({		
		title : '病区岗位代码添加',
		id : "postwin",
		x:50,y:50,
		width : 800,
		height : 500,
		autoScroll : true,
		layout : 'absolute',
		items : [arr]
	});
	window.show();
	var mygridpl=Ext.getCmp("mygridpl");
	mygridpl.setPosition(0,0);
	mygridpl.setSize(780,465);
	var mygrid=Ext.getCmp('mygrid');
	mygrid.setTitle('');
	var tobar = mygrid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but2=Ext.getCmp("mygridbut2");
	but2.hide();
	tobar.addItem("-");
	tobar.addButton({id:'findpostbtn',text:'查询',handler:findPostRec});
	tobar.addItem("-");
	tobar.addItem("病区:",new Ext.form.ComboBox({
		id:'wardcombo2',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
			reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
				fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
			}),
			baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'},
			listeners:{ 
				beforeload:function(tstore,e){ 
					tstore.baseParams.parr=Ext.getCmp('wardcombo2').lastQuery;
				}
			}
		}),
		tabIndex:'0',listWidth:'200',height:18,width:150,xtype : 'combo',
		displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
		minChars : 1,pageSize : 10,typeAhead : true,typeAheadDelay : 1000,loadingText : 'Searching...'
	}));
	tobar.addItem("-");tobar.addButton({id:'distrupost',text:'分配到病区',handler:saveRec});
	tobar.doLayout();
	if(Ext.getCmp('postwin')!=null)
	{
		mygrid.store.on('beforeload',function(){
			mygrid.store.baseParams.parr="N";
		});
		mygrid.store.load({params:{start:0,limit:15}});
	}
}

function findRec()
{
	var postgrid=Ext.getCmp('postgrid');
	postgrid.store.load({params:{start:0,limit:10}});
}
function findPostRec()
{
	var mygrid=Ext.getCmp('mygrid');
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

function deleteRec()
{
	var postgrid=Ext.getCmp('postgrid');
	var selections=postgrid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert("请选择一条或多条记录!");
		return;
	}
	var parr="";
	for(i=0;i<selections.length;i++)
	{
		var selectRow=selections[i];
		var ID=selectRow.get('rw');
		if(parr=="") parr=ID;
		else parr=parr+"^"+ID;
	}
	if(parr!="")
	{
 		var a=tkMakeServerCall("DHCMGNUR.MgNurWardPost","Delete",parr)
	}
	findRec();
}

function changeRec()
{
	var postgrid=Ext.getCmp('postgrid');
	var count=postgrid.store.getTotalCount();
	var selections=postgrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一条记录!');
		return;
	}
	var OrderText=Ext.getCmp('OrderText').getValue();
	if((!OrderText.match(/^[1-9][0-9]*$/))||(parseInt(OrderText)>count))
	{
		alert('序号只能为大于0且小于等于'+count+'的整数!');
		return;
	}
	var selectedRow=postgrid.getSelectionModel().getSelected();
	var ID=selectedRow.get('rw');
	var parr=ID+"^"+OrderText;
	var a=tkMakeServerCall("DHCMGNUR.MgNurWardPost","changeOrder",parr);
	//alert(a)
	findRec();
}

function updateRec()
{
	var mygrid=Ext.getCmp('postgrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一行记录进行修改操作！');
		return;
	}
	if(CheckValue())
	{
		var postid=selections[0].get('PostID');
		var parr=GetValue()+"^ID|"+postid;
		var a=tkMakeServerCall("DHCMGNUR.MgNurPost","Save",parr);
		if(a!=0){alert("保存成功！");}
		else {alert("保存失败！");}
		findRec();
		Ext.getCmp('addBtn').enable();
		Ext.getCmp('updateBtn').disable();
	}
}

function CheckValue()
{
	var postcode=Ext.getCmp('PostCode').getValue();
	if(postcode==""){ alert('代码不能为空！'); return false; }
	var postdesc=Ext.getCmp('PostDesc').getValue();
	if(postdesc==""){ alert('名称不能为空！'); return false; }
	var postpernum=Ext.getCmp('PostPerNum').getValue();
	//if(postpernum==""){ alert('人数不能为空！'); return false; }
	var posthours=Ext.getCmp('PostHours').getValue();
	//if(posthours==""){ alert('小时数不能为空！'); return false; }
	var postnighthours=Ext.getCmp('PostNightHours').getValue();
	//if(postnighthours==""){ alert('包含夜班小时不能为空！'); return false; }
	var poststtime=Ext.getCmp('PostStTime').getValue();
	if(poststtime==""){ alert('开始时间不能为空！'); return false; }
	var postendtime=Ext.getCmp('PostEndTime').getValue();
	if(postendtime==""){ alert('结束时间不能为空！'); return false; }
	var posttype=Ext.getCmp('PostType').getValue();
	if(posttype==""){ alert('班次分类不能为空！'); return false; }
	var postworktype=Ext.getCmp('PostWorkType').getValue();
	//if(postworktype==""){ alert('岗位分类不能为空！'); return false; }
	return true;
}
function GetValue()
{
	var parr="";
	var postcode=Ext.getCmp('PostCode').getValue();
	parr=parr+"PostCode|"+postcode;
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

function rowdblclick(grid,row,e)
{
	var clickrow=grid.store.getAt(row);
	var postid=clickrow.get('PostID');
	var ret=tkMakeServerCall("DHCMGNUR.MgNurPost","getValue",postid);
	var array=SplitStr(ret);
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
	Ext.getCmp('PostRemarks').setValue(array['PostRemarks']);
	Ext.getCmp('updateBtn').enable();
	Ext.getCmp('addBtn').disable();
}
function clearRec(){
	Ext.getCmp('PostCode').setValue('');
	Ext.getCmp('PostDesc').setValue('');
	Ext.getCmp('PostPerNum').setValue('');
	Ext.getCmp('PostHours').setValue('');
	Ext.getCmp('PostNightHours').setValue('');
	Ext.getCmp('PostStTime').setValue('');
	Ext.getCmp('PostEndTime').setValue('');
	//Ext.getCmp('PostType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostType').setRawValue('白班');}});
	//Ext.getCmp('PostWorkType').store.load({params:{start:0,limit:10},callback:function(){Ext.getCmp('PostWorkType').setRawValue('病房');}});
	Ext.getCmp('PostType').setValue('');
	Ext.getCmp('PostWorkType').setValue('');
	Ext.getCmp('PostHoliday').setValue(false);
	Ext.getCmp('PostRemarks').setValue('');
	Ext.getCmp('addBtn').enable();
	Ext.getCmp('updateBtn').disable();
}

function savePostRec()
{
	var wardid=Ext.getCmp('wardcombo').getValue();
	if(wardid=="")
	{
		alert("请选择病区!");
		return;
	}
	if(CheckValue())
	{
		var postcode=Ext.getCmp('PostCode').getValue();
		var ret=tkMakeServerCall("DHCMGNUR.MgNurPost","CheckRepeat",postcode+"^"+wardid);
		if(ret!=0){ alert('代码已存在，不可重复创建!'); return false; }
		var parr=GetValue();
		var a=tkMakeServerCall("DHCMGNUR.MgNurPost","Save",parr);
		if(a=="0")
		{
			alert('保存失败！');
		}
		else{
			var parr="PostWard|"+wardid+"^PostID|"+a;
			var ret=tkMakeServerCall("DHCMGNUR.MgNurWardPost","Save",parr);
			findRec();
		}
	}
}

function statusRec(b,e)
{
	var mygrid=Ext.getCmp('postgrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一行记录进行修改操作！');
		return;
	}
	var postid=selections[0].get('PostID');
	var wardpostid=selections[0].get('rw');
	if(b.id=="statusbtn")
	{
		var parr1=postid+"^N";
		var ret1=tkMakeServerCall("DHCMGNUR.MgNurPost","SetValid",parr1);
		var parr2=wardpostid+"^N";
		var ret2=tkMakeServerCall("DHCMGNUR.MgNurWardPost","SetValid",parr2);
		if(ret1=="1"&&ret2=="1") alert("作废成功！");
		else alert("作废失败！")
	}
	if(b.id=="unstatusbtn")
	{
		var parr1=postid+"^Y";
		var ret1=tkMakeServerCall("DHCMGNUR.MgNurPost","SetValid",parr1);
		var parr2=wardpostid+"^Y";
		var ret2=tkMakeServerCall("DHCMGNUR.MgNurWardPost","SetValid",parr2);
		if(ret1=="1"&&ret2=="1") alert("作废成功！");
		else alert("作废失败！")
	}
	findRec();
}