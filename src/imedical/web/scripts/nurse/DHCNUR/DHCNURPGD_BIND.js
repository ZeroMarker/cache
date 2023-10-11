//名称（mygrid）
var ruleCode=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'ruleCode',
	xtype:'textfield'
});
//描述（mygrid）
var ruleName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'ruleName',
	xtype:'textfield'
});
//类名mygrid）
var className=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'className',
	xtype:'textfield'
});
//方法名（mygrid）
var MethodName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
    //height:16,
	id:'MethodName',
	xtype:'textfield'
});
var window1=""
locdata = new Array();
locdata3 = new Array();
var onezkitemdesc="";
	var descseqno=0;
	var locdata3 = new Array();  
	/*var store3=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo4={
		name:'模板',
		id:'BindEle',
		tabIndex:'0',
		x:84,
		y:131,
		height:21,
		width:252,
		xtype:'combo',
		store:store3,
		displayField:'desc',
		valueField:'id',
		editable:false,
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
            	 
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                descseqno=0;
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                        descseqno=descseqno+1;
                    }
                });

                onezkitemdesc=str;
                
                this.setValue(str.join());
                this.value=str.join();
     
                this.valueId= strvalue.join();
			              
                this.fireEvent('select', this, record, index);      
                 var Nullitem = Ext.getCmp("Nullitem"); //不允许为空维护
                 var flag=addstore(this.value,str.join())  //更新store	              
	               Nullitem.store.loadData(locdata5);
	               checkselect("Nullitem",flag)
	               
	                var Ifself = Ext.getCmp("Ifself"); //只允许本人修改项维护	          
                 var flag7=addstoreitm(this.value,str.join(),"Ifself",locdata7)  //更新store	             
	               Ifself.store.loadData(locdata7);
	               checkselect("Ifself",flag7)

             }
        },
		value:'',
		valueId:''
	};*/
	var store3=new Ext.data.JsonStore({data:[],fields: ['desc', 'id']});
	var combo4={
		name:'模板',
		id:'BindEle',
		tabIndex:'0',
		x:84,
		y:320,
		height:21,
		width:252,
		xtype:'combo',
		editable:false,
		store:store3,
		displayField:'desc',
		valueField:'id',
		allowBlank: true,
		triggerAction: 'all',
		tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>',
		emptyText:'请选择',
		selectOnFocus:true,
    //applyTo:'local-descs',
		mode:'local',
		onSelect : function(record, index){
            if(this.fireEvent('beforeselect', this, record, index)){
                record.set('check',!record.get('check'));
                var str=[];//页面显示的值
                var strvalue=[];//传入后台的值
                this.store.each(function(rc){
                    if(rc.get('check')){
                        str.push(rc.get('desc'));
                        strvalue.push(rc.get('id'));
                    }
                });
                //alert(str)
                this.setValue(str.join());
                this.value=strvalue.join();
                this.valueId= strvalue.join();
              							
                 //this.collapse();
                this.fireEvent('select', this, record, index);
                //findperson (record.get('id'),record,index);
                //if (this.valueId==null||this.valueId==''||this.valueId.split(",").length>1)
                //{
                 	//clearperson('RequestConDoc');
                //}
             }
        },
		value:'',
		valueId:''
	};
function addloc3(a, b) {
	
	locdata3.push({
				id : a,
				desc : b
			});
}


function GetDepModeElelSet()
{
	locdata3 = new Array();
	
		
		var BindEle = Ext.getCmp("BindEle");
	    var getitms = document.getElementById('getitms');
	    cspRunServerMethod(getitms.value,NurRecId,"addloc3");
	    BindEle.store.loadData(locdata3);	
	
}
locdata4 = new Array();
function addloc4(a, b) {
	//alert(a)
	locdata4.push({
				id : a,
				desc : b
			});
}
locdata5 = new Array();
function addloc5(a, b) {
	
	locdata5.push({
				id : a,
				desc : b
			});
}


function Gettype()
{
	locdata5 = new Array();
	
		
		var type = Ext.getCmp("type");
	    var GetType = document.getElementById('GetType');
	    cspRunServerMethod(GetType.value,"addloc5");
	    type.store.loadData(locdata5);	
	
}
function setvalue()
{
	
    if(AnaesID!=""){
	var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","getBindInfo",NurRecId);
	var a=ret.split("^");
	var Num=Ext.getCmp("Num");
	Num.setValue(a[0]);
	var BindName=Ext.getCmp("BindName");
	BindName.setValue(a[1]);
	var BindEle=Ext.getCmp("BindEle");
	BindEle.setValue(a[2]);
	var ruleMode=Ext.getCmp("ruleMode");
	ruleMode.setValue(a[4]);
	  }
}
function BodyLoadHandler(){
	
	var OnBind = Ext.getCmp("OnBind");
	OnBind.on('click', save);
	var Name=tkMakeServerCall("NurMp.TemplateCategory","GetTemName",NurRecId); 
	
    var BindName=Ext.getCmp("BindName");
	BindName.setValue(Name);
	GetDepModeElelSet();
	Gettype();
	setvalue();
}

function save()
{
	
	var Num=Ext.getCmp("Num");
	var BindName=Ext.getCmp("BindName");
	var BindEle=Ext.getCmp("BindEle");
	var type=Ext.getCmp("type");
	var ruleMode=Ext.getCmp("ruleMode");
	if(Num.value=="")
	{
		alert("请选择第几次！");
		return;
	}
	if(BindName.getValue()=="")
	{
		alert("请维护名称！");
		return;
	}
	if(BindEle.value=="")
	{
		alert("请选择绑定模板元素！");
		return;
	}
	if(ruleMode.value=="")
	{
		alert("请选择传输方式！");
		return;
	}
	if(AnaesID!=""){
		var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","save",Num.value+"^"+BindName.getValue()+"^"+BindEle.value+"^"+NurRecId+"^"+type.value+"^"+ruleMode.value,AnaesID);
	}
	else{
	var ret=tkMakeServerCall("NurMp.DHCNurEmrBind","save",Num.value+"^"+BindName.getValue()+"^"+BindEle.value+"^"+NurRecId+"^"+type.value+"^"+ruleMode.value,"");
	}
	if(ret!=0)
	{
		 Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '保存成功! 您要关闭该页面吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	           if (self.parent)
				  {
					 self.parent.close();
					 //return;
				  }else{
					 self.close();  //关闭子窗口 
				  }				                       			
				  if (self.opener)
				  {
					 window.opener.find();
				  }	   
	            
	            }
					        else
	            {   setvalue()  	}
	            
	        },    
	       animEl: 'newbutton'   
	       });
	}

	//find();
	return;
}





