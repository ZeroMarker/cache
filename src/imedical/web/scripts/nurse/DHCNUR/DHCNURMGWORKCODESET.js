var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
var REC = new Array();
function BodyLoadHandler()
{
	var mygridpl=Ext.getCmp("mygridpl");
	mygridpl.setHeight(Height);
	mygridpl.setWidth(Width);
	mygridpl.setPosition(0,0);
	createGrid();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.on('rowdblclick',rowdblclick);
	Ext.getCmp('updateBtn').disable();
}
function createGrid()
{
	var mygrid = Ext.getCmp("mygrid");
	var tobar = mygrid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but2=Ext.getCmp("mygridbut2");
	but2.hide();
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'ValidCheck'}),'显示作废记录')
	tobar.addItem("-");
	tobar.addButton({id:'findbtn',text:'查询',handler:function(){findRec();}});
	tobar.addItem("-");
	tobar.addButton({id:'validbtn',text:'作废',handler:function(){setMarks("N");}});
	tobar.addItem("-");
	tobar.addButton({id:'cvalidbtn',text:'撤销作废',handler:function(){setMarks("Y");}});
	var tobar2=new Ext.Toolbar();
	tobar2.addItem("-");
	tobar2.addItem("代码:",new Ext.form.TextField({id:'RPostCode',width:100}));
	tobar2.addItem("-");
	tobar2.addItem("人数:",new Ext.form.TextField({id:'RPostNeeds',width:30,value:1}));
	tobar2.addItem("-");
	tobar2.addItem("类别:",new Ext.form.ComboBox({
		id:'RPIsNight',
    triggerAction: 'all',
    lazyRender:true,
    mode: 'local',
    editable:false,
    width:50,
    store: new Ext.data.ArrayStore({
        fields: ['id','desc'],
        data: [['N', '白班'], ['Y', '夜班']]
    }),
    valueField: 'id',
    displayField: 'desc'
	}));
	tobar2.addItem("-");
	tobar2.addItem("小时数:",new Ext.form.TextField({id:'RPostHours',width:30,value:8}));
	//Ext.getCmp('RPostHours').disable();
	tobar2.addItem("-");
	tobar2.addItem("备注:",new Ext.form.TextField({id:'RPostRemarks',width:200}));
	tobar2.addItem("-");
	tobar2.addItem(new Ext.form.TextField({id:'RPostId',width:50,hidden:true}));
	tobar2.addButton({id:'addBtn',text:'增加',icon:'../Image/light/add.png',handler:saveRec});
	tobar2.addItem("-");
	tobar2.addButton({id:'updateBtn',text:'修改',icon:'../Image/light/write.png',handler:updateRec});
	tobar2.addItem("-");
	tobar2.addButton({id:'cancleBtn',text:'清空',icon:'../Image/light/refuse.ico',handler:clearRec});
	tobar2.render(mygrid.tbar);
	tobar.doLayout();
	var mygrid=Ext.getCmp('mygrid');
	mygrid.getBottomToolbar().hide();
}
function saveRec()
{
	var mygrid =Ext.getCmp('mygrid');
	var RPostCode=Ext.getCmp("RPostCode").getValue();
	if(RPostCode=="")
	{
		alert("岗位代码不能为空!");
		return;
	}
	var CheckRepeat= document.getElementById('CheckRepeat').value;
	var a=cspRunServerMethod(CheckRepeat,RPostCode);
	if(a!=0)
	{
		alert("该岗位代码已存在!");
		return;
	}
	var RPostNeeds=Ext.getCmp("RPostNeeds").getValue();
	if(RPostNeeds=="")
	{
		alert("需要人数不能为空!");
		return;
	}
	else{
		if(!RPostNeeds.match(/^[1-9][0-9]*$/))
		{
			alert("需要人数必须为整数数字!");
			return;
		}
	}
	var RPIsNight=Ext.getCmp("RPIsNight").getValue();
	if(RPIsNight=="")
	{
		alert("白班夜班类别不能为空!");
		return;
	}
	var RPostHours=Ext.getCmp("RPostHours").getValue();
	if(RPostHours){
		var reg=/^\d+$/;
		if(!reg.test(RPostHours))
		{
			alert("请输入有效小时数！");
			return false;
		}	
	}else{
		Ext.Msg.alert('提示','小时数不能为空！');
		return;
	}
	
	var RPostRemarks=Ext.getCmp("RPostRemarks").getValue();
	var PostOrder=mygrid.store.getTotalCount()+1;
	var parr="PostCode|"+RPostCode+"^PostNeedNurse|"+RPostNeeds+"^PostIsNight|"+RPIsNight+"^PostHourNum|"+RPostHours+"^PostRemarks|"+RPostRemarks+"^PostOrder|"+PostOrder
	var SavePostData=document.getElementById('SavePostData').value;
	var ret=cspRunServerMethod(SavePostData,parr);
	findRec();
}

