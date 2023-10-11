var fheight = document.body.clientHeight-2;
var fwidth = document.body.clientWidth-2;

function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp('mygridpl');
	mygridpl.setPosition(0,0);
	mygridpl.setSize(fwidth,fheight);
	addTool();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.on('beforeload',function(){
		var chkvalid=Ext.getCmp('chkvalid').getValue();
		var parr=chkvalid?"Y":"N";
		mygrid.store.baseParams.parr=parr;
	});
	findRec();
	mygrid.on('rowdblclick',rowdblclick);
	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}

function addTool()
{
	var mygrid=Ext.getCmp('mygrid');
	var tobar=mygrid.getTopToolbar();
	Ext.getCmp('mygridbut1').hide();
	Ext.getCmp('mygridbut2').hide();
	tobar.addItem('-');tobar.addItem('代码',new Ext.form.TextField({id:'holidaycode',width:100}));
	tobar.addItem('-');tobar.addItem('名称',new Ext.form.TextField({id:'holidaydesc',width:100}));
	tobar.addItem('-');tobar.addItem('日小时数',new Ext.form.TextField({id:'holidayhours',width:50,regex:/^((\d)|(1\d)|(2[0-4]))$/,regexText:'请输入0-24之内的整数',msgTarget:'under'}));
	tobar.addItem('-');tobar.addItem('备注',new Ext.form.TextField({id:'holidayremarks',width:150}));
	var tobar2=new Ext.Toolbar();
	tobar2.addItem('-');tobar2.addItem(new Ext.form.Checkbox({id:'chkvalid',boxLabel:'显示作废'}));
	tobar2.addItem('-');tobar2.addButton({id:'findbtn',icon:'../images/uiimages/search.png',text:'查找',handler:findRec});
	tobar2.addItem('-');tobar2.addButton({id:'newbtn',text:'增加',handler:newRec,icon:'../images/uiimages/edit_add.png'});
	tobar2.addItem('-');tobar2.addButton({id:'updatebtn',text:'编辑',handler:updateRec,icon:'../images/uiimages/pencil.png'});
	tobar2.addItem('-');tobar2.addButton({id:'validbtn',text:'作废',handler:validRec,icon:'../images/uiimages/cancel.png'});
	tobar2.addItem('-');tobar2.addButton({id:'unvalidbtn',text:'撤销作废',handler:validRec,icon:'../images/uiimages/undo.png'});
	tobar2.render(mygrid.tbar);
	tobar.doLayout()
}

function findRec()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:10}});
}

function newRec()
{
	var holidaycode=Ext.getCmp('holidaycode').getValue();
	if(holidaycode==""){ Ext.Msg.alert('提示','休假代码不能为空！'); return;}
	var holidaydesc=Ext.getCmp('holidaydesc').getValue();
	if(holidaydesc==""){ Ext.Msg.alert('提示','休假名称不能为空！'); return;}
	var holidayhours=Ext.getCmp('holidayhours').getValue();
	var holidayremarks=Ext.getCmp('holidayremarks').getValue();
	var parr="HolidayCode|"+holidaycode+"^HolidayDesc|"+holidaydesc+"^HolidayHours|"+holidayhours+"^HolidayRemarks|"+holidayremarks;
	var a=tkMakeServerCall("DHCMGNUR.MgNurHolidayCode","Save",parr);
	alert(a);
	findRec();
}

function updateRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一条要修改的记录！');
		return;
	}
	var holidayid=selections[0].get('rw');
	var holidaycode=Ext.getCmp('holidaycode').getValue();
	if(holidaycode==""){ Ext.Msg.alert('提示','休假代码不能为空！'); return;}
	var holidaydesc=Ext.getCmp('holidaydesc').getValue();
	if(holidaydesc==""){ Ext.Msg.alert('提示','休假名称不能为空！'); return;}
	var holidayhours=Ext.getCmp('holidayhours').getValue();
	var holidayremarks=Ext.getCmp('holidayremarks').getValue();
	var parr="ID|"+holidayid+"^HolidayCode|"+holidaycode+"^HolidayDesc|"+holidaydesc+"^HolidayHours|"+holidayhours+"^HolidayRemarks|"+holidayremarks;
	var a=tkMakeServerCall("DHCMGNUR.MgNurHolidayCode","Save",parr);
	alert(a);
	findRec();
}

function validRec(b,e)
{
	var mygrid=Ext.getCmp('mygrid');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('请选择一条要修改的记录！');
		return;
	}
	var holidayid=selections[0].get('rw');
	var flag=selections[0].get('HolidayStatus');
	var validval="Y";
	if(b.id=='validbtn')
	{
		validval="N";
		if(flag==validval){
			Ext.Msg.alert('提示','该记录已经作废，不允许再作废！');
			return;
		}
	}else if(b.id=="unvalidbtn"){
		if(flag==validval){
			Ext.Msg.alert('提示','该记录为有效记录，不能撤销作废！');
			return;
		}
	}
	var parr=holidayid+"^"+validval;
	if(validval=="N"){
		if (confirm('确定作废选中的项？')) {
			var a=tkMakeServerCall("DHCMGNUR.MgNurHolidayCode","setStatus",parr);
	        alert(a);
	        findRec();
		}
	}
    if(validval=="Y"){
		if (confirm('确定撤销作废选中的项？')) {
			var a=tkMakeServerCall("DHCMGNUR.MgNurHolidayCode","setStatus",parr);
	        alert(a);
	        findRec();
		}
	}	
}
function rowdblclick(grid,row,e)
{
	var holidayid=grid.store.getAt(row).get('rw');
	var ret=tkMakeServerCall("DHCMGNUR.MgNurHolidayCode","GetValue",holidayid);
	var array=SplitStr(ret);
	Ext.getCmp('holidaycode').setValue(array['HolidayCode']);
	Ext.getCmp('holidaydesc').setValue(array['HolidayDesc']);
	Ext.getCmp('holidayhours').setValue(array['HolidayHours']);
	Ext.getCmp('holidayremarks').setValue(array['HolidayRemarks']);
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