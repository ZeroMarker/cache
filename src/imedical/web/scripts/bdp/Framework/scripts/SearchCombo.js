///名称: 检索框， 将最近操作的最多十条数据展示出来
///编写者：基础数据平台-陈莹
///编写日期: 2017-06-23


/*使用范例
 * 
 ////请确认Ext.BDP.FunLib.SortTableName有定义，如果没有定义，需要单独设置TableName     格式为 "User.CTUOM"
 ////只需要修改id 和disabled里的id


  ///在Ext.onReady之前 引用searchcombo的js  
  ///在工具条上添加检索框  需要修改的只是元素的名称和id
  ///如果 Ext.BDP.FunLib.SortTableName没有定义，需要写成 "User.CTUOM"格式
  document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/SearchCombo.js"> </script>');
  
  
  '检索',{
		xtype : 'searchcombo',
		TableName:Ext.BDP.FunLib.SortTableName,  
		id :'tbUOM',         
		disabled : Ext.BDP.FunLib.Component.DisableFlag('tbUOM'),	
	}
	
	///点搜索按钮的时候内容取值改为：var desc=Ext.getCmp("tbUOM").getRawValue();
	//grid单击事件里加searchTableName为检索框TableName属性的值 （没有单击事件的可以写在修改成功后，有其他关联按钮的也得在按钮点击的时候加，所以还是写个单击事件比较方便）
    RefreshSearchData(searchTableName,myrowid,"A",mydesc)	
    //添加成功后加
	var mydesc=tkMakeServerCall("web.DHCBL.MKB.TKBTremExtendDetail","GetDesc",myrowid)   //获取描述
	RefreshSearchData(searchTableName,myrowid,"A",mydesc)
	//删除成功后加  
	RefreshSearchData(searchTableName,myrowid,"D","")
 */
var GetLimit_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataHistory&pClassMethod=GetList";
Ext.form.SearchCombo = Ext.extend(Ext.form.ComboBox, {	
	labelSeparator:"",
	minChars: 0,
	mode : 'remote',
	shadow:false,
	listWidth:260,
	TableName:'',
	queryParam : 'desc',
	combolimit:"10",           ////chenying add @20170622  医用知识库根据查询条件使用频率检索前十条
	forceSelection : false,    ////可以为下拉框中数据以外的值
	selectOnFocus : false,
	hideTrigger:true,          ////隐藏下拉框后面的箭头
	displayField : 'Desc',   
	valueField : 'ID',  
	store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : GetLimit_QUERY_ACTION_URL}),
			reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		}, [{ name:'ID',mapping:'ID'},
			{name:'Desc',mapping:'Desc'} ])
	}),
	doQuery : function(q){
		q = Ext.isEmpty(q) ? '' : q;
        var qe = {
            query: q,
            combo: this,
            cancel:false
        };
        if(this.fireEvent('beforequery', qe)===false || qe.cancel){
            return false;
        }
        q = qe.query;
        //如果输入框为空,则加载第一页数据
        if(q.length==0){
                this.lastQuery = "";
                this.store.baseParams[this.queryParam] = "";
                this.store.baseParams["combolimit"] = this.combolimit;  ////chenying add @20170622  医用知识库根据频率检索  前十条
                this.store.baseParams["tablename"] = this.TableName;  ////chenying add @20170622  医用知识库根据频率检索  前十条
                this.store.load({
                    params: this.getParams("")
                });
                this.expand();
            
        
        }
        else if(q.length > 0){  //如果输入的字符长度大于等于minChars,则执行查询  if(q.length > this.minChars){
        	if(this.lastQuery !== q){
                this.lastQuery = q;
                this.store.baseParams[this.queryParam] = q;
                this.store.baseParams["combolimit"] = this.combolimit;   ////chenying add @20170622  根据频率检索  前十条
              	this.store.baseParams["tablename"] = this.TableName;  ////chenying add @20170622  根据频率检索  前十条
                this.store.load({
                    params: this.getParams(q)
                });
                this.expand();
                
            }else{
            	
                this.selectedIndex = -1;
                this.onLoad();
               
            }
        }
    },
    listeners:{  //获得焦点即下拉
    	'focus':{fn:function(e){e.expand();this.doQuery(this.allQuery, true);},buffer:200}
    }
    
});

/****新增、单击或者删除数据时，保存到频次和用户最近操作表，保存到临时global，并将hisgrid的数据重新加载**********/
var RefreshSearchData=function(table,dia,flag,desc){
	if ((flag=="A")&(dia!="")&(desc!=""))  //添加或者单击
	{
		
		var searchStr=table+"^"+dia+"^"+desc+"^^"
		var freqResult=tkMakeServerCall("web.DHCBL.BDP.BDPDataFrequency","SaveData",searchStr)  //保存到频次表
		var hisResult=tkMakeServerCall("web.DHCBL.BDP.BDPDataHistory","SaveData",searchStr)  //保存到用户最近操作表
	}
	if ((flag=="D")&(dia!=""))  //删除
	{
		var searchStr=table+"^"+dia
		var freqResult=tkMakeServerCall("web.DHCBL.BDP.BDPDataFrequency","DeleteDataStr",searchStr)   //删除用户最近操作表
		var hisResult=tkMakeServerCall("web.DHCBL.BDP.BDPDataHistory","DeleteDataStr",searchStr)		
	}
}

Ext.reg('searchcombo', Ext.form.SearchCombo);