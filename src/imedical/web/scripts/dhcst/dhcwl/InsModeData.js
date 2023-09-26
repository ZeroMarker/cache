(function(){
	Ext.ns("dhcwl.mkpi.InsModeData");
})();

dhcwl.mkpi.InsModeData=function(){

	var outThis=this;
   	var modeData = new Array(); 
	var rptData=new Array();
	var dimData=new Array();
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
			fieldLabel:'指标文件',
			inputType:'file',
			id:'selectImportModeFile'
		},{items:grid}], 
		tbar: new Ext.Toolbar([{
        	text: '读入指标文件',
            handler: onBeforeImport
        },'-',{
			text: '导入指标',
    		handler: onImport
		}
		])
    });	
    
	function onBeforeImport(btn, ev){
    	var path=Ext.get('selectImportModeFile').getValue();
    	if(!path||path==""){
    		alert("请选择要导入的XML文件！");
    		return;
    	}
 
    	var xmlDoc=dhcwl.mkpi.util.XML.loadXML(path);
    	
    	var x = xmlDoc.getElementsByTagName("root"); //documentElement.childNodes[0];  
    	if(!x||x.length==0){
    		x = xmlDoc.getElementsByTagName("root");
    	}
    	if(!x||x.length==0){
    		alert("导入的文件格式不正确");
    		return;
    	}
    	

    	modeData.length=0; 
    	rptData.length=0; 
    	dimData.length=0; 

    	var nodes=xmlDoc.getElementsByTagName("modeCfg");
    	var i=0;
    	var modeCodes='';
    	var rptCodes="";
    	var dimCodes="";
    	
    	//var modeType="模块";
    	for (i=0;i<=nodes.length-1;i++) {
    		var node=nodes[i];
    		var code=node.childNodes[1].text;
    		var desc=node.childNodes[2].text;
    		var PCode=node.childNodes[3].text;
    		modeData.push([modeType,code,desc,PCode]);
    		if(modeCodes.length>0)
    			modeCodes += ',';
    		modeCodes += "'"+code+"'";
       	}
    	
    	//var rptType="|----报表";
    	var nodes=xmlDoc.getElementsByTagName("rptCfg");
    	var i=0;
    	for (i=0;i<=nodes.length-1;i++) {
    		var node=nodes[i];
    		var code=node.childNodes[1].text;
    		var desc=node.childNodes[2].text;
    		var PCode=node.childNodes[4].text;
    		rptData.push([rptType,code,desc,PCode]);
    		
    		if(rptCodes=="")
    			rptCodes="'"+code+"'";
    		else
    			rptCodes=rptCodes+",'"+code+"'";
    	}         
    	
    	//var dimType="|--------指标";
   		var nodes=xmlDoc.getElementsByTagName("dimCfg");
    	var i=0;
    	//var jdata= new Array();
    	for (i=0;i<=nodes.length-1;i++) {
    		var node=nodes[i];
    		var code=node.childNodes[1].text;
    		var dimRule=node.childNodes[2].text;
    		var filterRule=node.childNodes[3].text;
    		var desc="";
    		var PCode=node.childNodes[4].text;
    		var orderNum=node.childNodes[5].text;
    		//jdata.push({type:"dim",code:code,desc:desc,pcode:PCode});
    		dimData.push([dimType,code,desc,PCode,dimRule,filterRule,orderNum]);
    		
   			if(dimCodes=="")
    			dimCodes="'"+code+"'";
    		else
    			dimCodes=dimCodes+",'"+code+"'";            		
    	} 
    	
    	
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
				
				}else{ 
						Ext.Msg.show({
									title : '检查失败',
									msg : "检查失败",
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}}, outThis);		        
			}
            
    	
	function onImport(btn, ev){ 
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
						icon : Ext.MessageBox.ERROR
					});

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
            title: 'Layout Window',
            closable:true,
            width:600,
            height:420,
            //border:false,
            plain:true,
            layout: 'border',

            items: [inputForm]
        });

        
	
		this.show=function(){
		win.show(this);
	}   
 
}