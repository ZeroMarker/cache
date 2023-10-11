var Height = document.body.clientHeight-2;
var Width = document.body.clientWidth-2;
var REC=new Array();

//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);
var WardCombo = new Ext.form.ComboBox({
  triggerAction: 'all',
  mode: 'local',
  listWidth:280,
  store: new Ext.data.ArrayStore({
      fields: ['id','desc'],
      data:getWardArray()
  }),
  listeners:{
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
  valueField: 'id',
  displayField: 'desc'
});
function BodyLoadHandler()
{	
	CreateGrid();
	var gform=Ext.getCmp('gform').getForm();
	gform.baseParams="{frame:true}"
	//gform.doLayout();
	var UserType = session['LOGON.GROUPDESC'];
	//if(UserType=='Inpatient Nurse'||UserType == '住院护士长'||UserType.indexOf('护士长')>0)
	if(secGrpFlag=="nurhead")
	{
		var parr = session['LOGON.CTLOCID'];
		WardCombo.setValue(parr);
		WardCombo.disable();
	}
	var linkgrid=Ext.getCmp('linkgrid');
	linkgrid.getBottomToolbar().hide();
	var bedgrid=Ext.getCmp('bedgrid');
	bedgrid.getBottomToolbar().hide();
	var groupgrid=Ext.getCmp('groupgrid');
	groupgrid.getBottomToolbar().hide();
	
}
function CreateGrid()
{
	var groupgridpl=Ext.getCmp('groupgridpl');
	groupgridpl.setPosition(0,0);
	groupgridpl.setSize(500,400);
	var bedgridpl=Ext.getCmp('bedgridpl');
	bedgridpl.setPosition(501,0);
	bedgridpl.setSize(Width-501,Height);
	var linkgridpl=Ext.getCmp('linkgridpl');
	linkgridpl.setPosition(0,401);
	linkgridpl.setSize(500,Height-400);
	addToolBar();
	var groupGrid = Ext.getCmp('groupgrid');
	var bedGrid = Ext.getCmp('bedgrid');
	var linkGrid = Ext.getCmp('linkgrid');
	groupGrid.on('rowclick',findLinkRec);
	groupGrid.on('rowdblclick',setGroupRec);
	var groupLen = groupGrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < groupLen;i++){
		if(groupGrid.getColumnModel().getDataIndex(i) == 'rw'){
			groupGrid.getColumnModel().setHidden(i,true);
		}
  }
  var benLen = bedGrid.getColumnModel().getColumnCount();
  for(var i=0;i<benLen;i++){
  	if(bedGrid.getColumnModel().getDataIndex(i) == 'BedId'){
			bedGrid.getColumnModel().setHidden(i,true);
		}
		if(bedGrid.getColumnModel().getDataIndex(i) == 'WardId'){
			bedGrid.getColumnModel().setHidden(i,true);
		}
		if(bedGrid.getColumnModel().getDataIndex(i) == 'PAWardId'){
			bedGrid.getColumnModel().setHidden(i,true);
		}
  }
  var linkLen = linkGrid.getColumnModel().getColumnCount();
  for(var i = 0;i < linkLen;i++){
  	if(linkGrid.getColumnModel().getDataIndex(i) == 'BedId'){
			linkGrid.getColumnModel().setHidden(i,true);
		}
		if(linkGrid.getColumnModel().getDataIndex(i) == 'GroupId'){
			linkGrid.getColumnModel().setHidden(i,true);
		}
  }
	
}

