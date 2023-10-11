var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
var REC=new Array();
function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp('mygrid2pl');
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	CreateGrid();
	var mygrid=Ext.getCmp('mygrid2');
	mygrid.setTitle();
	mygrid.on('rowdblclick',updateRec)
}
function selectDate(df,date)
{
	if(df.id=="JXPersonDob")
	{
		if(date>=new Date())
		{
			alert("出生日期不能大于当前日期！");
			df.setValue(new Date());
		}
	}
	else{
		var stdate=Ext.getCmp('JXPersonStDate').getValue();
		var enddate=Ext.getCmp('JXPersonEndDate').getValue()
		if(enddate!=""&&stdate!=""&&stdate>enddate)
		{		
			alert("开始日期不能小于结束日期！")
			Ext.getCmp('JXPersonEndDate').setValue(stdate)
		}	
	}
}
function CreateGrid()
{
	var mygrid=Ext.getCmp('mygrid2');
	var tobar=mygrid.getTopToolbar();
	Ext.getCmp('mygrid2but1').hide();
	Ext.getCmp('mygrid2but2').hide();
	tobar.addItem('-','开始日期:',new Ext.form.DateField({id:'JXStDate',value:new Date(),format:'Y-m-d'}));
	tobar.addItem('-','结束日期:',new Ext.form.DateField({id:'JXEndDate',value:new Date(),format:'Y-m-d'}));
	tobar.addItem('-');tobar.addButton({id:'jxfindBtn',icon:'../Image/icons/find.png',text:'查询',handler:findRec});
	tobar.addItem('-');tobar.addButton({id:'jxaddBtn',icon:'../Image/icons/add.png',text:'新建',handler:addRec});
	tobar.addItem('-');tobar.addButton({id:'jxupdateBtn',icon:'../Image/icons/cog_edit.png',text:'修改',handler:updateRec});
	//tobar.addItem('-');tobar.addButton({id:'jxprintBtn',icon:'../Image/icons/printer.png',text:'打印',handler:printRec});
	tobar.addItem('-');tobar.addButton({id:'jxstatusBtn',icon:'../Image/icons/delete.png',text:'作废',handler:statusRec});
	tobar.doLayout();
	var mygrid2=Ext.getCmp('mygrid2');
	mygrid2.getBottomToolbar().hide();
}

function createWindow()
{
	var a=cspRunServerMethod(pdata1,"","DHCNURJXPERSON","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '进修人员信息',
		id : "DHCNURJXPERSON",
		x:100,y:50,
		width : 570,
		height : 440,
		fileUpload:true,
		autoScroll : true,
		modal:true,
		layout : 'absolute',
		items : [arr]
	});
	return window;
}

function findRec()
{
	REC=new Array();
	var mygrid=Ext.getCmp('mygrid2');
	var GetQueryData=document.getElementById('GetQueryData').value;
	var StDate=Ext.getCmp('JXStDate').getValue().format('Y-m-d');
	var EndDate=Ext.getCmp('JXEndDate').getValue().format('Y-m-d');
	var parr=StDate+'^'+EndDate+'^'+"S";
	var ret=cspRunServerMethod(GetQueryData,"web.DHCNurPSPersons.FindPSPersons","parr$"+parr,"setRec");
	mygrid.store.loadData(REC);
}
function setRec(a)
{
	var array=SplitStr(a);
	REC.push({
		PersonID:array['PersonID'],
		ChestID:array['ChestID'],
		PersonName:array['PersonName'],
		PersonWorkDate:array['PersonWorkDate'],
		PersonComeDate:array['PersonComeDate'],
		PersonLocation:array['PersonLocation'],
		Perfessional:array['Perfessional'],
		PersonSex:array['PersonSex'],
		PersonDob:array['PersonDob'],
		PersonAge:array['PersonAge'],
		PersonWard:array['WardCode'],
		PersonStDate:array['PersonStDate'],
		PersonEndDate:array['PersonEndDate'],
		PersonAddress:array['PersonAddress'],
		PersonPhone:array['PersonPhone'],
		PersonStatus:array['PersonStatus'],
		rw:array['ID']
	});
}

