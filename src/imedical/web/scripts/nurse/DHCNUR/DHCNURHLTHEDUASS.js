//document.body.onload=BodyLoadHandler;
var REC = new Array();
var DescArray = new Array();
function BodyLoadHandler()
{
	//setsize("mygrid1pl","gform","mygrid",0);
	var Height = document.body.clientHeight-5;
	var Width = document.body.clientWidth-3;
	var mygrid1pl=Ext.getCmp("mygrid1pl");
	mygrid1pl.setHeight(Height/3);
	mygrid1pl.setWidth(Width);
	mygrid1pl.setPosition(0,0);
	var mygrid2pl=Ext.getCmp("mygrid2pl");
	mygrid2pl.setHeight(Height*2/3);
	mygrid2pl.setWidth(Width);
	mygrid2pl.setPosition(0,Height/3+1);
	myGridFun("mygrid1");
	findData("mygrid1");
	myGridFun("mygrid2");
	findData("mygrid2");
	Ext.getCmp("mygrid1").on("rowdblclick",rowdblclick1);
	Ext.getCmp("mygrid2").on("rowdblclick",rowdblclick2);
}
function rowdblclick1()
{
	var mygrid = Ext.getCmp("mygrid1");
	var selectedRow = mygrid.getSelectionModel().getSelected();
	var parr = selectedRow.get("EANARowIDData");
	if(parr!=null)
	{
  	updateData("mygrid1");
  }
}
function rowdblclick2()
{
	var mygrid = Ext.getCmp("mygrid2");
	var selectedRow = mygrid.getSelectionModel().getSelected();
	var parr = selectedRow.get("HEARowIDData");
	if(parr!=null)
	{
  	updateData("mygrid2");
  }
}
var EanaNurSign="";
var HEATeacherRowId="";
function cmbkey1(field, e)
{
	if (e.getKey() == Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		if(pp!=""&&pp!=null){
			EanaNurSign = pp;
			getlistdata(pp,field);
		}
		else{
			alert("评估者不能为空!");
		}
		
	}
}
function cmbkey2(field, e)
{
	if (e.getKey() == Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		if(pp!=""&&pp!=null){
			HEATeacherRowId = pp;
			getlistdata(pp,field);
		}
		else{
			alert("教育者不能为空!");
		}
	//	alert(ret);
		
	}
}
var person=new Array();
function getlistdata(p,cmb)
{
	person = new Array();
	var GetPerson =document.getElementById('GetPerson');
	//debugger;
  var ret=cspRunServerMethod(GetPerson.value,p);
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addperson(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}
function myGridFun(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	if(mygrid=="mygrid1")
	{
		var ret = getPatientInfo();
		var hh = ret.split("^");
		var PatientInfo ="教育能力需求评估&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp床位:"+hh[4]+"&nbsp&nbsp&nbsp&nbsp&nbsp姓名:"+hh[0]+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp住院号:"+hh[1]+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp性别:"+hh[2]+"&nbsp&nbsp&nbsp年龄:"+hh[3]+"&nbsp&nbsp&nbsp科室:"+hh[5];
		grid.setTitle(PatientInfo);
	}
	var tobar=grid.getTopToolbar();
	var but1=Ext.getCmp(mygrid+"but1");
	but1.hide();
	var but=Ext.getCmp(mygrid+"but2");
	but.hide();
	var tbar2=new Ext.Toolbar({});
	//var UserType=session['LOGON.GROUPDESC']
	/*var combobox1=Ext.form.ComboBox({
		name:combobox1,
		id:combobox1
	});
	if(mygrid=="mygrid1"&&(UserType=="Demo Group"||UserType=="护理部主任"||UserType=="护理部"))
	{
		tbar2.addField({
		text:'',
		handler:function(){},
		id:'patientInfo'
	});
	tbar2.addItem("-");*/
	tbar2.addButton({
		text:'新建',
		handler:function(){addData(mygrid);},
		id:mygrid+'addDatabtn'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'修改',
		id:mygrid+'editBtn',
		handler:function(){updateData(mygrid);}
	});
	tbar2.addItem("-");
	if(mygrid=="mygrid2"){
		tbar2.addButton(
		{
			text:"查询",
			handler:function(){findHEAData();},
			id:mygrid+'btnSch'
		});
		tbar2.addItem("-");
		tbar2.addButton(
		{
			text:"打印",
			handler:function(){printNurRecTest();},
			id:mygrid+'btnPrt'
		});
		tbar2.addItem("-");
	}
	tbar2.addButton(
	{
		text:"作废",
		handler:function(){deleteData(mygrid);findData(mygrid);},
		id:mygrid+'btnDlt'
	});
	tbar2.render(grid.tbar);
	tobar.doLayout();
}
function checkWindows1()
{
	//alert(Extnamestr);"DHCNurGetHEAData"
	var a=cspRunServerMethod(pdata1,"","DHCNurGetENANData","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '教育能力需求评估信息',
		id : "gformgrid1",
		x:10,y:2,
		width : 600,
		height : 530,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr]
	});
	return window;
}
var HEAProject = "";
function getArray()
{
	getDocAdviceData();
	var array = new Array();
	var j = 0;
	for(i=0;i<REC.length;i++)
	{
		var icoImg;
		if(REC[i].toString()=="new")
		{
			icoImg='<img src="../scripts/nurse/image/newdocadvice.gif">';
		}
		else
		{
			icoImg="";
		}
		array[j]=new Array(icoImg,REC[++i].toString(),REC[++i].toString(),REC[++i].toString());
		j++;
	}
	return array;
}

function createTable()
{
	getDocAdviceData();
	var colModel = new Ext.grid.ColumnModel([
    { header: "", width: 25, sortable: true,dataIndex: 'DocAdvcsign'},
    { header: "医嘱信息", width: 90, sortable: true,dataIndex: 'DocAdvcInfo'},
    { header: "开始日期", width: 70, sortable: true, dataIndex: 'DocAdvcStDate'},
    { header: "开始时间", width: 70, sortable: true, dataIndex: 'DocAdvcStTime'}
 	]);
	var store = new Ext.data.Store({
    proxy: new Ext.data.MemoryProxy(getArray()),
    sortInfo:{field: "DocAdvcStDate", direction: "DESC"},
    reader: new Ext.data.ArrayReader({}, [
    	{name: 'DocAdvcsign'},
      {name: 'DocAdvcInfo'},
      {name: 'DocAdvcStDate'},
      {name: 'DocAdvcStTime'}
    ])
	});
	store.load();
	var table = new Ext.grid.GridPanel({
		renderTo:'mygrid2',
		id:'mygrid3',
		x:560,y:10,
		height: 250,
		width: 255,
		store: store,
		cm: colModel
	});
	return table;
}