function addToolBar()
{
	var groupgrid = Ext.getCmp("groupgrid");
	var tobar = groupgrid.getTopToolbar();
	Ext.getCmp('groupgridbut1').hide();
	Ext.getCmp('groupgridbut2').hide();
	tobar.addItem("-");
	tobar.addItem("病区",WardCombo);
	//tobar.addButton({id:'findbtn',icon:'../images/uiimages/search.png',text:'查询',handler:findRec});
	var tobar2=new Ext.Toolbar();
	tobar.addItem('-','组代码',new Ext.form.TextField({id:'TGroupCode',width:80}));
	tobar.addItem('-','组名称',new Ext.form.TextField({id:'TGroupDesc',width:80}));
	tobar2.addItem("-");tobar2.addButton({id:'addbtn',text:'增加',icon:'../images/uiimages/edit_add.png',handler:addRec});
	tobar2.addItem("-");tobar2.addButton({id:'updatebtn',text:'编辑',icon:'../images/uiimages/pencil.png',handler:updateRec});
	tobar2.addButton({id:'findbtn',icon:'../images/uiimages/search.png',text:'查询',handler:findRec});
	tobar2.addItem("-");tobar2.addButton({id:'clearbtn',text:'清屏',icon:'../images/uiimages/clearscreen.png',handler:clearGroupRec});
	tobar2.addItem("-");tobar2.addButton({id:'validbtn',text:'作废',icon:'../images/uiimages/cancel.png',handler:validRec});
	tobar2.render(groupgrid.tbar);
	tobar.doLayout();
	var bedgrid = Ext.getCmp("bedgrid");
	var tobar = bedgrid.getTopToolbar();
	Ext.getCmp('bedgridbut1').hide();
	Ext.getCmp('bedgridbut2').hide();
	tobar.addItem("-");
	tobar.addItem(new Ext.form.Checkbox({id:'LinkValid'}),"显示已关联")
	tobar.addItem("-");
	tobar.addButton({id:'findbtn2',text:'查询',icon:'../images/uiimages/search.png',handler:findBedRec});
	tobar.addItem("-");
	tobar.addButton({id:'linkbtn',text:'关联',icon:'../images/uiimages/link.png',handler:linkRec});
	tobar.doLayout();
	var linkgrid = Ext.getCmp("linkgrid");
	var tobar = linkgrid.getTopToolbar();
	Ext.getCmp('linkgridbut1').hide();
	Ext.getCmp('linkgridbut2').hide();
	tobar.hide();
	tobar.doLayout();
	Ext.getCmp('updatebtn').disable();
}

