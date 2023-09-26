/*!
 * Ext JS Library 3.3.0
 */
/**
 * @creator:yunhaibao
 * @createdate: 20161220
 * @description:此js继承Ext.form.ComboBox,利用tpl实现多列显示
 */   
Ext.ns('Ext.ux');
Ext.ux.GridComboBox=Ext.extend(
	Ext.form.ComboBox,
	{
	    triggerAction : 'all',   
	    allowBlank : false,   
	    forceSelection : false,   
	    mode : 'remote',
		selectOnFocus : true,
	    itemSelector: '.x-combo-list-item',
	    listWidth : 'auto',
		autoHeight:true,
		pageSize : 50,
		minChars :6,
		queryDelay :1,
		hideTrigger:true, 
		loadingText:'加载中...', 
		listeners :{
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					return false									
				}
			}
		},
		initComponent:function() { 	
	        Ext.ux.GridComboBox.superclass.initComponent.apply(this, arguments);
		},
		initList : function(){ 		
		  if((!this.tpl)&&(this.displayFields)){  // 展示多列    
            var tplString = "" ;  
            var tplTreadString='<tr class="x-combo-list">';  
            var cls = 'x-combo-list';     
            var cbW = this.width || 150 ;           
            var dfLen = this.displayFields.length ;    
            var w =(cbW/dfLen).toFixed(2) ;                
            var f = this.store.fields ;    
            Ext.each(this.displayFields , function(indexname){
	            var displayTitle=indexname.title;
	            var displayName=indexname.index;
	            var hidden=indexname.hidden;
	            var w=parseFloat(indexname.length).toFixed(2) ;  
	            if (hidden==true){
		            tplString += '<td style="display:none">{'+displayName+'}</td>' ; 	
		        }else{
		            tplTreadString+='<th style="text-align:center;background:#F9F9F9">'+displayTitle+'</th>';
	                //name = f.containsKey(name) ? name : f.keys[name] ;  //列名或列号
	                tplString += '<td width='+w+'>{'+displayName+'}</td>' ; 
		        }   
            },this);
            tplTreadString+='</tr>'                       
            this.tpl = new Ext.XTemplate(    
                '<table style="border: 1px solid #D6E3F2;cellspacing=0;cellpadding=0">'
                +tplTreadString
                +'<tpl for=".">'
                +'<tr class="'+cls+'-item" height="30px" >',   
                    tplString  
                +'</tr>'
                +'</tpl>'
                +'</table>'    
            );    
        	}    
         Ext.ux.GridComboBox.superclass.initList.call(this);    
		},
		onBeforeLoad : function(){
	        if(!this.hasFocus){
	            return;
	        }
	        this.innerList.update(this.loadingText ?
	               '<div class="loading-indicator">'+this.loadingText+'</div>' : '');
	       	//this.innerList.update(this.loadingText ?
	          //     '<div style="height:20px;font-size:15px">'+this.loadingText+'</div>' : '');
	        this.restrictHeight();
	        this.selectedIndex = -2;
	    },
	    onLoad : function(){
	        if(!this.hasFocus){
	            return;
	        }
	        if(this.store.getCount() > 0 || this.listEmptyText){
	            this.expand();
	            this.restrictHeight();
	            if(this.lastQuery == this.allQuery){
	                if(this.editable){
	                    this.el.dom.select();
	                }

	                if(this.autoSelect !== false && !this.selectByValue(this.value, true)){
	                    this.select(0, true);
	                }
	            }else{
	                if(this.autoSelect !== false){
		                this.select(0, true);
	                    //this.selectNext(); //yunhaibao,默认首行问题
	                }
	                if(this.typeAhead && this.lastKey != Ext.EventObject.BACKSPACE && this.lastKey != Ext.EventObject.DELETE){
	                    this.taTask.delay(this.typeAheadDelay);
	                }
	            }
	        }else{
	            this.collapse();
	        }

	    }    
	}
)
//注册xtype的
//Ext.reg('sg',Ext.ux.ComboGridBox);