function createNode(Id,Name)
{
	var node=new Ext.tree.TreeNode({ 
  		id:Id,  
  		text:Name,
  		checked:false
  		//icon:image
  	});
  return node;
}
function createTree()
{
	REC = new Array();
  var root=new Ext.tree.TreeNode({
    text:'健康教育项目',
    id:'HEAP',
    expanded:true
  });
  var folder = '../scripts/nurse/image/folder.gif';
  var leaf = '../scripts/nurse/image/leaf.gif'
  //var folder_open = '../scripts/nurse/image/folder-open.gif'
	var GetQueryData = document.getElementById("getQureyData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindAllWardData", "parr$", "AddRec4");
	var arr = REC;
	var wardid = session['LOGON.CTLOCID'];
	var warddesc = CheckWard(arr,wardid);
	var node = createNode("Ward"+wardid,warddesc,folder);
  root.appendChild(node);
  for(i=0;i<arr.length;i=i+3)
  {
  	if(arr[i].toString()!=wardid)
  	{
  		var node = createNode("Ward"+arr[i].toString(),arr[i+2].toString(),folder);
  		root.appendChild(node);
//  	REC = new Array();
//		var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemOne", "parr$"+arr[i].toString(), "AddRec4");
//		var arr2 = REC;
//  	for(j=0;j<arr2.length;j=j+3)
//  	{
//  		var childnode = createNode("ItemOne"+arr2[j].toString(),arr2[j+1].toString(),folder);
//  		node.appendChild(childnode);
//  		REC = new Array();
//			var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemTwo", "parr$"+arr2[j].toString(), "AddRec4");
//			var arr3 = REC;
//  		for(k=0;k<arr3.length;k=k+3)
//  		{
//  			childnode.appendChild(createNode("ItemTwo"+arr3[k].toString(),arr3[k+1].toString()),leaf);
//  		}
//  	}
		}
  }
	var tree=new Ext.tree.TreePanel({
		id:'projecttree',
  	title:'健康教育项目',
  	x:10,y:10,
  	width:170,
  	height:500,
  	enableDD:true,
  	appplyTo:document.body,
  	root:root, 
  	rootVisible:false,
  	autoScroll : true,
  	animate:true,
  	//header:false,
  	loader:new Ext.tree.TreeLoader(),
  	listeners :{
  		click:function(node)
  		{
  			if(!node.expanded) node.expand();
  			else node.collapse(); 
  		},
  		collapsenode:function(node){
  			node.removeAll();
  		},
  		expandnode:function(node){
////  			var folder = '../scripts/nurse/image/folder.gif';
////  			var leaf = '../scripts/nurse/image/leaf.gif'
////  			node.icon=leaf;
  			if(node.id.indexOf("Ward")!=-1)
  			{
  				var wardid = node.id.substring(4,node.id.length);
  				REC = new Array();
					var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemOne", "parr$"+wardid, "AddRec4");
					var arr2 = REC;
			  	for(j=0;j<arr2.length;j=j+3)
			  	{
			  		var childnode = createNode("ItemOne"+arr2[j].toString(),arr2[j+1].toString());
			  		node.appendChild(childnode);
			  	}
  			}
  			if(node.id.indexOf("ItemOne")!=-1)
  			{
  				REC = new Array();
  				var item1id=node.id.substring(7,node.id.length);
					var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemTwo", "parr$"+item1id, "AddRec4");
					var arr3 = REC;
		  		for(k=0;k<arr3.length;k=k+3)
		  		{
		  			node.appendChild(createNode("ItemTwo"+arr3[k].toString(),arr3[k+1].toString()));
		  		}
  			}
  			if(node.id.indexOf("ItemTwo")!=-1)
  			{
  				REC=new Array();
  				var item2id = node.id.substring(7,node.id.length);
  				var a = cspRunServerMethod(GetQueryData.value,"DHCMGNUR.DHCNurHEAPIItem:FindHEAPIIData", "parr$"+item2id, "AddRec3");
  				var arr4 = REC;
		  		for(k=0;k<arr4.length;k=k+4)
		  		{
		  			node.appendChild(createNode("ItemThree"+arr4[k+3].toString(),arr4[k].toString()));
		  		}
  			}
  		},
  		checkchange:function(node,checkstatu){
  			if(checkstatu){
  				//alert(node.id);
  				node.expand();
//  				if(node.id==root.id)
//  				{
//  					node.getUI().checkbox.checked = false;
//        		node.attributes.checked = false;
//        		alert("请选底层项目!!!");
//        		return;
//  				}
  				var pNode = node.parentNode;
//  				if(pNode.getUI().checkbox!=null&&pNode.id==root.id)
//  				{
//  					pNode.getUI().checkbox.checked = false;
//        		pNode.attributes.checked = false;
//        		alert("请选底层项目!!!");
//        		return;
//  				}
//  				var ppNode = pNode.parentNode;
//  				if(ppNode.getUI().checkbox!=null&&ppNode.id==root.id)
//  				{
//  					ppNode.getUI().checkbox.checked = true;
//	        	ppNode.attributes.checked = true;
//	        	alert("请选底层项目!!!");
//	        	return;
//  				}
  				if(pNode.id!=root.id)
  				{
  					pNode.getUI().checkbox.checked = true;
        		pNode.attributes.checked = true;
 						var ppNode = pNode.parentNode;
 						if(ppNode.id!=root.id)
	  				{
	  					ppNode.getUI().checkbox.checked = true;
	        		ppNode.attributes.checked = true;
	        		var pppNode = ppNode.parentNode;
 							if(pppNode.id!=root.id)
	  					{
		  					pppNode.getUI().checkbox.checked = true;
		        		pppNode.attributes.checked = true;
		  				}
	  				}
  				}
  				if(node.id.substring(0,7)=="ItemTwo"&&!node.isExpandable())
	 				{
	 					var getvalue=document.getElementById("getHEAPData");
	 					var Item1RowId = (node.id).substring(7,(node.id).length)
	 					//alert(Item1RowId);
	 					var ret = cspRunServerMethod(getvalue.value,Item1RowId);
	 					//alert(ret);
	 					DescArray.push(new Array(node.id,node.text,replaceStrAll(ret,"_n","\n")));
//	 					var ProjDescribe = Ext.getCmp("ProjDescribe");
//	 					if(ProjDescribe.getValue()!="")
//	 					{
//		 					if(ret!=""){ProjDescribe.setValue(ProjDescribe.getValue()+"\n\n"+node.text+":"+ret);}//alert(ret);}
//		 				}
//		 				else{
//		 					if(ret!=""){ProjDescribe.setValue(node.text+":"+ret);}//alert(ret);}
//		 				}
 						//alert(HEAProject);
	 				}
	 				if(node.id.substring(0,9)=="ItemThree"&&!node.isExpandable())
	 				{
	 					var getvalue=document.getElementById("getHEAPIIData");
	 					var Item3RowId = (node.id).substring(9,(node.id).length)
	 					//alert(Item1RowId);
	 					var ret = cspRunServerMethod(getvalue.value,Item3RowId);
	 					//alert(ret);
	 					var a = ret.split("^");
	 					DescArray.push(new Array(node.id,node.text,replaceStrAll(a[2],"_n","\n")));
	 				}
  			}
  			else{
  				DescArray = deleteArray(DescArray,node.id);
  				var cNodes = node.childNodes;
  				//alert(cNodes.length)
  				for(k=0;k<cNodes.length;k++)
  				{
  					var cNode = cNodes[k];
  					if(cNode.getUI().checkbox!=null)
  					{
  						if(cNode.getUI().checkbox.checked){DescArray = deleteArray(DescArray,cNode.id);}
	  					cNode.getUI().checkbox.checked=false;
	  					cNode.attributes.checked = false;
	  					var ccNodes = cNode.childNodes;
	  					if(ccNodes.length!=0){
			  				for(j=0;j<ccNodes.length;j++)
			  				{
			  					var ccNode = ccNodes[j];
			  					if(ccNode.getUI().checkbox.checked){DescArray = deleteArray(DescArray,ccNode.id);}
			  					ccNode.getUI().checkbox.checked=false;
			  					ccNode.attributes.checked = false;
					  			var cccNodes = ccNode.childNodes;
			  					if(cccNodes.length!=0){
					  				for(jj=0;jj<cccNodes.length;jj++)
					  				{
					  					var cccNode = cccNodes[jj];
					  					if(cccNode.getUI().checkbox.checked){DescArray = deleteArray(DescArray,cccNode.id);}
					  					cccNode.getUI().checkbox.checked=false;
					  					cccNode.attributes.checked = false;
					  				}
					  			}
			  				}
			  			}
			  		}
		  		}
  				var pNode = node.parentNode;
  				var flag1 = false;
  				if(pNode.id!=root.id)
  				{
  					var cNodes = pNode.childNodes;
	  				for(ii=0;ii<cNodes.length;ii++)
	  				{
	  					var cNode = cNodes[ii];
	  					if(cNode.getUI().checkbox.checked==true)
	  					{
		  					flag1=true;
				  		}
				  	}
				  	if(flag1==false)
				  	{
				  		pNode.getUI().checkbox.checked = false;
        			pNode.attributes.checked = false;
        			var ppNode = pNode.parentNode;
        			var flag2=false;
 							if(ppNode.id!=root.id)
	  					{
	  						var ccNodes = ppNode.childNodes;
			  				for(ij=0;ij<ccNodes.length;ij++)
			  				{
			  					var ccNode = ccNodes[ij];
			  					if(ccNode.getUI().checkbox.checked==true)
			  					{
				  					flag2=true;
						  		}
						  	}
						  	if(flag2==false)
						  	{
						  		ppNode.getUI().checkbox.checked = false;
		        			ppNode.attributes.checked = false;
		        			var pppNode = ppNode.parentNode;
		        			var flag3=false;
		        			if(pppNode.id!=root.id)
	  							{
	  								var cccNodes = pppNode.childNodes;
			  						for(kk=0;kk<cccNodes.length;kk++)
			  						{
			  							var cccNode = cccNodes[kk];
			  							if(cccNode.getUI().checkbox.checked==true)
			  							{
				  							flag3=true;
						  				}
						  			}
								  	if(flag3==false)
								  	{
								  		pppNode.getUI().checkbox.checked = false;
				        			pppNode.attributes.checked = false;
				        		}
				        	}
			  				}
			  			}
				  	}
  				}
  			}
  			var ProjDescribe = Ext.getCmp("ProjDescribe");
				ProjDescribe.setValue("");
				for(i=0;i<DescArray.length;i++)
				{
 					if(DescArray[i][2]!="") 
 					{
 						ProjDescribe.setValue(ProjDescribe.getValue()+DescArray[i][1]+": \n"+DescArray[i][2]+"\n\n");
 					}
 				}
  		}
//  		checkchange:function(node,checked){
//  			if(checked)
//  			{
//   				var checkedNodes = tree.getChecked();
//   				for(i=0;i<checkedNodes.length;i++)
//   				{
//    				var checkeNode = checkedNodes[i];
//      			if(node.id!=checkeNode.id)
//       			{	
//       				checkeNode.getUI().checkbox.checked = false;
//    					checkeNode.attributes.checked = false;
//       				var pNode = checkeNode.parentNode;
//       				if(pNode.id!=root.id)
//       				{
//       					pNode.getUI().checkbox.checked = false;
//       					pNode.attributes.checked = false;
//       					var ppNode = pNode.parentNode;
//       					if(ppNode.id!=root.id)
//       					{
//       						ppNode.getUI().checkbox.checked = false;
//    							ppNode.attributes.checked = false;
//    						}
//    					}
//       				tree.fireEvent('check', checkeNode, false);
//    		 		}
//    		 		var pnode = node.parentNode;
//	 					if(pnode.id!=root.id)
//	 					{
//	 						pnode.getUI().checkbox.checked=node.getUI().checkbox.checked;
//	 						pnode.attributes.checked = node.attributes.checked;
//	 						if(pnode.parentNode.id!=root.id)
//	 						{
//	 							pnode.parentNode.getUI().checkbox.checked=node.getUI().checkbox.checked;
//	 							pnode.parentNode.attributes.checked = node.attributes.checked;
//	 						}
//	 					}
//    	 		}
//	 				//alert(node.id.substring(0,5));
//	 				//alert(node.id.substring(0,7));
//	 				if(node.id.substring(0,7)=="ItemTwo")
//	 				{
//	 					var getvalue=document.getElementById("getHEAPData");
//	 					var Item1RowId = (node.id).substring(7,(node.id).length)
//	 					//alert(Item1RowId);
//	 					var ret = cspRunServerMethod(getvalue.value,Item1RowId);
//	 					//alert(ret);
//	 					var ProjDescribe = Ext.getCmp("ProjDescribe");
//	 					if(ret!=""){ProjDescribe.setValue(ret);}//alert(ret);}
//	 					else{ProjDescribe.setValue("");}
//	 					HEAProject = pnode.id.substring(7,(pnode.id).length)+"||"+node.id.substring(7,(node.id).length);
//	 					//alert(HEAProject);
//	 				}
//  			}
//  			else{
//  				var cNodes = node.childNodes;
//  				alert(cNodes.length);
//  				if(cNodes.length!=0){
//	  				for(i=0;i<cNodes.length;i++)
//	  				{
//	  					var cNode = cNodes[i];
//	  					if(cNode.getUI().checkbox!=null)
//	  					{
//		  					cNode.getUI().checkbox.checked=false;
//		  					cNode.attributes.checked = false;
//		  					var ccNodes = cNode.childNodes;
//		  					if(ccNodes.length!=0){
//				  				for(i=0;i<ccNodes.length;i++)
//				  				{
//				  					var ccNode = ccNodes[i];
//				  					ccNode.getUI().checkbox.checked=false;
//				  					ccNode.attributes.checked = false;
//				  				}
//				  			}
//				  		}
//		  			}
//	  			}
//  				var pNode = node.parentNode;
//  				if(pNode.id!=root.id){
//	  				pNode.getUI().checkbox.checked=false;
//	  				pNode.attributes.checked = false;
//	  				var ppNode = pNode.parentNode;
//   					if(ppNode.id!=root.id)
//   					{
//   						ppNode.getUI().checkbox.checked = false;
//							ppNode.attributes.checked = false;
//						}
//	  			}
//  			}
//			}
		}
	});
	return tree;
}
function replaceStrAll(Str,strExp1,strExp2)
{
	while(Str.indexOf(strExp1)!=-1)
	{
		Str=Str.replace(strExp1,strExp2);
	}
	return Str;
}
function checkWindows2()
{
	var tree = createTree();
	var DocAdvice = createTable();
	DescArray = new Array();
	var a=cspRunServerMethod(pdata1,"","DHCNurSetHEAData","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '健康教育评估信息',
		id : "gformgrid2",
		x:10,y:2,
		width : 840,
		height : 570,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr,DocAdvice,tree]
	});
	return window;
}
function checkWindows3()
{
	var a=cspRunServerMethod(pdata1,"","HEAFindData","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '健康教育评估记录查询',
		id : "gformfind1",
		x:170,y:180,
		width : 420,
		height : 250,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr]
	});
	return window;
}
function addData(mygrid,e)
{
	if(mygrid=="mygrid1")
	{
		var window = checkWindows1();
		window.show();
		Ext.getCmp("EanaDate").setValue(new Date());
		Ext.getCmp("EanaTime").setValue(new Date());
		var NurSign = Ext.getCmp("EanaNurSign");
		EanaNurSign="";
		NurSign.on('specialkey',cmbkey1);
		//NurSign.setValue(session['LOGON.USERNAME']);
		var defineBtn = Ext.getCmp("defineBtn");
		defineBtn.on('click',function(){if(saveEanaData()){window.close();findData("mygrid1");}});
		var cancleBtn = Ext.getCmp("cancleBtn");
		cancleBtn.on('click',function(){window.close();});
	}
	if(mygrid=="mygrid2")
	{
		HEAProject = "";
		var window = checkWindows2();
		window.show();
		expandtreeNode();
//		var ProjDescribe = Ext.getCmp("ProjDescribe");
//		ProjDescribe.setReadOnly(true);
//		ProjDescribe.enableKeyEvents=true;
//		ProjDescribe.on('keydown',function(textField,e){if(e.getKey()==e.BACKSPACE){alert("aaaaaa");e.stopEvent();}});
		//ProjDescribe.setDisabled(true);
		Ext.getCmp("HEADate").setValue(new Date());
		Ext.getCmp("HEATime").setValue(new Date());
		var HEATeacher = Ext.getCmp("HEATeacher");
		HEATeacherRowId="";
		HEATeacher.on('specialkey',cmbkey2);
		var defineBtn = Ext.getCmp("defineBtn2");
		defineBtn.on('click',function(){if(saveHeaData()){window.close();findData("mygrid2");}});
		var cancleBtn = Ext.getCmp("cancleBtn2");
		cancleBtn.on('click',function(){window.close();});
	}
}
function setChioce(itemid,itemtext){
	var itemArray = itemtext.split(',');
	var itemObj = Ext.getCmp(itemid).items;
	for(j=0;j<itemArray.length;j++)
	{
		for(i=0;i<itemObj.length;i++)
		{
			if(itemObj.get(i).boxLabel==itemArray[j])
			{
				itemObj.get(i).checked = true;
			}
		}
	}
}
function setEANADefineData()
{
	var grid = Ext.getCmp("mygrid1");
	var selectedRow = grid.getSelectionModel().getSelected();
	var EANARowId = selectedRow.get("EANARowIDData");
	var getENANData = document.getElementById("getEANAData");
	var ret = cspRunServerMethod(getEANAData.value,EANARowId);
	if(ret!="")
	{
		var hh = ret.split("^");
  	Ext.getCmp("EanaDate").setValue(hh[0]);
  	Ext.getCmp("EanaTime").setValue(hh[1].substring(0,5));
  	setChioce("EanaObject",hh[2]);
  	setChioce("EanaLgtalk",hh[3]);
  	setChioce("EanaReadAbt",hh[4]);
  	setChioce("EanaWriteAbt",hh[5]);
  	setChioce("EanaUdstdAbt",hh[6]);
  	setChioce("EanaImplmtAbt",hh[7]);
  	setChioce("EanaAcptWay",hh[8]);
  	setChioce("EanaLkAcptCtt",hh[9]);
  	EanaNurSign = hh[10];
  	var ret2=cspRunServerMethod(GetPerson.value,hh[10]);
  	if(ret2!="")
  	{
  		var hh2 = ret2.split("^");
  		if(hh2[0]!="")
  		{
  			var hhh = hh2[0].split("|");
  			Ext.getCmp("EanaNurSign").setValue(hhh[1]);
  		}
  	}
  }
}
function setHEADefineData()
{
	var grid = Ext.getCmp("mygrid2");
	var selectedRow = grid.getSelectionModel().getSelected();
	var HEARowIDData = selectedRow.get("HEARowIDData");
	var getHEAData = document.getElementById("getHEAData");
	var ret = cspRunServerMethod(getHEAData.value,HEARowIDData);
	if(ret!="")
	{
		var hh=ret.split("^");
		Ext.getCmp("HEADate").setValue(hh[0]);
  	Ext.getCmp("HEATime").setValue(hh[1].substring(0,5));
  	setChioce("HEAIndvd",hh[2]);
  	HEAProject = hh[3];
  	setChioce("HEAObject",hh[4]);
  	setChioce("HEAOpportunity",hh[5]);
  	setChioce("HEAWay",hh[6]);
  	setChioce("HEAEffect",hh[7]);
  	HEATeacherRowId = hh[8];
  	var ret2=cspRunServerMethod(GetPerson.value,hh[8]);
  	if(ret2!="")
  	{
  		var hh2 = ret2.split("^");
  		if(hh2[0]!="")
  		{
  			var hhh = hh2[0].split("|");
  			Ext.getCmp("HEATeacher").setValue(hhh[1]);
  		}
  	}
  	Ext.getCmp("HEARemarks").setValue(hh[9]);
  }
}
function updateData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var rowObj = grid.getSelectionModel().getSelections();
	var selectedRow = grid.getSelectionModel().getSelected();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示 ', "请选择 一条记录 !");
		return;
	}
	if(mygrid=="mygrid1")
	{
		var window = checkWindows1();
		setEANADefineData();
		window.show();
		var NurSign = Ext.getCmp("EanaNurSign");
		//EanaNurSign="";
		NurSign.on('specialkey',cmbkey1);
		var EANARowId = selectedRow.get("EANARowIDData");
		var defineBtn = Ext.getCmp("defineBtn");
		var cancleBtn = Ext.getCmp("cancleBtn");
		defineBtn.on('click',function(){
			var tmp=getEanaData();
			if(tmp!=""){
				var temp = EANARowId+"^"+tmp;
				var updatevalue = document.getElementById("updateEANAData");
				var ret = cspRunServerMethod(updatevalue.value,temp);
				//if(ret!=""){alert(ret);}
				window.close();
				findData("mygrid1")
			}
		});
		cancleBtn.on('click',function(){window.close();});
	}
	else
	{
		var window = checkWindows2();
		setHEADefineData();
		window.show();
		SetNode(HEAProject);
		window.doLayout();
		expandtreeNode();
//		var ProjDescribe = Ext.getCmp("ProjDescribe");
//		ProjDescribe.setReadOnly(true);
//		ProjDescribe.enableKeyEvents=true;
//		ProjDescribe.on('keydown',function(textField,e){if(e.getKey()==e.BACKSPACE){alert("aaaa");e.stopEvent();}});
		//ProjDescribe.setDisabled(true);
		var HEARowIDData = selectedRow.get("HEARowIDData");
		var HEATeacher = Ext.getCmp("HEATeacher");
		//HEATeacherRowId="";
		HEATeacher.on('specialkey',cmbkey2);
		var defineBtn = Ext.getCmp("defineBtn2");
		var cancleBtn = Ext.getCmp("cancleBtn2");
		defineBtn.on('click',function(){
			var temp = HEARowIDData+"^"+getHeaData();
			var updatevalue = document.getElementById("updateHEAData");
			var ret = cspRunServerMethod(updatevalue.value,temp);
			//if(ret!=""){alert(ret);}
			window.close();
			findData("mygrid2")
		});
		cancleBtn.on('click',function(){window.close();});
	}
}