function getWardArray()
{
	REC = new Array();
	var GetQueryData = document.getElementById("GetQueryData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurRosteringComm.FindAllWardData", "parr$"+"", "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i=i+3,j++)
	{
		arr[j] = new Array(parseInt(REC[i].toString()),REC[i+2].toString());
	}
	return arr;
}
function AddRec1(a1,a2,a3){
	REC.push(a1,a2,a3);
}

function findRec()
{
	REC=new Array();
	var WardId=WardCombo.getValue();
	if(WardId==""){ alert("请选择病区!");return; }
	var GetQueryData=document.getElementById('GetQueryData').value;
	cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurBedGroup.FindGroupData","parr$"+WardId,"AddRec2");
	Ext.getCmp('groupgrid').store.loadData(REC);
}
function AddRec2(a)
{
	var array=SplitStr(a);
	REC.push({
		GroupCode:array['GroupCode'],
		GroupDesc:array['GroupDesc'],
		GroupWard:array['WardCode'],
		LinkBed:array['BedDesc'],
		GroupValid:array['GroupValid'],
		rw:array['ID']
	});
}
function findBedRec()
{
	REC=new Array();
	var WardId=WardCombo.getValue();
	if(WardId==""){ alert("请选择病区!");return; }
	var LinkValid=Ext.getCmp('LinkValid').getValue()
	if(LinkValid==true) LinkValid="Y";
	else  LinkValid="N";
	var GetQueryData=document.getElementById('GetQueryData').value;
	var parr=WardId+"^"+LinkValid;
	cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurBedGroup.FindPACBed","parr$"+parr,"AddBedRec");
	Ext.getCmp('bedgrid').store.loadData(REC);
	Ext.getCmp('bedgrid').store.sort('BedCode','ASC')
}
function AddBedRec(a)
{
	var array=SplitStr(a);
	REC.push({
		BedCode:array['BedCode'],
		RoomCode:array['BedRoom'],
		BedId:array['BedId'],
		WardId:array['WardId'],
		PAWardId:array['PAWardId']
	});
}
function addRec()
{
	var WardId=WardCombo.getValue();
	if(WardId==""){ alert("请选择病区!");return; }
	var GroupCode=Ext.getCmp('TGroupCode').getValue();
	if(GroupCode==""){alert("请填写组代码!"); return; }
	var GroupDesc=Ext.getCmp('TGroupDesc').getValue();
	if(GroupDesc==""){alert("请填写组名称!"); return; }
	var parr="WardId|"+WardId+"^GroupCode|"+GroupCode+"^GroupDesc|"+GroupDesc;
	var savegroup=document.getElementById('SaveGroup').value;
	var b=tkMakeServerCall("DHCMGNUR.MgNurBedGroup","isValue",WardId,GroupCode);
	if(b==1){
		alert("组代码已存在,请重新填写!");
		return;
	}
	var a=cspRunServerMethod(savegroup,parr);
	if(a==1){alert('新建成功!')}
	else {alert('新建失败!')}
	findRec();
}
function updateRec()
{
	var groupgrid=Ext.getCmp('groupgrid');
	var selections=groupgrid.getSelectionModel().getSelections();
	if(selections.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var ID=selections[0].get('rw');
	var GroupCode=Ext.getCmp('TGroupCode').getValue();
	if(GroupCode==""){alert("请填写组代码!"); return; }
	var GroupDesc=Ext.getCmp('TGroupDesc').getValue();
	if(GroupDesc==""){alert("请填写组名称!"); return; }
	var parr="ID|"+ID+"^GroupCode|"+GroupCode+"^GroupDesc|"+GroupDesc;
	var savegroup=document.getElementById('SaveGroup').value;
	var a=cspRunServerMethod(savegroup,parr);
	if(a==1){alert('修改成功!')}
	else {alert('修改失败!')}
	setBtnStatus();
	findRec();
}
function setBtnStatus()
{
	Ext.getCmp('addbtn').enable();
	Ext.getCmp('updatebtn').disable();
}
function validRec()
{
	//alert(1)
	var groupgrid=Ext.getCmp('groupgrid');
	var selections=groupgrid.getSelectionModel().getSelections();
	if(selections.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var ID=selections[0].get('rw');
	if(!ID||ID==undefined){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var parr=ID+"^N";
	var setMark=document.getElementById('setMark').value;
	if (confirm('确定作废选中的项？')) {
		var a=cspRunServerMethod(setMark,parr);
		if(a==1){
			alert("作废成功!");
			Ext.getCmp('linkgrid').store.removeAll();
		}else{
			alert("作废失败!");
		}
		findRec();
	}	
	setBtnStatus();		
}

function linkRec()
{
	var groupgrid=Ext.getCmp('groupgrid');
	var bedgrid=Ext.getCmp('bedgrid');
	var selections1=groupgrid.getSelectionModel().getSelections();
	var selections2=bedgrid.getSelectionModel().getSelections();
	if(selections1.length!=1){alert('请在组列表选择一条记录!'); return;}
	var GroupId=selections1[0].get('rw');
	if(selections2.length==0){alert('请在床位列表至少选择一条记录!'); return;}
	var parr=GroupId+"^"+selections2[0].get('BedId');
	for(var i=1;i<selections2.length;i++)
	{
		parr=parr+","+selections2[i].get('BedId');
	}
	var linkBed=document.getElementById('linkBed').value;
	var a=cspRunServerMethod(linkBed,parr);
	if(a==1){
		alert('关联成功!');
	}else{
		alert('关联失败!')
	}
	findRec();
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

function findLinkRec()
{
	//alert('click')
	REC=new Array(); 
	var groupgrid=Ext.getCmp('groupgrid');
	var selections=groupgrid.getSelectionModel().getSelections();
	var GroupId=selections[0].get('rw');
	var GetQueryData=document.getElementById('GetQueryData').value;
	cspRunServerMethod(GetQueryData,"DHCMGNUR.MgNurBedGroup.FindGroupLinkBed","parr$"+GroupId,"AddLinkBedRec");
	Ext.getCmp('linkgrid').store.loadData(REC);
	findBedRec();
}
function AddLinkBedRec(a)
{
	var array=SplitStr(a);
	REC.push({
		BedCode:array['BedCode'],
		RoomCode:array['BedRoom'],
		BedId:array['BedId'],
		GroupId:array['GroupId']
	});
}

function setGroupRec()
{
	var groupgrid=Ext.getCmp('groupgrid');
	var selections=groupgrid.getSelectionModel().getSelections();
	var GroupCode=selections[0].get('GroupCode');
	var GroupDesc=selections[0].get('GroupDesc');
	Ext.getCmp('TGroupCode').setValue(GroupCode);
	Ext.getCmp('TGroupDesc').setValue(GroupDesc);
	Ext.getCmp('addbtn').disable();
	Ext.getCmp('updatebtn').enable();
}
function clearGroupRec()
{
	Ext.getCmp('TGroupCode').setValue("");
	Ext.getCmp('TGroupDesc').setValue("");
	Ext.getCmp('addbtn').enable();
	Ext.getCmp('updatebtn').disable();
}