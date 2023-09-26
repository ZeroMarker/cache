var treeHasChanged=false;
Ext.onReady(function(){
    Ext.QuickTips.init();
    
	//如果需要检索科室,就是用下面的内容,把Panel渲染到tree上
	var Find=new Ext.Button({
		handler : Find_click,
		text : '检索科室',
		region : 'north',
		id : 'TreeFind'
	});
	var store = new Ext.data.ArrayStore({
    	fields: ['myId', 'displayText'],
    	//data : [[2, '西院'], [3, '东院']]
		data : eval(tkMakeServerCall("web.DHCOPAdmRegTree","GetHospitalData",session['LOGON.HOSPID']))
	});
    var btnExpand=new Ext.Button({
	      text:'全部展开',
		  handler:function(obj){
		  var tree=Ext.getCmp("Tree");
		  var node=tree.getRootNode();
		  var length=node.childNodes.length;
		  if(this.text=='全部展开'){
		  if(length>0){
			   for(var i=0;i<length;i++){
				 var major=node.childNodes[i];
				 //major.collapse(false,false);
				 major.expand(true,false,function(a,b){});
			   }
		  }
		   this.setText("全部折叠");
		 }else{
		  this.setText("全部展开");
		  if(length>0){
			
			  node.collapse(true,false);
		  }
		 }
		 
		}
	
	});
	var btnHide=new Ext.Button({
	      text:'隐藏',
		  x:0,
		  y:0,
		  renderTo:'tree',
		  handler:function(obj){
		   if(this.text=='显示'){		 
				this.setText("隐藏");
				 Ext.getCmp("panel").show();
		   }else{
		        Ext.getCmp("panel").hide();
				//$("tree").style.display="none";				
				this.setText("显示");	
				/*
				$("tree").style.display='none';
				this.btnEl.setStyle("z-index",10);
				this.btnEl.setStyle("display",'');
				this.btnEl.setStyle("left",0);
				this.btnEl.setStyle("top",0);
				*/
		   }		 
		}
	
	});
	var treeDIV=document.getElementById("tree");
	
	Ext.get(treeDIV.parentNode).on('click',function(){	  
	    //treeDIV.style.display=="none")?treeDIV.style.display="":'';
	});
	var combo = new Ext.form.ComboBox({
        store: store,
        displayField:'state',
        typeAhead: true,
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText:'Select a state...',
        selectOnFocus:true,
        region : 'north',
        width : 120,
        fieldLabel : '院区',
        valueField: 'myId',
    	displayField: 'displayText'  
    });
    var curHospital=session['LOGON.HOSPID'];
	combo.setValue(curHospital);
	combo.on('select',combo_select)
	var root = new Ext.tree.AsyncTreeNode({  
		id : "0^0",
		text : "科室列表"
	});
	var loader = new Ext.tree.TreeLoader({ 
		url : 'dhcopadm.reg.tree.csp'
	});
	loader.on("load", function(tree, node,response) {
		  
		  var length=node.childNodes.length;
		  if(length>0){
		   for(var i=0;i<length;i++){
		     var major=node.childNodes[i];
			// insert( Tree tree, Node this, Node node, Node refNode ) //major.collapse(false,false);
			 major.allowDrop=false;
			 major.on("insert",function(tree,node,newnode,refNode){			           
			             newnode.remove();
			 });
		   }
		 }
		
		
	});
	loader.on("beforeload", function(loader, node) {
		loader.baseParams.nodeId = node.id;
		var curHospital=combo.getValue();
		loader.baseParams.hospitalId = curHospital;
		var type=node.id.split("^")[1];
		loader.baseParams.AdmDate=DHCC_GetElementData("AppDate");
		/*
		if((type)&&(type==2)){
			var appFlagReg=/AppFlag=(.)/;
			appFlagReg.exec(window.location.href)
			var appFlag=RegExp.$1;
			var PatientID=$("PatientID");
			if(PatientID){
				loader.baseParams.PatientID=PatientID.value;
			}
			loader.baseParams.AppFlag=appFlag;
		}
		*/
	});
	
	var tree = new Ext.tree.TreePanel({
		//renderTo : "tree",
		region : 'center',
		root : root,
		autoScroll: true,
		//拖动更改顺序
		enableDD: true,
		loader : loader,
		frame : true,
		width : 160,
		height : 620,
		rootVisible : false,
		id : 'Tree'
	});
	tree.getRootNode().expand();
	tree.on("click",tree_click);
	//不允许拖拽成为子节点
	tree.on("beforenodedrop",function(dropEvent ){
	     var point=dropEvent.point;
		 treeHasChanged=true;
		 if(point=="append"){
		 return false;
		 }
	});
 
	var Panel=new Ext.Panel({
		renderTo : "tree",
		//collapsible:true,
		id:'panel',
		items : [btnExpand,combo,tree],
		width : 160,
		height : 615,
		frame : true
	});
	
	
})
function combo_select()
{
	var tree=Ext.getCmp('Tree')
	tree.root.reload();
}
function Find_click()
{
	var tree=Ext.getCmp('Tree')
	tree.root.reload();
}
function tree_click(node)
{
	var Str=node.id;
	var StrArr=Str.split("^");
	var ID=StrArr[0];
	var Type=StrArr[1];
	try{
		if (Type=="2"){
		   
			//if ((typeof(combo_DeptList)!="undefined")&&(combo_DeptList!=null)) combo_DeptList.setComboValue(ID);
			var obj=document.getElementById("DepRowId");
			if (obj){
				obj.value=ID;
				DHCC_SetElementData('DeptList',node.text);
			}
			DHCC_SetElementData('DocRowId','');
	        DHCC_SetElementData("MarkCode","")
			if ((typeof(combo_ClinicGroup)!="undefined")&&(combo_ClinicGroup!=null)) {
				combo_ClinicGroup.setComboValue(""); //清空亚专业
				combo_ClinicGroup.setComboText("");
			}
			if ((typeof(combo_RoomList)!="undefined")&&(combo_RoomList!=null)) {
				combo_RoomList.setComboValue(""); //清空诊室
				combo_RoomList.setComboText("");
			}
			/*if ((typeof(combo_MarkCode)!="undefined")&&(combo_MarkCode!=null)) {
				combo_MarkCode.setComboValue(""); //清空医生
				combo_MarkCode.setComboText("");
			}*/
			DeptListDblClickHandler();
		
		}
		if (Type=="3"){
		
			//if ((typeof(combo_ClinicGroup)!="undefined")&&(combo_ClinicGroup!=null)) combo_ClinicGroup.setComboValue(ID);
			//if ((typeof(combo_DeptList)!="undefined")&&(combo_DeptList!=null)) combo_DeptList.setComboValue("");
			DHCC_SetElementData('DeptList',node.parentNode.text);
			DHCC_SetElementData('DepRowId',ID);
			if ((typeof(combo_RoomList)!="undefined")&&(combo_RoomList!=null)) {
				combo_RoomList.setComboValue("");
				combo_RoomList.setComboText("");
			}
			/*if ((typeof(combo_MarkCode)!="undefined")&&(combo_MarkCode!=null)) {
				combo_MarkCode.setComboValue("");
				combo_MarkCode.setComboText("");
			}*/
			DHCC_SetElementData('DocRowId',StrArr[2]);
	        DHCC_SetElementData("MarkCode",node.text);
			DeptListDblClickHandler(node.text+"^"+StrArr[2]);
		}
	}catch(e){	}
}

window.onbeforeunload = function(e){
 var tree=Ext.getCmp("Tree");
 var root=tree.getRootNode();
 var count=root.childNodes.length;
 var sequence="";
 if(treeHasChanged){
 
	 for(var i=0;i<count;i++){
	   //sequence.push(root.childNodes[i].id);
	   var arr=root.childNodes[i].id.split("^");
	   arr[1]=i;
	   sequence=sequence+arr.join("^")+",,,";
	 }
	  tkMakeServerCall("web.DHCOPAdmRegTree","SaveTreeSequence",sequence);
  }
}