function deleteData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示 ', "请选择 一条记录 !"); return;
	}
	var selectedRow = grid.getSelectionModel().getSelected();
	if(confirm("确认作废这条记录？")==true){
  	if(mygrid=="mygrid1")
  	{
  		var deletevalue = document.getElementById("deleteEANAData");
  		var EANARowId = selectedRow.get("EANARowIDData");
  		var ret = cspRunServerMethod(deletevalue.value,EANARowId+"^N");
  		//if(ret!=""){alert(ret);}
  	}
  	if(mygrid=="mygrid2")
  	{
  		var deletevalue = document.getElementById("deleteHEAData");
  		var HEARowId = selectedRow.get("HEARowIDData");
  		var ret = cspRunServerMethod(deletevalue.value,HEARowId+"^N");
  		//if(ret!=""){alert(ret);}
  	}
	}
}
function multchoice(multtext,multtextdesc)
{
	var multvalue = Ext.getCmp(multtext).items;
	var multchkvalue = "";
	for(i=0;i<multvalue.length;i++)
	{
		if(multvalue.get(i).checked)
		{
			if(multchkvalue!="")
			{
				var multchkvalue = multchkvalue+","+multvalue.get(i).boxLabel;
			}
			else
			{
				var multchkvalue = multvalue.get(i).boxLabel;
			}
		}
	}
	if(multchkvalue=="")
	{
		Ext.Msg.alert('提示 ',multtextdesc+"不能为空");
		return "fail";
	}
	return multchkvalue;
}