function updateRec()
{
	var mygrid =Ext.getCmp('mygrid');
	var RPostCode=Ext.getCmp("RPostCode").getValue();
	if(RPostCode=="")
	{
		alert("岗位代码不能为空!");
		return;
	}
	var RPostNeeds=Ext.getCmp("RPostNeeds").getValue();
	if(RPostNeeds=="")
	{
		alert("需要人数不能为空!");
		return;
	}
	else{
		if(!RPostNeeds.match(/^[1-9][0-9]*$/))
		{
			alert("需要人数必须为整数数字!");
			return;
		}
	}
	var RPIsNight=Ext.getCmp("RPIsNight").getValue();
	if(RPIsNight=="")
	{
		alert("白班夜班类别不能为空!");
		return;
	}
	var RPostHours=Ext.getCmp("RPostHours").getValue();
	var RPostRemarks=Ext.getCmp("RPostRemarks").getValue();
	var RPostId=Ext.getCmp("RPostId").getValue();
	var parr="PostCode|"+RPostCode+"^PostNeedNurse|"+RPostNeeds+"^PostIsNight|"+RPIsNight+"^PostHourNum|"+RPostHours+"^PostRemarks|"+RPostRemarks+"^ID|"+RPostId;
	var UpdatePostData=document.getElementById('UpdatePostData').value;
	var ret=cspRunServerMethod(UpdatePostData,parr);
	findRec();
}
function clearRec(){
	Ext.getCmp("RPostCode").setValue("");
	Ext.getCmp("RPostNeeds").setValue("");
	Ext.getCmp("RPIsNight").setValue("");
	Ext.getCmp("RPostHours").setValue("8");
	Ext.getCmp("RPostRemarks").setValue("");
	Ext.getCmp("RPostId").setValue("");
	Ext.getCmp('addBtn').enable();
	Ext.getCmp('updateBtn').disable();
}
function findRec()
{
	REC = new Array();
	var mygrid = Ext.getCmp("mygrid");
	var ValidCheck = Ext.getCmp("ValidCheck").getValue();
	var parr="";
	if(ValidCheck)	parr = "Y";
	else	parr = "N";
	var GetQueryData = document.getElementById("getQueryData");
	var a = cspRunServerMethod(GetQueryData.value,"DHCMGNUR.MgNurPost.FindPostData", "parr$"+parr, "AddRec");
	mygrid.store.loadData(REC);
}

function AddRec(a)
{
	var array=SplitStr(a);
	REC.push({
		Code:array['PostCode'],
		NeedPersonNum:array['PostNeedNurse'],
		NigthWork:array['PostIsNight'],
		Remarks:array['PostRemarks'],
		HourNum:array['PostHourNum'],
		NotUse:array['PostValid'],
		OrderNo:array['PostOrder'],
		rw:array['ID']
	});
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

function RecArraySort(array,Str)
{
	for(i=0;i<array.length;i++)
	{
		for(j=0;j<array.length-i-1;j++)
		{
			if(parseInt(array[j][Str])>parseInt(array[j+1][Str]))
			{
				var temp = array[j+1];
				array[j+1]=array[j];
				array[j]=temp;
			}
		}
	}
	return array;
}
function rowdblclick(mygrid,rowIndex,e)
{
	var row=mygrid.store.getAt(rowIndex);
	Ext.getCmp("RPostCode").setValue(row.get('Code'));
	Ext.getCmp("RPostNeeds").setValue(row.get('NeedPersonNum'));
	Ext.getCmp("RPIsNight").setValue(row.get('NigthWork'));
	Ext.getCmp("RPostHours").setValue(row.get('HourNum'));
	Ext.getCmp("RPostRemarks").setValue(row.get('Remarks'));
	Ext.getCmp("RPostId").setValue(row.get('rw'));
	Ext.getCmp('updateBtn').enable();
	Ext.getCmp('addBtn').disable();
}

function setMarks(MarksVal)
{
	var mygrid=Ext.getCmp('mygrid');
	var setMarks=document.getElementById('SetMarks').value;
	var selections=mygrid.getSelectionModel().getSelections();
	if(selections.length==0)
	{
		alert("请选择一条记录");
		return;
	}
	if(MarksVal=='N'&&selections[0].get('NotUse')=="N")
	{
		alert('不可重复作废！');
		return;
	}
	if(MarksVal=='Y'&&selections[0].get('NotUse')=="Y")
	{
		alert('已是可用状态，不需要撤消作废！');
		return;
	}
	var selectedRow=mygrid.getSelectionModel().getSelected();
	var flag=selectedRow.get('NotUse');
	//alert(flag)
	var Id=selectedRow.get('rw');
	var Marks="Valid";
	var parr=Id+"^"+Marks+"^"+MarksVal;
	cspRunServerMethod(setMarks,parr);
	findRec();
}