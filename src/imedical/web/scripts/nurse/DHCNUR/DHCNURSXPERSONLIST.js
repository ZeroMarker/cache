var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp('mygrid1pl');
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	CreateGrid();
	var mygrid=Ext.getCmp('mygrid1');
	mygrid.setTitle();
	mygrid.on('rowdblclick',updateRec);
}
function selectDate(df,date)
{
	if(df.id=="SXPersonDob")
	{
		if(date>=new Date())
		{
			alert("出生日期不能大于当前日期！");
			df.setValue(new Date());
		}
	}
	else{
		var stdate=Ext.getCmp('SXPersonStDate').getValue();
		var enddate=Ext.getCmp('SXPersonEndDate').getValue()
		if(enddate!=""&&stdate!=""&&stdate>enddate)
		{		
			alert("开始日期不能小于结束日期！")
			Ext.getCmp('SXPersonEndDate').setValue(stdate)
		}	
	}
}
function CreateGrid()
{
	var mygrid=Ext.getCmp('mygrid1');
	var tobar=mygrid.getTopToolbar();
	Ext.getCmp('mygrid1but1').hide();
	Ext.getCmp('mygrid1but2').hide();
	tobar.addItem('-','开始日期:',new Ext.form.DateField({id:'SXStDate',value:new Date(),format:'Y-m-d'}));
	tobar.addItem('-','结束日期:',new Ext.form.DateField({id:'SXEndDate',value:new Date(),format:'Y-m-d'}));
	tobar.addItem('-');tobar.addButton({id:'sxfindBtn',icon:'../Image/icons/find.png',text:'查询',handler:findRec});
	tobar.addItem('-');tobar.addButton({id:'sxaddBtn',icon:'../Image/icons/add.png',text:'新建',handler:addRec});
	tobar.addItem('-');tobar.addButton({id:'sxupdateBtn',icon:'../Image/icons/cog_edit.png',text:'修改',handler:updateRec});
	//tobar.addItem('-');tobar.addButton({id:'sxprintBtn',icon:'../Image/icons/printer.png',text:'打印',handler:printRec});
	tobar.addItem('-');tobar.addButton({id:'sxstatusBtn',icon:'../Image/icons/delete.png',text:'作废',handler:statusRec});//unStatusRec
	//tobar.addItem('-');tobar.addButton({id:'sxunstatusBtn',icon:'../Image/icons/delete.png',text:'撤销作废',handler:unStatusRec});
	tobar.doLayout();
	var mygrid1=Ext.getCmp('mygrid1');
	mygrid1.getBottomToolbar().hide();
}