function signalchoice(multtext,multtextdesc)
{
	var multvalue = Ext.getCmp(multtext).items;
	var multchkvalue = "";
	for(i=0;i<multvalue.length;i++)
	{

		if(multvalue.get(i).checked)
		{
			if(multchkvalue!="")
			{
				Ext.Msg.alert('提示 ',multtextdesc+"为单选项，不可多选");
				return "fail"
			}
			else
			{
				multchkvalue= multvalue.get(i).boxLabel;
			}
		}
	}
	if(multchkvalue=="")
	{
		Ext.Msg.alert('提示 ',multtextdesc+"不能为空");
		return "fail";
	}
	return multchkvalue;
}

function getEanaData()
{
	var EanaDate = document.getElementById("EanaDate");
	var EanaTime = document.getElementById("EanaTime");
	var temp="";
	var EanaObject = signalchoice("EanaObject","评估对象");
	if(EanaObject!="fail")
	{
		var EanaLgtalk = signalchoice("EanaLgtalk","交流语言");
		if(EanaLgtalk!="fail")
		{
			var EanaReadAbt = signalchoice("EanaReadAbt","阅读能力");
			if(EanaReadAbt!="fail")
			{
				var EanaWriteAbt = signalchoice("EanaWriteAbt","书写能力");
				if(EanaWriteAbt!="fail")
				{
					var EanaUdstdAbt = signalchoice("EanaUdstdAbt","理解能力");
					if(EanaUdstdAbt!="fail")
					{
						var EanaImplmtAbt = signalchoice("EanaImplmtAbt","实施能力");
						if(EanaImplmtAbt!="fail")
						{
							var EanaAcptWay = multchoice("EanaAcptWay","可接受方法");
							if(EanaAcptWay!="fail")
							{
								var EanaLkAcptCtt = multchoice("EanaLkAcptCtt","乐意接受内容");
								if(EanaLkAcptCtt!="fail")
								{
									if(EanaNurSign!=""&&EanaNurSign!=null)
									{
										//alert(EanaNurSign);
										var temp = EanaDate.value+"^"+EanaTime.value+"^"+EanaObject+"^"+EanaLgtalk+"^"+EanaReadAbt+"^"+EanaWriteAbt+"^"+EanaUdstdAbt+"^"+EanaImplmtAbt+"^"+EanaAcptWay+"^"+EanaLkAcptCtt+"^"+EanaNurSign;
									}
									else
									{
										Ext.Msg.alert('提示 ',"评估者不能为空");
									}
								}
							}
						}
					}
				}
			}
		}
	}	
	return temp;
}
function saveEanaData()
{
	var tmp = getEanaData();
	if(tmp!="")
	{
		var temp = EpisodeID+"^"+tmp;
		//alert(temp);
		var getvalue = document.getElementById("addEANAData");
		var ret = cspRunServerMethod(getvalue.value,temp);
		//if(ret!=""){alert(ret);}
		return true;
	}
	return false;
}
function findData(mygrid) {
	REC = new Array(); 
	var GetQueryData = document.getElementById("getQureyData");
	if(EpisodeID!="")
	{
	var parr=EpisodeID;
  	var grid = Ext.getCmp(mygrid);
  	if(mygrid=="mygrid1")
  	{
  		var a = cspRunServerMethod(GetQueryData.value,"web.DHCEduAbtNdAss:FindEduAbtNdAss", "parr$" + parr, "AddRec1");
  		
  	}
  	grid.store.loadData(REC);
  	if(mygrid=="mygrid2")
  	{
  		//alert(parr);
  		var a = cspRunServerMethod(GetQueryData.value,"web.DHCHlthEduAss:FindHlthEduAss", "parr$" + parr, "AddRec2");
  	}
  	grid.store.loadData(REC);
  }
  else{
  	Ext.Msg.alert('提示 ',"请先选择一个病人");
  }
}
var StDate="";
var EndDate="";
function findHEAData()
{
	var window = checkWindows3();
	window.show();
	var Teacher = Ext.getCmp("Teacher");
	HEATeacherRowId="";
	Teacher.on('specialkey',cmbkey2);
	var findBtn = document.getElementById("FandDataBtn");
	var FCancleBtn = document.getElementById("FCancleBtn");
	findBtn.onclick=function(){
		REC = new Array();
		var grid = Ext.getCmp("mygrid2");
		var GetQueryData = document.getElementById("getQureyData");
  	StDate = document.getElementById("StDate").value;
  	EndDate = document.getElementById("EndDate").value;
  	var IndividualNeeds = Ext.getCmp("IndividualNeeds").items;
  	var IndvdNdsvalue = "";
  	for(i=0;i<IndividualNeeds.length;i++)
  	{
  		if(IndividualNeeds.get(i).checked)
  		{
  			if(IndvdNdsvalue!="")
  			{
  				var IndvdNdsvalue = IndvdNdsvalue+","+IndividualNeeds.get(i).boxLabel;
  			}
  			else
  			{
  				var IndvdNdsvalue = IndividualNeeds.get(i).boxLabel;
  			}
  		}
  	}
  	//var Teacher = document.getElementById("Teacher");
  	var parr = EpisodeID+"^"+StDate+"^"+EndDate+"^"+IndvdNdsvalue+"^"+HEATeacherRowId;
  	//alert(parr);
  	window.close();
  	var a = cspRunServerMethod(GetQueryData.value,"web.DHCHlthEduAss:FindHEAByFactor", "parr$" + parr, "AddRec2");
  	//alert("parr$" + parr);
  	grid.store.loadData(REC);
  }
  FCancleBtn.onclick = function(){
  	window.close();
  	findData("mygrid2");
  }
}
function AddRec1(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
	// debugger;
	REC.push({
		EANADateData : a1,
		EANATimeData : a2,
		EANAObjectData : a3,
		EANALangTalkData : a4,
		EANAReadAbtData : a5,
		EANAWriteAbtData : a6,
		EANAUdstdAbtData : a7,
		EANAImplmtAbtData : a8,
		EANAAcptWayData : a9,
		EANALkAcptCttData : a10,
		EANANurSignData : a11,
		EANARowIDData : a12
	});
}
function AddRec2(a1, a2, a3, a4, a5, a6,a7,a8,a9,a10,a11) {
	// debugger;
	REC.push({
		HEADateData:a1,
		HEATimeData:a2,
		HEAIndvdNdData:a3,
		HEAProjectData:a4,
		HEAObjectData:a5,
		HEAOptntData:a6,
		HEAWayData:a7,
		HEAEffectData:a8,
		HEATeacherData:a9,
		HEARemarksData:a10,
		HEARowIDData:a11
	});
}
function getHeaData()
{
	//var HEAProject = node.id;
	var temp="";
	getTreeNode();
	if(HEAProject=="")
	{
		Ext.Msg.alert('提示 ',"请选择项目");
	}else{
		var HEAObject = multchoice("HEAObject","教育对象");
		if(HEAObject!="fail")
		{
			var HEAOpportunity = signalchoice("HEAOpportunity","教育时机");
			if(HEAOpportunity!="fail")
			{
				var HEAIndvd = multchoice("HEAIndvd","教育个性化需求");
				if(HEAIndvd!="fail")
				{
					var HEAWay = multchoice("HEAWay","教育方法");
					if(HEAWay!="fail")
					{
						var HEAEffect = signalchoice("HEAEffect","效果评估");
						if(HEAEffect!="fail")
						{
							if(HEATeacherRowId!="")
							{
								var HEADate = document.getElementById("HEADate");
								var HEATime = document.getElementById("HEATime");
								var HEARemarks = document.getElementById("HEARemarks");
								// Input:PatientId^教育日期^教育时间^健康教育个性化^项目^教育对象^教育时机^教育方法^效果评价^教育者^备注
								var temp = HEADate.value+"^"+HEATime.value+"^"+HEAIndvd+"^"+HEAProject+"^"+HEAObject+"^"+HEAOpportunity+"^"+HEAWay+"^"+HEAEffect+"^"+HEATeacherRowId+"^"+HEARemarks.value;
							}
							else
							{
								Ext.Msg.alert('提示 ',"教育者不能为空");
							}
						}
					}
				}
			}
		}
	}
	return temp; 
}
function saveHeaData()
{
	var tmp = getHeaData();
	if(tmp!="")
	{
		var temp = EpisodeID+"^"+tmp;
		var getvalue = document.getElementById("addHEAData");
		var ret = cspRunServerMethod(getvalue.value,temp);
		//if(ret!=""){alert(ret);}
		return true;
	}
	return false;
}
function getDocAdviceData()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var parr=EpisodeID;
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindDocAdvice", "parr$" + parr, "AddRec3");
	//var grid = Ext.getCmp("mygrid3");
	//grid.store.loadData(REC);
}