function addRec()
{
	var win=createWindow();
	win.show();
	Ext.getCmp('JXPersonDob').on('select',selectDate);
	Ext.getCmp('JXPersonStDate').on('select',selectDate);
	Ext.getCmp('JXPersonEndDate').on('select',selectDate);
	if(session['LOGON.GROUPDESC']=='住院护士长'||session['LOGON.GROUPDESC'].indexOf('护士长')>0)
	{
		var PersonWard=Ext.getCmp("JXPersonWard");
		PersonWard.store.load({params:{start:0,limit:1000},callback:function(){PersonWard.setValue(session['LOGON.CTLOCID']);}});
		PersonWard.disable();
	}
	var closeBtn=Ext.getCmp('jxcloseBtn');
	if(closeBtn!=null)
	{
		closeBtn.on('click',function(){win.close();});
	}
	var clearBtn=Ext.getCmp('jxclearBtn');
	if(clearBtn!=null)
	{
		clearBtn.on('click',clearRec);
	}
	var saveBtn=Ext.getCmp('jxsaveBtn');
	if(saveBtn!=null)
	{
		saveBtn.on('click',function()
		{
			var parr=getValue();
			if(parr!="")
			{
				var PersonID=Ext.getCmp('JXPersonID').getValue();
				var CheckIDRepeat=document.getElementById('CheckIDRepeat').value;
				if(PersonID!="")
				{
					var chkret=cspRunServerMethod(CheckIDRepeat,PersonID);
					if(chkret!=0||chkret!="")
					{
						alert('工号已存在，不可重复！');
						return;
					}
				}
				parr=parr+"^PersonType|"+"S";
				var SaveValue=document.getElementById('SaveValue').value;
				var ret=cspRunServerMethod(SaveValue,parr);
				if(ret=="OK")
				{
					win.close();
					findRec();
				}
			}
		});
	}
}
function getValue()
{
	var parr=""
	var PersonID=Ext.getCmp('JXPersonID').getValue();
	parr="PersonID|"+PersonID;
	var ChestID=Ext.getCmp('JXChestID').getValue();
	parr=parr+"^ChestID|"+ChestID;
	var PersonName=Ext.getCmp('JXPersonName').getValue();
	if(PersonName=="") { alert('请填写职工姓名!'); return false; }
	parr=parr+"^PersonName|"+PersonName;
	var PersonLocation=Ext.getCmp('JXPersonLocation').getValue();
	//if(PersonLocation=="") {	alert('请填写职工单位!'); return false;	}
	parr=parr+"^PersonLocation|"+PersonLocation;
	var Perfessional=Ext.getCmp('JXPerfessional').getValue();
	//if(Perfessional=="") {	alert('请填写进修专科!');	return false;}
	parr=parr+"^Perfessional|"+Perfessional;
	var PersonDob=Ext.getCmp('JXPersonDob').getValue();
	if(PersonDob!="") PersonDob=PersonDob.format('Y-m-d');
	parr=parr+"^PersonDob|"+PersonDob;
	var PersonAddress=Ext.getCmp('JXPersonAddress').getValue();
	parr=parr+"^PersonAddress|"+PersonAddress;
	var PersonPhone=Ext.getCmp('JXPersonPhone').getValue();
	parr=parr+"^PersonPhone|"+PersonPhone;
	var PersonWard=Ext.getCmp('JXPersonWard').getValue();
	if(PersonWard=="") {	alert('请填写分配科室!');	return false;	}
	parr=parr+"^PersonWard|"+PersonWard;
	var PersonStDate=Ext.getCmp('JXPersonStDate').getValue();
	if(PersonStDate!="")PersonStDate=PersonStDate.format('Y-m-d');
	if(PersonStDate=="") {	alert('请填写进修开始日期!');	return false;	}
	parr=parr+"^PersonStDate|"+PersonStDate;
	var PersonEndDate=Ext.getCmp('JXPersonEndDate').getValue();
	if(PersonEndDate!="")PersonEndDate=PersonEndDate.format('Y-m-d');
	parr=parr+"^PersonEndDate|"+PersonEndDate;
	var PersonSex=Ext.getCmp('JXPersonSex').getValue();
	parr=parr+"^PersonSex|"+PersonSex;
	var PersonComeDate=Ext.getCmp('JXPersonComeDate').getValue();
	if(PersonComeDate)PersonComeDate=PersonComeDate.format('Y-m-d');
	parr=parr+"^PersonComeDate|"+PersonComeDate;
	var PersonWorkDate=Ext.getCmp('JXPersonWorkDate').getValue();
	if(PersonWorkDate!="")PersonWorkDate=PersonWorkDate.format('Y-m-d');
	parr=parr+"^PersonWorkDate|"+PersonWorkDate;
	return parr;
}
function updateRec()
{
	var mygrid=Ext.getCmp('mygrid2');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('选择一条记录!');
		return;
	}
	var ID=selections[0].get('rw');
	var win=createWindow();
	win.show();
	Ext.getCmp('JXPersonDob').on('select',selectDate);
	Ext.getCmp('JXPersonStDate').on('select',selectDate);
	Ext.getCmp('JXPersonEndDate').on('select',selectDate);
	Ext.getCmp('JXPersonID').disable();
	if(ID!="") setValue(ID);
	var closeBtn=Ext.getCmp('jxcloseBtn');
	if(closeBtn!=null)
	{
		closeBtn.on('click',function(){win.close();});
	}
	var clearBtn=Ext.getCmp('jxclearBtn');
	if(clearBtn!=null)
	{
		clearBtn.on('click',clearRec);
	}
	var saveBtn=Ext.getCmp('jxsaveBtn');
	if(saveBtn!=null)
	{
		saveBtn.on('click',function()
		{
			var parr=getValue();
			if(parr!=false)
			{
				parr=parr+"^PersonType|"+"S"+"^ID|"+ID;
				var UpdateValue=document.getElementById('UpdateValue').value;
				var ret=cspRunServerMethod(UpdateValue,parr);
				if(ret=="OK")
				{
					win.close();
					findRec();
				}
			}
		});
	}
}