function createWindow()
{
	var a=cspRunServerMethod(pdata1,"","DHCNURSXPERSON","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '实习人员信息',
		id : "DHCNURSXPERSON",
		x:100,y:50,
		width : 600,
		height :400,
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
	var mygrid=Ext.getCmp('mygrid1');
	var GetQueryData=document.getElementById('GetQueryData').value;
	var StDate=Ext.getCmp('SXStDate').getValue().format('Y-m-d');
	var EndDate=Ext.getCmp('SXEndDate').getValue().format('Y-m-d');
	var parr=StDate+'^'+EndDate+'^'+"P";
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
		PersonLocation:array['PersonLocation'],
		PersonClass:array['PersonClass'],
		Perfessional:array['Perfessional'],
		PersonSex:array['PersonSex'],
		PersonDob:array['PersonDob'],
		PersonAge:array['PersonAge'],
		PersonWard:array['WardCode'],
		PersonComeDate:array['PersonComeDate'],
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
	Ext.getCmp('SXPersonDob').on('select',selectDate);
	Ext.getCmp('SXPersonStDate').on('select',selectDate);
	Ext.getCmp('SXPersonEndDate').on('select',selectDate);
	if(session['LOGON.GROUPDESC']=='住院护士长'||session['LOGON.GROUPDESC'].indexOf('护士长')>0)
	{
		var PersonWard=Ext.getCmp("SXPersonWard");
		PersonWard.store.load({params:{start:0,limit:1000},callback:function(){PersonWard.setValue(session['LOGON.CTLOCID']);}});
		PersonWard.disable();
	}
	var closeBtn=Ext.getCmp('sxcloseBtn');
	if(closeBtn!=null)
	{
		closeBtn.on('click',function(){win.close();});
	}
	var clearBtn=Ext.getCmp('sxclearBtn');
	if(clearBtn!=null)
	{
		clearBtn.on('click',clearRec);
	}
	var saveBtn=Ext.getCmp('sxsaveBtn');
	if(saveBtn!=null)
	{
		saveBtn.on('click',function()
		{
			var parr=getValue();
			if(parr!="")
			{
				var PersonID=Ext.getCmp('SXPersonID').getValue();
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
				parr=parr+"^PersonType|"+"P";
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
	var PersonID=Ext.getCmp('SXPersonID').getValue();  
	parr="PersonID|"+PersonID;
	var ChestID=Ext.getCmp('SXChestID').getValue();  
	parr=parr+"^ChestID|"+ChestID;
	var PersonName=Ext.getCmp('SXPersonName').getValue();
	if(PersonName=="") { alert('请填写职工姓名!'); return false; }
	parr=parr+"^PersonName|"+PersonName;
	var PersonLocation=Ext.getCmp('SXPersonLocation').getValue();
	//if(PersonLocation=="") {	alert('请填写学校!');	return false;	}
	parr=parr+"^PersonLocation|"+PersonLocation;
	var PersonClass=Ext.getCmp('SXPersonClass').getValue();
	parr=parr+"^PersonClass|"+PersonClass;
	var Perfessional=Ext.getCmp('SXPerfessional').getValue();
	parr=parr+"^Perfessional|"+Perfessional;
	var PersonDob=Ext.getCmp('SXPersonDob').getValue();
	if(PersonDob!="")PersonDob=PersonDob.format('Y-m-d');
	parr=parr+"^PersonDob|"+PersonDob;
	var PersonAddress=Ext.getCmp('SXPersonAddress').getValue();
	parr=parr+"^PersonAddress|"+PersonAddress;
	var PersonPhone=Ext.getCmp('SXPersonPhone').getValue();
	parr=parr+"^PersonPhone|"+PersonPhone;
	var PersonWard=Ext.getCmp('SXPersonWard').getValue();
	if(PersonWard=="") {	alert('请填写分配科室!');	return false;	}
	parr=parr+"^PersonWard|"+PersonWard;
	var PersonStDate=Ext.getCmp('SXPersonStDate').getValue();
	if(PersonStDate!="")PersonStDate=PersonStDate.format('Y-m-d');
	if(PersonStDate=="") { alert('请填写实习开始日期!');  return false; }
	parr=parr+"^PersonStDate|"+PersonStDate;
	var PersonEndDate=Ext.getCmp('SXPersonEndDate').getValue();
	if(PersonEndDate!="") PersonEndDate=PersonEndDate.format('Y-m-d');
	parr=parr+"^PersonEndDate|"+PersonEndDate;
	var PersonSex=Ext.getCmp('SXPersonSex').getValue();
	parr=parr+"^PersonSex|"+PersonSex;
	var PersonComeDate=Ext.getCmp('SXPersonComeDate').getValue();
	if(PersonComeDate!="")PersonComeDate=PersonComeDate.format('Y-m-d');
	parr=parr+"^PersonComeDate|"+PersonComeDate
	return parr;
}

function setValue(ID)
{
	var getVal=document.getElementById('getVal').value;
	var ret=cspRunServerMethod(getVal,ID);
	var array=SplitStr(ret);
	var PersonID=Ext.getCmp('SXPersonID');
	if(PersonID!=null) PersonID.setValue(array['PersonID']);
	var ChestID=Ext.getCmp('SXChestID');
	if(ChestID!=null) ChestID.setValue(array['ChestID']);
	var PersonName=Ext.getCmp('SXPersonName');
	if(PersonName!=null) PersonName.setValue(array['PersonName']);
	var PersonLocation=Ext.getCmp('SXPersonLocation');
	if(PersonLocation!=null) PersonLocation.setValue(array['PersonLocation']);
	var PersonClass=Ext.getCmp('SXPersonClass');
	if(PersonClass!=null) PersonClass.setValue(array['PersonClass']);
	var Perfessional=Ext.getCmp('SXPerfessional');
	if(Perfessional!=null) Perfessional.setValue(array['Perfessional']);
	var PersonDob=Ext.getCmp('SXPersonDob');
	if(PersonDob!=null) PersonDob.setValue(array['PersonDob']);
	var PersonAddress=Ext.getCmp('SXPersonAddress');
	if(PersonAddress!=null) PersonAddress.setValue(array['PersonAddress']);
	var PersonPhone=Ext.getCmp('SXPersonPhone');
	if(PersonPhone!=null) PersonPhone.setValue(array['PersonPhone']);
	var PersonWard=Ext.getCmp('SXPersonWard');
	if(PersonWard!=null) 
	{
		PersonWard.store.load({params:{start:0,limit:1000},callback:function(){PersonWard.setValue(array['PersonWard']);}});
	}
	var PersonStDate=Ext.getCmp('SXPersonStDate');
	if(PersonStDate!=null) PersonStDate.setValue(array['PersonStDate']);
	var PersonEndDate=Ext.getCmp('SXPersonEndDate');
	if(PersonEndDate!=null) PersonEndDate.setValue(array['PersonEndDate']);
	var PersonSex=Ext.getCmp('SXPersonSex');
	if(PersonSex!=null) PersonSex.setValue(array['PersonSex']);
	var PersonComeDate=Ext.getCmp('SXPersonComeDate');
	if(PersonComeDate!=null) PersonComeDate.setValue(array['PersonComeDate']);
}
function updateRec()
{
	var mygrid=Ext.getCmp('mygrid1');
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length!=1)
	{
		alert('选择一条记录!');
		return;
	}
	var ID=selections[0].get('rw');
	var win=createWindow();
	win.show();
	Ext.getCmp('SXPersonDob').on('select',selectDate);
	Ext.getCmp('SXPersonStDate').on('select',selectDate);
	Ext.getCmp('SXPersonEndDate').on('select',selectDate);
	Ext.getCmp('SXPersonID').disable();
	if(ID!="") setValue(ID);
	var closeBtn=Ext.getCmp('sxcloseBtn');
	if(closeBtn!=null)
	{
		closeBtn.on('click',function(){win.close();});
	}
	var clearBtn=Ext.getCmp('sxclearBtn');
	if(clearBtn!=null)
	{
		clearBtn.on('click',clearRec);
	}
	var saveBtn=Ext.getCmp('sxsaveBtn');
	if(saveBtn!=null)
	{
		saveBtn.on('click',function()
		{
			var parr=getValue();
			if(parr!="")
			{
				parr=parr+"^PersonType|"+"P"+"^ID|"+ID;
				//alert(parr)
				var UpdateValue=document.getElementById('UpdateValue').value;
				var ret=cspRunServerMethod(UpdateValue,parr);
				alert(ret)
				if(ret=="OK")
				{
					win.close();
					findRec();
				}
			}
		});
	}
}

function statusRec()
{
	var mygrid=Ext.getCmp('mygrid1');
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
	var mygrid=Ext.getCmp('mygrid1');
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
function printRec()
{
}
function clearRec()
{
	var PersonID=Ext.getCmp('SXPersonID');
	if(PersonID!=null) PersonID.setValue("");
	PersonID.enable()
	var ChestID=Ext.getCmp('SXChestID');
	if(ChestID!=null) ChestID.setValue("");
	var PersonName=Ext.getCmp('SXPersonName');
	if(PersonName!=null) PersonName.setValue("");
	var PersonLocation=Ext.getCmp('SXPersonLocation');
	if(PersonLocation!=null) PersonLocation.setValue("");
	var Perfessional=Ext.getCmp('SXPerfessional');
	if(Perfessional!=null) Perfessional.setValue("");
	var PersonDob=Ext.getCmp('SXPersonDob');
	if(PersonDob!=null) PersonDob.setValue("");
	var PersonAddress=Ext.getCmp('SXPersonAddress');
	if(PersonAddress!=null) PersonAddress.setValue("");
	var PersonPhone=Ext.getCmp('SXPersonPhone');
	if(PersonPhone!=null) PersonPhone.setValue("");
	var PersonWard=Ext.getCmp('SXPersonWard');
	if(PersonWard!=null) PersonWard.setValue("");
	var PersonStDate=Ext.getCmp('SXPersonStDate');
	if(PersonStDate!=null) PersonStDate.setValue(new Date());
	var PersonEndDate=Ext.getCmp('SXPersonEndDate');
	if(PersonEndDate!=null) PersonEndDate.setValue(new Date());
	var PersonSex=Ext.getCmp('SXPersonSex');
	if(PersonSex!=null) PersonSex.setValue("");
	var PersonComeDate=Ext.getCmp('SXPersonComeDate');
	if(PersonComeDate!=null) PersonComeDate.setValue(new Date());
	var PersonWorkDate=Ext.getCmp('SXPersonWorkDate');
	if(PersonWorkDate!=null) PersonWorkDate.setValue(new Date());
	var PersonClass=Ext.getCmp('SXPersonClass');
	if(PersonClass!=null) PersonClass.setValue('');
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