/*function AddRec3(a1, a2, a3) 
{
	// debugger;
	REC3.push({
		DocAdvcsign:"",
		DocAdvcInfo:a1,
		DocAdvcStDate:a2,
		DocAdvcStTime:a3
	});
}*/
function AddRec3(a1, a2, a3,a4) 
{
	//alert(a1);
	REC.push(a1,a2,a3,a4);
}
function AddRec4(a1,a2,a3)
{
	REC.push(a1,a2,a3);
}
function AddRec5(a1,a2)
{
	REC.push(a1,a2);
}
function printNurRec() {//grid是所要导出的grid表格
	var grid=Ext.getCmp("mygrid2");
	try {
		var xls = new ActiveXObject("Excel.Application");
	} catch (e) {
		alert("要打印该表，您必须安装Excel电子表格软件，同时浏览器须使用“ActiveX 控件”，您的浏览器须允许执行控件。 请点击【帮助】了解浏览器设置方法！");
		return "";
	}
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	//alert('总列数：'+colCount);
	xls.visible = true; // 设置excel为可见
	//xls.setPage(2);
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	//xlSheet.setPage(2);
	xlSheet.PageSetup.Orientation = 2;
	var temp_obj = [];
	// 只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)
	for (i = 0; i < colCount; i++) {
		if (cm.isHidden(i) == true) {
		} else {
			temp_obj.push(i);
		}
	}
	xlSheet.PageSetup.LeftMargin= 4/0.035;         //页边距 左2厘米   
  xlSheet.PageSetup.RightMargin = 0.5/0.035;      //页边距 右2厘米，   
  xlSheet.PageSetup.TopMargin = 3/0.035;        //页边距 上2厘米，   
  xlSheet.PageSetup.BottomMargin = 2/0.035;   //页边距 下2厘米   
  xlSheet.PageSetup.HeaderMargin = 2/0.035;   //页边距 页眉2厘米   
  xlSheet.PageSetup.FooterMargin = 1/0.035;    //页边距 页脚2厘米 
  xlSheet.PageSetup.CenterHeader = "&16安徽省立医院健康教育评估记录单";
////	xlSheet.Range("A1:J1").MergeCells=true;
////	xlSheet.Cells(1,1).HorizontalAlignment  = 3;//居中
////	xlSheet.Cells(1,1).Font.Size=16;
////	xlSheet.Cells(1,1).Value = "安徽省立医院健康教育评估记录单";
	var ret = getPatientInfo();
	var hh = ret.split("^");
	xlSheet.Rows(1).Font.Size=10;
	xlSheet.Range("A1:J1").MergeCells = true;
	xlSheet.Cells(1,1)="病人姓名:"+hh[0]+" 住院号:"+hh[1]+"  性别:"+hh[2]+"  年龄:"+hh[3]+"  开始时间:"+StDate+"        结束时间:"+EndDate;
	for (l = 1; l < temp_obj.length; l++) {
		//xlSheet.Cells(4,l).HorizontalAlignment  = 3;
		xlSheet.Cells(2,l).Font.Size=10;
		xlSheet.Cells(2,l).Value = cm.getColumnHeader(temp_obj[l-1]);
	}
	//xlSheet.Columns("4:4").ColumnWidth = 100;
	var store = grid.getStore();
	var recordCount = store.getCount();
	if(recordCount==0)
	{
		Ext.Msg.alert("提示","没有数据");
		return;
	}
	//alert("记录总数："+recordCount);
	//alert('总列数：'+temp_obj.length);
	var view = grid.getView();
	for (k = 1; k <= recordCount; k++) {
		//alert('k-'+k);
		xlSheet.Rows(k + 2).Font.Size=9;
		//xlSheet.Rows(k + 2).HorizontalAlignment  = 3;
		xlSheet.Rows(k + 2).WrapText = true;
		for (j = 1; j < temp_obj.length; j++) {
			// EXCEL数据从第二行开始,故row = k + 1;
			//alert(view.getCell(k - 1, temp_obj[j- 1]).innerText);
			//xlSheet.Cells(k + 2,j).Font.Size=10;
			//xlSheet.Cells(k + 2,j).HorizontalAlignment  = 3;
			//xlSheet.Cells(k + 2,j).WrapText = true;
			xlSheet.Cells(k + 2,j).Value = view.getCell(k - 1, temp_obj[j- 1]).innerText;
		}
	}
	gridlist(xlSheet,2,2+recordCount,1,10)
	xlSheet.Columns(3).ColumnWidth=12;
	xlSheet.Columns(4).ColumnWidth=30;
	xlSheet.Columns.AutoFit;
	xlSheet.Rows.AutoFit; 
	//xlSheet.Columns(3+":"+4).ColumnWidth = 12;
	xlSheet.PrintOut(1,1,1,false,"",false,false);
	xls.ActiveWindow.Zoom = 75;
	xls.UserControl = true; // 很重要,不能省略,不然会出问题 意思是excel交由用户控制
	xls = null;
	xlBook = null;
	xlSheet = null;
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function getPatientInfo()
{
	var getPatient= document.getElementById("GetPatientInfo");
	var ret = cspRunServerMethod(getPatient.value,EpisodeID);
	if(ret!="")
	{
		return ret;
	}
	else
	{
		return "";
	}
}

function getTreeNode()
{
	HEAProject="";
	var tree = Ext.getCmp("projecttree");
	var checkedNodes = tree.getChecked();
	var root = tree.getRootNode(); 
	for(i=0;i<checkedNodes.length;i++)
	{
		var node = checkedNodes[i];
		if(node.id.substring(0,7)=="ItemTwo"&&!node.isExpandable()){
			var pnode = node.parentNode;
			if(HEAProject=="")
			{ 
				HEAProject = pnode.id.substring(7,(pnode.id).length)+"||"+node.id.substring(7,(node.id).length); 
			} else { 
				HEAProject = HEAProject+","+pnode.id.substring(7,(pnode.id).length)+"||"+node.id.substring(7,(node.id).length); 
			}
		}
		if(node.id.substring(0,9)=="ItemThree"&&!node.isExpandable())
		{
			var pnode = node.parentNode;
			var ppnode = pnode.parentNode;
			if(HEAProject=="")
			{ 
				HEAProject = ppnode.id.substring(7,(ppnode.id).length)+"||"+pnode.id.substring(7,(pnode.id).length)+"||"+node.id.substring(9,(node.id).length); 
			} else { 
				HEAProject = HEAProject+","+ppnode.id.substring(7,(ppnode.id).length)+"||"+pnode.id.substring(7,(pnode.id).length)+"||"+node.id.substring(9,(node.id).length); 
			}
		}
	}
	//alert(HEAProject);
}
function expandtreeNode()
{
	var tree = Ext.getCmp("projecttree");
	var UserType=session['LOGON.GROUPDESC']
	if(UserType=="住院护士"||UserType=="住院护士长")
	{
		var wardID = session['LOGON.CTLOCID'];
		var node = tree.getNodeById("Ward"+wardID);
		//alert("Ward"+wardID);
		node.expand();
	}
}

function deleteArray(array,id)
{
	var arr = new Array();
	var j=0;
	for(i=0;i<array.length;i++)
	{
		if(array[i][0]!=id)
		{
			arr[j]=array[i];
			j++;
		}
	}
	return arr;
}

function CheckWard(array,str){
	for(i=0;i<array.length;i=i+3)
	{
		if(array[i].toString()==str)
		{
			return array[i+2];
		}
	}
	return;
}

function SetNode(nodeStrs)
{
	DescArray = new Array();
	var tree = Ext.getCmp("projecttree");
	var getData = document.getElementById('FindWardByPO');
	var nodeArrs = nodeStrs.split(",");
	for(i=0;i<nodeArrs.length;i++)
	{
		var nodeArr = nodeArrs[i];
		var nodeStr = nodeArr.split("||");
		var a = cspRunServerMethod(getData.value,nodeStr[0]);
		var ret = a.split('^');
		var waidId = ret[1];
		SetCheckedNode("Ward"+waidId);
		SetCheckedNode("ItemOne"+nodeStr[0]);
		SetCheckedNode("ItemTwo"+nodeStr[1]);
		if(nodeStr.length==3) SetCheckedNode("ItemThree"+nodeStr[2]);
	}
	var ProjDescribe = Ext.getCmp("ProjDescribe");
	for(j=0;j<DescArray.length;j++)
	{
		ProjDescribe.setValue(ProjDescribe.getValue()+DescArray[j][1]+": \n"+DescArray[j][2]+"\n\n");
	}
}
function SetCheckedNode(nodeId){
	var tree = Ext.getCmp("projecttree");
	var node = tree.getNodeById(nodeId);
	if(!node.expanded&&node!=null)
	{
		node.getUI().checkbox.checked = true;
		node.attributes.checked = true;
		node.expand();
		if(node.id.substring(0,7)=="ItemTwo"&&!node.isExpandable())
		{
			var getvalue=document.getElementById("getHEAPData");
			var Item1RowId = (node.id).substring(7,(node.id).length)
			var ret = cspRunServerMethod(getvalue.value,Item1RowId);
			DescArray.push(new Array(node.id,node.text,ret));
		}
		if(node.id.substring(0,9)=="ItemThree"&&!node.isExpandable())
		{
			var getvalue=document.getElementById("getHEAPIIData");
			var Item3RowId = (node.id).substring(9,(node.id).length)
			var ret = cspRunServerMethod(getvalue.value,Item3RowId);
			var a = ret.split("^");
			DescArray.push(new Array(node.id,node.text,a[2]));
		}
	}
}

function printNurRecTest()
{
	//var ret = getPatientInfo();
	var GetHead=document.getElementById('GetPatInfo');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	//var hh = ret.split("^");
	PrintCommPic.TitleStr=ret;
	PrintCommPic.SetPreView("1");
	PrintCommPic.stPage=0;
	PrintCommPic.stRow=0;
	PrintCommPic.previewPrint="1"; //是否弹出设置界面
	//PrintComm.stprintpos=tm[0];
	PrintCommPic.stprintpos=0;
	PrintCommPic.SetConnectStr(CacheDB);
//	alert(CacheDB);
//	alert(webIP);
 //if (LabHead != "") PrintCommPic.LabHead = LabHead;
  PrintCommPic.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
 	PrintCommPic.ItmName = "ptDHCNURHEADATA"; //338155!2010-07-13!0:00!!
	var parr=EpisodeID+"!pDHCNURHEADATA";
	//var parr = EpisodeID + "!" + "" + "!" + "" + "!" + "" + "!" + "" + "!pDHCNURHEADATA!";
	//alert(parr);
	PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:" 
	PrintCommPic.PrintOut();
}