function setValue(ID)
{
	var getVal=document.getElementById('getVal').value;
	var ret=cspRunServerMethod(getVal,ID);
	var array=SplitStr(ret);
	var PersonID=Ext.getCmp('JXPersonID');
	if(PersonID!=null) PersonID.setValue(array['PersonID']);
	var ChestID=Ext.getCmp('JXChestID');
	if(ChestID!=null) ChestID.setValue(array['ChestID']);
	var PersonName=Ext.getCmp('JXPersonName');
	if(PersonName!=null) PersonName.setValue(array['PersonName']);
	var PersonLocation=Ext.getCmp('JXPersonLocation');
	if(PersonLocation!=null) PersonLocation.setValue(array['PersonLocation']);
	var Perfessional=Ext.getCmp('JXPerfessional');
	if(Perfessional!=null) Perfessional.setValue(array['Perfessional']);
	var PersonDob=Ext.getCmp('JXPersonDob');
	if(PersonDob!=null) PersonDob.setValue(array['PersonDob']);
	var PersonAddress=Ext.getCmp('JXPersonAddress');
	if(PersonAddress!=null) PersonAddress.setValue(array['PersonAddress']);
	var PersonPhone=Ext.getCmp('JXPersonPhone');
	if(PersonPhone!=null) PersonPhone.setValue(array['PersonPhone']);
	var PersonWard=Ext.getCmp('JXPersonWard');
	if(PersonWard!=null) 
	{
		PersonWard.store.load({params:{start:0,limit:1000},callback:function(){PersonWard.setValue(array['PersonWard']);}});
	}
	var PersonStDate=Ext.getCmp('JXPersonStDate');
	if(PersonStDate!=null) PersonStDate.setValue(array['PersonStDate']);
	var PersonEndDate=Ext.getCmp('JXPersonEndDate');
	if(PersonEndDate!=null) PersonEndDate.setValue(array['PersonEndDate']);
	var PersonSex=Ext.getCmp('JXPersonSex');
	if(PersonSex!=null) PersonSex.setValue(array['PersonSex']);
	var PersonComeDate=Ext.getCmp('JXPersonComeDate');
	if(PersonComeDate!=null) PersonComeDate.setValue(array['PersonComeDate']);
	var PersonWorkDate=Ext.getCmp('JXPersonWorkDate');
	if(PersonWorkDate!=null) PersonWorkDate.setValue(array['PersonWorkDate']);
}
function statusRec()
{
	var mygrid=Ext.getCmp('mygrid2');
	var SetStatus=document.getElementById('SetStatus').value;
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length<1)
	{
		alert('选择一条记录!');
		return;
	}
	for(var i=0;i<selections.length;i++)
	{
		var ID=selections[i].get('rw');
		var Status=selections[i].get('PersonStatus');
		if(Status=='Y')
		{
			cspRunServerMethod(SetStatus,ID+"^N");
		}
	}
	findRec();
}
function unStatusRec()
{
	var mygrid=Ext.getCmp('mygrid2');
	var SetStatus=document.getElementById('SetStatus').value;
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length<1)
	{
		alert('选择一条记录!');
		return;
	}
	for(var i=0;i<selections.length;i++)
	{
		var ID=selections[i].get('rw');
		var Status=selections[i].get('PersonStatus');
		if(Status=='N')
		{
			cspRunServerMethod(SetStatus,ID+"^Y");
		}
	}
}
function clearRec()
{
	var PersonID=Ext.getCmp('JXPersonID');
	if(PersonID!=null) PersonID.setValue("");
	PersonID.enable();
	var ChestID=Ext.getCmp('JXChestID');
	if(ChestID!=null) ChestID.setValue("");
	var PersonName=Ext.getCmp('JXPersonName');
	if(PersonName!=null) PersonName.setValue("");
	var PersonLocation=Ext.getCmp('JXPersonLocation');
	if(PersonLocation!=null) PersonLocation.setValue("");
	var Perfessional=Ext.getCmp('JXPerfessional');
	if(Perfessional!=null) Perfessional.setValue("");
	var PersonDob=Ext.getCmp('JXPersonDob');
	if(PersonDob!=null) PersonDob.setValue("");
	var PersonAddress=Ext.getCmp('JXPersonAddress');
	if(PersonAddress!=null) PersonAddress.setValue("");
	var PersonPhone=Ext.getCmp('JXPersonPhone');
	if(PersonPhone!=null) PersonPhone.setValue("");
	var PersonWard=Ext.getCmp('JXPersonWard');
	if(PersonWard!=null) PersonWard.setValue("");
	var PersonStDate=Ext.getCmp('JXPersonStDate');
	if(PersonStDate!=null) PersonStDate.setValue(new Date());
	var PersonEndDate=Ext.getCmp('JXPersonEndDate');
	if(PersonEndDate!=null) PersonEndDate.setValue(new Date());
	var PersonSex=Ext.getCmp('JXPersonSex');
	if(PersonSex!=null) PersonSex.setValue("");
	var PersonComeDate=Ext.getCmp('JXPersonComeDate');
	if(PersonComeDate!=null) PersonComeDate.setValue(new Date());
	var PersonWorkDate=Ext.getCmp('JXPersonWorkDate');
	if(PersonWorkDate!=null) PersonWorkDate.setValue(new Date());
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
function printRec()
{
}