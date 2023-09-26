(function(){
	Ext.ns("dhcwl.mkpi.InsModeData");
})();

dhcwl.mkpi.InsModeData=function(){

	var outThis=this;
   	var modeData = new Array(); 
	var rptData=new Array();
	var dimData=new Array();
	var hasReaded=0;
	var modeType="模块";
	var rptType="|----报表";	
	var dimType="|--------指标";
	
	var serviceUrl="dhcwl/kpi/kpimodecfgdata.csp"

	/*
        var tabs = new Ext.TabPanel({
            region: 'west',
            margins:'3 3 3 0', 
            activeTab: 0,
            defaults:{autoScroll:true},

            items:[{
                title: 'Bogus Tab'
            },{
                title: 'Another Tab'
            },{
                title: 'Closable Tab',
                closable:true
            }]
        });
*/
        // Panel for the west
	/*
        var nav = new Ext.Panel({
            title: 'Navigation',
            region: 'center',
 
            width: 300,
             items:formPanel2
        });

        
	var formPanel2 = new Ext.FormPanel({
        region: 'center',
        id:'formPanel2',
        labelWidth: 75, // label settings here cascade unless overridden
        frame:false,
         bodyStyle:'padding:5px 5px 0',
         height:100,
        defaultType: 'textfield',

        items: [{
                id:'formModecfgDesc2',
                fieldLabel: '模块名称',
                name: 'modecfgDesc2',
                allowBlank:false
            },{
                id:'formModecfgCode2',
                fieldLabel: '模块编码',
                name: 'modecfgCode2'
            }
        ]

    });	   
    
    
        var win = new Ext.Window({
            title: 'Layout Window',
            closable:true,
            width:600,
            height:350,
              plain:true,
            layout: 'border',
            items: [formPanel2]
        });

        
	
		this.show=function(){
		win.show(this);
	}
*/

	/*
var data=[ [1, 'EasyJWeb', 'EasyJF','www.easyjf.com'],
[2, 'jfox', 'huihoo','www.huihoo.org'],[3, 'jdon', 'jdon','www.jdon.com'],
[4, 'springside', 'springside','www.springside.org.cn'] ];

var store=new Ext.data.SimpleStore({data:data,fields:["id","name","organization","homepage"]});
*/
	
	var xg = Ext.grid;	
	var sm = new xg.CheckboxSelectionModel();
	var data=new Array();
	var store=new Ext.data.SimpleStore({data:data,fields:["type","code","desc","PCode"]});


	var store = new Ext.data.Store({
        proxy: new Ext.data.MemoryProxy(data),
        reader: new Ext.data.ArrayReader({},
        	[	{name: 'type'},
            	{name: 'code'},
            	{name: 'desc'},
            	{name: 'PCode'}
       		])
    });
	var grid = new Ext.grid.GridPanel({
	//renderTo:"hello",
	title:"红色背景的数据与已有的数据有冲突",
	height:300,
	autowidth:true,
	sm: sm,
	columns:[
		sm,
		{header:"类型",dataIndex:"type"},
		{header:"编码",dataIndex:"code"},
		{header:"描述",dataIndex:"desc"}],
		store:store,
		autoExpandColumn:2
	});
	
        var tabs = new Ext.TabPanel({
            region: 'center',
            margins:'3 3 3 0', 
            activeTab: 0,
            defaults:{autoScroll:true},

            items:[{
                title: 'Bogus Tab'
            },{
                title: 'Another Tab'
            },{
                title: 'Closable Tab',
                closable:true
            }]
        });

        // Panel for the west
        var nav = new Ext.Panel({
            title: 'Navigation',
            region: 'west',
            split: true,
            width: 200,
            collapsible: true,
            margins:'3 0 3 3',
            cmargins:'3 3 3 3'
            //items:inputForm
        });

 
	var inputForm = new Ext.form.FormPanel({
        
        frame:true,
        border:false,
        height:380,
        fileUpload:true,
        region: 'center',
        /*
		    region: 'west',
            split: true,
            width: 200,
            collapsible: true,
            margins:'3 0 3 3',
            cmargins:'3 3 3 3',
            */
		items:[{
			xtype:'textfield',
			allowBlank:false,
			name:'importModeFil',
			fieldLabel:'模块文件',
			inputType:'file',
			id:'selectImportModeFile'
		},{items:grid}], 
		tbar: new Ext.Toolbar([{
        	text: '读入模块文件',
            handler: onBeforeImport
        },'-',{
			text: '导入模块',
    		handler: onImport
		}
		])
    });	
    
	function onBeforeImport(btn, ev){
    	
		/*
    	var path=Ext.get('selectImportModeFile').getValue();
    	if(!path||path==""){
    		alert("请选择要导入的XML文件！");
    		return;
    	}
 
    	var xmlDoc=dhcwl.mkpi.util.XML.loadXML(path);

 		var x = xmlDoc.documentElement;  //.childNodes;
 		alert(x.length);
	 	if(x&&x['length']){
			for (var i = 0; i < x.length; i++) {
				//xmlStr+=traverPri(x[i]);
				//traverPri(x[i]);

				if(x[i].nodeType==1){
					var nodeValue=null,attValues="";
					if (x[i].attributes){
						var atts=x[i].attributes,att=null;
						for(var j=0;j<atts.length;j++){
							att=atts[j];
							alert("attrib name:"+att.name+"  attrib value:"+att.nodeValue);
							if (att.name=="ClassFullName" && att.nodeValue=="DHCWL.MKPI.ModeMagModeCfg") {
							
							}

						}
					}
				}
			}
	
		}		
 		*/
 		
		var path=Ext.get('selectImportModeFile').getValue();
		if(!path||path==""){
			alert("请选择要导入的XML文件！");
		            		return;
		            	}
		 
		            	var xmlDoc=dhcwl.mkpi.util.XML.loadXML(path);
		            	var i=0;
		            	var modeCfgAry=new Array();
		            	var rptCfgAry=new Array();
		            	var dimCfgAry=new Array();
		            	var modeArySize=0,rptArySize=0;dimArySize=0;
		            	var childNodes=xmlDoc.documentElement.childNodes;
		            	for (i=0;i<=childNodes.length-1;i++) {
		            		
		            		//alert("nodetype="+childNodes[i].nodeType+";nodeName="+childNodes[i].nodeName);
			var ele=childNodes[i];
			var atts=ele.attributes,att=null;
			for(var j=0;j<atts.length;j++){
				att=atts[j];
				if (att.name=="ClassFullName") {
					if (att.nodeValue=="DHCWL.MKPI.ModeMagModeCfg") {
						
						modeCfgAry.push(ele);
						
						//modeArySize=modeArySize+1;
						//alert("childNodes["+j+"].nodeName into modeCfgAry");
						break;
					}
					if (att.nodeValue=="DHCWL.MKPI.ModeMagRptCfg") {
						rptCfgAry.push(ele);
						//rptArySize=rptArySize+1;
						//alert("childNodes["+j+"].nodeName into rptCfgAry");
						break;
					}								
					if (att.nodeValue=="DHCWL.MKPI.ModeMagKpiCfg") {
						dimCfgAry.push(ele);
						//dimArySize=dimArySize+1;
						//alert("childNodes["+j+"].nodeName into dimCfgAry");
						break;
					}	
				}
			}
		
		}
            	
      	
 				
            	
 				//var nodes=xmlDoc.getElementsByTagName("DHCWL.MKPI.ModeMagModeCfg-whsycrz");
 				
 				/*
    			var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(path,256);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				//alert(readStr);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");
    			//file.Close();
    			dhcwl.mkpi.util.XML.close();
		*/
		
		
		

    	modeData.length=0; 
    	rptData.length=0; 
    	dimData.length=0; 

 
    	var nodes=modeCfgAry;
    	var i=0;
    	var modeCodes='';
    	var rptCodes="";
    	var dimCodes="";

    	//alert("nodes[0].childNodes[1].text"+nodes[0].childNodes[1].text);
    	//alert("nodes.length="+nodes.length);
    	//var modeType="模块";
    	for (i=0;i<=nodes.length-1;i++) {
    		var code,desc,PCode;
    		code=desc=PCode="";
    		var node=nodes[i];
    		//alert(node.childNodes.length);
	   		for (var j=0;j<=node.childNodes.length-1;j++){
	   			
    			if(node.childNodes[j].nodeName=="ModeCfgCode") {
    				code=node.childNodes[j].text;
    			}	    		
    			if(node.childNodes[j].nodeName=="ModeCfgDesc") {
    				desc=node.childNodes[j].text;
    			}	    			    		
    			if(node.childNodes[j].nodeName=="ModeCfgPCode") {
    				PCode=node.childNodes[j].text;
    			}	    			    		
	   		}
    		//alert(code+":"+desc+":"+PCode);
    		
    		modeData.push([modeType,code,desc,PCode]);
    		if(modeCodes.length>0)
    			modeCodes += ',';
    		modeCodes += "'"+code+"'";
       	}

	       	//return;
    	//var rptType="|----报表";
    	var nodes=rptCfgAry;
    	var i=0;
    	for (i=0;i<=nodes.length-1;i++) {
    		var code,desc,PCode;
    		code=desc=PCode="";    		
    		
    		var node=nodes[i];
	   		for (var j=0;j<=node.childNodes.length-1;j++){
	   			
    			if(node.childNodes[j].nodeName=="RptCfgCode") {
    				code=node.childNodes[j].text;
    			}	    		
    			if(node.childNodes[j].nodeName=="RptCfgDesc") {
    				desc=node.childNodes[j].text;
    			}	    			    		
    			if(node.childNodes[j].nodeName=="RptCfgPCode") {
    				PCode=node.childNodes[j].text;
    			}	    			    		
	   		}   		
			//alert(code+":"+desc+":"+PCode);
    		rptData.push([rptType,code,desc,PCode]);
    		
    		if(rptCodes=="")
    			rptCodes="'"+code+"'";
    		else
    			rptCodes=rptCodes+",'"+code+"'";
    	}         
    	
    	//var dimType="|--------指标";
   		var nodes=dimCfgAry;
    	var i=0;
    	//var jdata= new Array();
    	for (i=0;i<=nodes.length-1;i++) {
    		var code,dimRule,filterRule,desc,PCode,orderNum;
    		code=dimRule=filterRule=desc=PCode=""
    		orderNum=0;
    		var node=nodes[i];
    		for (var j=0;j<=node.childNodes.length-1;j++){
    			if(node.childNodes[j].nodeName=="KpiCfgCode") {
    				code=node.childNodes[j].text;
    			}
	   			if(node.childNodes[j].nodeName=="KpiCfgDimCfgRule") {
	    				dimRule=node.childNodes[j].text;
	    			}
	   			if(node.childNodes[j].nodeName=="KpiCfgPCode") {
	    				PCode=node.childNodes[j].text;
	    			}
	   			if(node.childNodes[j].nodeName=="KpiCfgKpiFilterRule") {
	    				filterRule=node.childNodes[j].text;
	    			}
	   			if(node.childNodes[j].nodeName=="KpiCfgOrderNum") {
	    				orderNum=node.childNodes[j].text;
	    			}
	   		}
    		/*
    		var code=node.childNodes[0].text;
    		var dimRule=node.childNodes[2].text;
    		var filterRule=node.childNodes[3].text;
    		var desc="";
    		var PCode=node.childNodes[4].text;
    		var orderNum=node.childNodes[5].text;
    		*/
    		//jdata.push({type:"dim",code:code,desc:desc,pcode:PCode});
    		//alert(code+":"+desc+":"+PCode);
    		dimData.push([dimType,code,desc,PCode,dimRule,filterRule,orderNum]);
    		
   			if(dimCodes=="")
    			dimCodes="'"+code+"'";
    		else
    			dimCodes=dimCodes+",'"+code+"'";            		
    	} 
    	
    	//return;
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
			'action' : 'checkImportData',					
		    'modeCodes': modeCodes,
		    'rptCodes':rptCodes,
		    'dimCodes':dimCodes
		    }, function(jsonData) {
				//if(jsonData.success==true && jsonData.tip=="ok"){
				//jsonData = Ext.util.JSON.decode(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
						
				   	data.length=0;
					var i,j,k;
					for(i=0;i<=modeData.length-1;i++){
						var modeTmp= new Array();
						modeTmp=modeData[i];
						data.push(modeTmp);
						for(j=0;j<=rptData.length-1;j++){
							var rptTmp= new Array();
							rptTmp= rptData[j];
							if(rptTmp[3]==modeTmp[1]){
								data.push(rptTmp);
								
								for(k=0;k<=dimData.length-1;k++){
									var dimTmp= new Array();
									dimTmp= dimData[k];
									if(dimTmp[3]==rptTmp[1]){
										data.push(dimTmp);
									}
								}
								
							}
						}
						
					}
					store.loadData(data);
					grid.show();					
					 
					
					var retModeCodes=jsonData.data.modeCodes;
					var retRptCodes=jsonData.data.rptCodes;
					var retDimCodes=jsonData.data.dimCodes;
					if(retModeCodes=="" && retRptCodes=="" && retDimCodes==""){
					}else{
						if(retModeCodes!="") retModeCodes=retModeCodes.split(",");
						if(retRptCodes!="") retRptCodes=retRptCodes.split(",");
						if(retDimCodes!="") retDimCodes=retDimCodes.split(",");
				        for(var i=0;i<=store.getCount()-1;i++ ){
							var rd=store.getAt(i);
							var code=rd.get("code");
							var type=rd.get("type");
							if(type==modeType){
								for(var retModeI=0;retModeI<=retModeCodes.length-1;retModeI++){
									if(retModeCodes[retModeI]==code){
										grid.getView().getRow(i).style.backgroundColor='red';
									}
								}
							}
							if(type==rptType){
								for(var retRptI=0;retRptI<=retRptCodes.length-1;retRptI++){
									if(retRptCodes[retRptI]==code){
										grid.getView().getRow(i).style.backgroundColor='red';
									}
								}
							}	
							if(type==dimType){
								for(var retDimI=0;retDimI<=retDimCodes.length-1;retDimI++){
									if(retDimCodes[retDimI]==code){
										grid.getView().getRow(i).style.backgroundColor='red';
									}
								}
							}														
							
				        }
					}
				hasReaded=1;//读入文件成功。2013-11-28
				}else{ hasReaded=0;
						Ext.Msg.show({
									title : '检查失败',
									msg : "检查失败",
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}}, outThis);		        
			}
            
    	
	function onImport(btn, ev){ 
		if(hasReaded==0){
			Ext.MessageBox.alert("提示","请先读入模块文件！");
			return;
		}
		var impModeData = new Array(); 
		var impRptData=new Array();
		var impDimData=new Array();
		var rptData2=encodeURI(Ext.util.JSON.encode(modeData));
		//rptData2=modeData;
		for(var i=0;i<=store.getCount()-1;i++ ){
			if(sm.isSelected(i)){
				var type=store.getAt(i).get('type');
				var code=store.getAt(i).get('code');
				if(type==modeType){
					for(j=0;j<=modeData.length-1;j++){
						if(modeData[j][1]==code){
							impModeData.push(modeData[j]);
							break;
						}
					}
				}else if(type==rptType){
					for(j=0;j<=rptData.length-1;j++){
						if(rptData[j][1]==code){
							impRptData.push(rptData[j]);
							break;
						}			
					}
				}else if(type==dimType){
					for(j=0;j<=dimData.length-1;j++){					
						if(dimData[j][1]==code){
							impDimData.push(dimData[j]);
							break;
						}
					}
				}
				//realInputKpiList.push(store.getAt(i).get('kpiCode'));
			}
		}
		
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
			'action' : 'ImportData',		
			/*
		    'modeData': Ext.util.JSON.encode(modeData),
		    'rptData':Ext.util.JSON.encode(rptData),
		    'dimData':Ext.util.JSON.encode(dimData)
		    */
			'modeData': Ext.util.JSON.encode(impModeData),
		    'rptData':Ext.util.JSON.encode(impRptData),
		    'dimData':Ext.util.JSON.encode(impDimData)
		    }, function(jsonData) {
		    	if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.show({
						title : '安装成功',
						msg : "安装成功",
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.OK
					});
					
					//在页面上更新树节点
					var tree=Ext.ComponentMgr.get('cfgTreePanel');
					var rootNode=tree.getNodeById("root");
					for(var i=0;i<=impModeData.length-1;i++) {
						var isExist=0;
						var pID=impModeData[i][3];
						var cID=impModeData[i][1];
						var pNode=tree.getNodeById(pID);
						//待修改
						//freshNode(rootNode,impModeData[i][1]);

						if(rootNode.hasChildNodes()){				
							if (pNode!=null) {
								var cNodes=pNode.childNodes;
								//alert("cNodes.length="+cNodes.length);
								for(var j=0;j<=cNodes.length-1;j++){
									//alert("child id="+cNodes[j].id);
									if(cNodes[j].id==cID){
										//1如果父节点存在，直接添加子节点
										isExist=1;
										break;
									}
								}
							}else{
								pNode=rootNode;	
							}
					 	}else {
					 		pNode=rootNode;
					 	}
					 	
					 	if(isExist==0){
							var childNode = new Ext.tree.AsyncTreeNode( {
							text : impModeData[i][2],
							draggable : false,
							checked :false,
							leaf:true,
							id:cID
							  });
							//2013-11-7
							pNode.leaf=false;
							pNode.appendChild(childNode);
						}
					
					}
					
		    	}else{
					Ext.Msg.show({
						title : '安装失败',
						msg : "安装失败",
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		    	}
		    
		    }, outThis);		    		
		
	}
        var win = new Ext.Window({
            title: '安装窗口',
            closable:true,
            width:600,
            height:420,
            //border:false,
            plain:true,
            layout: 'border',

            items: [inputForm]
        });

        //遍历树
         function freshNode(cNo,pid){//遍历节点根据panelID查找相应的节点设置draggalbe为true
            var childnodes = cNo.childNodes;//获取根节点的子节点
            for(var i=0; i < childnodes.length; i++){
               var cNode = childnodes[i];
               if(cNode.id == pid)
               {
                 cNode.draggable = true;
               }
               if(cNode.hasChildNodes()){
                 setNodeDrag(cNode,pid);//递归调用
               }
            }
        }
	
        sm.on('beforerowselect', function(th,rowIndex,keepExisting,r){
				//var curType=store.getAt(rowIndex).get('type');
        		var curType=r.get('type');
				//alert("curType="+curType);
				var reqType="";
				if (curType==dimType){
					reqType=rptType;
				}
				if(curType==rptType){
					reqType=modeType;
				}
				
				if (curType==modeType) return;
				
				for(var i=rowIndex-1;i>=0;i--){
					var type=store.getAt(i).get('type');
					if(type==reqType) {
						if(th.isSelected(i)==false){
							if (reqType==rptType) alert("请先选择导入的报表2！");
							if (reqType==modeType) alert("请先选择导入的模块2！");
							return false;
						}
						break;
					}
				}

				//alert(rowIndex);
        })           
		this.show=function(){
		win.show(this);
	}   
 
}