/*
 *	modified by ZHANGTAO 2012-6-6
 */
 
/*global Ext */

// add RegExp.escape if it has not been already added
if('function' !== typeof RegExp.escape) {
	RegExp.escape = function(s) {
		if('string' !== typeof s) {
			return s;
		}
		// Note: if pasting from forum, precede ]/\ with backslash manually
		return s.replace(/([.*+?^=!:${}()|[\]\/\\])/g, '\\$1');
	}; // eo function escape
}

// create namespace
Ext.ns('Ext.ux.form');
 
/**
 *
 * @class Ext.ux.form.LovCombo
 * @extends Ext.form.ComboBox
 */
Ext.ux.form.LovCombo = Ext.extend(Ext.form.ComboBox, {
	// {{{
    // configuration options
	/**
	 * @cfg {String} checkField name of field used to store checked state.
	 * It is automatically added to existing fields.
	 * Change it only if it collides with your normal field.
	 */
	 checkField:'checked'

	/**
	 * @cfg {String} separator separator to use between values and texts
	 */
    ,separator:','
    ,dvSeparator:'!'
	/**
	 * @cfg {String/Array} tpl Template for items. 
	 * Change it only if you know what you are doing.
	 */
	// }}}
    // {{{
    ,initComponent:function() {
        
		// template with checkbox
		if(!this.tpl) {
			this.tpl = 
				 '<tpl for=".">'
				+'<div class="x-combo-list-item">'
				+'<img src="' + Ext.BLANK_IMAGE_URL + '" '
				+'class="ux-lovcombo-icon ux-lovcombo-icon-'
				+'{[values.' + this.checkField + '?"checked":"unchecked"' + ']}">'
				+'<div class="ux-lovcombo-item-text">{' + (this.displayField || 'text' )+ '}</div>'
				+'</div>'
				+'</tpl>'
			;
		}
		
        // call parent
        Ext.ux.form.LovCombo.superclass.initComponent.apply(this, arguments);

		// install internal event handlers
		this.on({
			 scope:this
			,beforequery:this.onBeforeQuery
			,blur:this.onRealBlur
			//,focus:this.onRealFocus
		});

		// remove selection from input field
		this.onLoad = this.onLoad.createSequence(function() {
			if(this.el) {
				//var v = this.el.dom.value;
				//this.el.dom.value = '';
				//this.el.dom.value = v;
				if(this.mode!='local')
				this.onRealLoad();
			}
		});
        this.cacheStore=new Ext.data.Store();
		this.lastCheckedRecords=new Array(); //save checked records before store reload
		this.store.on({
			scope:this
			,beforeload:this.onStoreBeforeLoad
			,load:this.onStoreLoad
		});
    } // e/o function initComponent
    // }}}
	// {{{
	,onRealLoad:function() {
		var rv = this.getRawValue();
		var rva = rv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
		var va = [];
		var snapshot = this.cacheStore.snapshot || this.cacheStore.data;
		// iterate through raw values and records and check/uncheck items
		//Ext.each(rva, function(v) {
			snapshot.each(function(r) {
				//if(v === r.get(this.displayField)) {
					va.push(r.get(this.displayField));
				//}
			}, this);
		//}, this);
		this.setItemChecked(va.join(this.separator));
		this.setCursor();
	}
	/*当重新加载时把已经勾选的选项勾选*/
    ,setItemChecked:function(v) {  
		if(v) {
			v = '' + v;
			var ifChecked=false;
			if(this.valueField) {
				this.store.clearFilter();
				this.store.each(function(r) {				
					var checked = !(!v.match(
						 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.displayField))
						+'(' + this.separator + '|$)'));
					ifChecked = checked||ifChecked;
					r.set(this.checkField, checked);
				}, this);
				if(ifChecked)this.value = this.getCheckedValue();
				if(this.hiddenField) {
					this.hiddenField.value = this.value;
				}
			}
			else {
				this.value = v;
				this.setRawValue(v);
				if(this.hiddenField) {
					this.hiddenField.value = v;
				}
			}
			if(this.el) {
				this.el.removeClass(this.emptyClass);
			}
		}
		/*else {
			this.clearValue();
		     }*/
	}
	/**
	 * Disables default tab key bahavior
	 * @private
	 */
	,initEvents:function() {
		Ext.ux.form.LovCombo.superclass.initEvents.apply(this, arguments);

		// disable default tab handling - does no good
		//this.keyNav.tab = false;

	} // eo function initEvents
	// }}}
	// {{{
	/**
	 * clears value
	 */
	,clearValue:function() {
		this.value = '';
		this.setRawValue(this.value);
		this.store.clearFilter();
		this.store.each(function(r) {
			r.set(this.checkField, false);
		}, this);
		this.cacheStore.removeAll();
        this.cacheStore.commitChanges() 
		if(this.hiddenField) {
			this.hiddenField.value = '';
		}
		this.applyEmptyText();
	} // eo function clearValue
	//光标定位在文本末尾
	,setCursor:function(){
	 if (document.selection)
	  {
	  var obj=Ext.getDom(this.id);
	  var sel = obj.createTextRange();
      sel.moveStart('character',obj.value.length);
      sel.collapse(true);
      sel.select();
	  }
     }
	
	// }}}
	// {{{
	/**
	 * @return {String} separator (plus space) separated list of selected displayFields
	 * @private
	 */
	,getCheckedDisplay:function() {
		var re = new RegExp(this.separator, 'g');
		//alert("DISPLAY"+"-"+a)
		return this.getCheckedValue(this.displayField).replace(re, this.separator + '');
	} // eo function getCheckedDisplay
	// }}}
	// {{{
	/**
	 * @return {String} separator separated list of selected valueFields
	 * @private
	 */
	,getCheckedValue:function(field) {
		field = field || this.valueField;
		var c = [];

		// store may be filtered so get all records
		if(this.mode=='local') var snapshot = this.store.snapshot || this.store.data;
        else var snapshot = this.cacheStore.snapshot || this.cacheStore.data;
		snapshot.each(function(r) {
			if(r.get(this.checkField)) {
				c.push(r.get(field));
			}
		}, this);
		return c.join(this.separator);
	} // eo function getCheckedValue
	/*
	*获取服务器查询的参数
	*
	*
	*/
	 ,getQueryValue:function()
     {
	   var v=this.getRawValue();
	   v=v.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), '')
	   return v;
     }
	,queryStr:''
	,onRealFocus:function() {
		//this.list.hide();
		var rv = this.getRawValue();
		var rva = rv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
		var va = [];
		if(this.mode=='local')
		var snapshot = this.store.snapshot || this.store.data;
        else 
		var snapshot = this.cacheStore.snapshot || this.cacheStore.data;
		// iterate through raw values and records and check/uncheck items
		Ext.each(rva, function(v) {
			snapshot.each(function(r) {
				if(v === r.get(this.displayField) || v == r.get(this.valueField)) {
					va.push(r.get(this.displayField));
				}
			}, this);
		}, this);
		if(va.length>0)
		{
			this.setValue(va.join(this.separator));
		}
		//this.store.clearFilter();
	}
	// }}}
	// {{{
	/**
	 * beforequery event handler - handles multiple selections
	 * @param {Object} qe query event
	 * @private
	 * 重写了doQuery，没有触发这个事件，这个方法可以取消掉
	 */
	,onBeforeQuery:function(qe) {
		qe.query = qe.query.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), '');
		if(this.mode!='local')
		{
		 var sRv=this.getCheckedDisplay()
		 var rv=this.getRawValue()
		 if(sRv.length>rv.length)
		 {
		 var sRva = sRv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
		 var rva = rv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
		 var va=[]
		 Ext.each(rva,function(v1)
		 {
		   Ext.each(sRva,function(v2)
		   {
		    if(v1===v2) va.push(v1)
		   },this)
		 },this)
         var str=rv		 
		 Ext.each(va,function(v3)
		 {
		  str=str.replace(new RegExp(RegExp.escape(v3) + '[ ' + this.separator + ']*'), '');
		 })
		 str = str.replace(/,/g, "");
		 this.queryStr=str
		 }
		 else this.queryStr=rv.replace(new RegExp(RegExp.escape(sRv) + '[ ' + this.separator + ']*'), '');
		}
	} // eo function onBeforeQuery
	// }}}
	// {{{
	  /*@property queryInFields boolean    
    *@queryInFields true时 在多字段中查询(doQuery).false则在displayField中查询, 数据是本地时才有效  
    */    
    ,queryInFields : false    
    /**  
    *@property queryFields Array   
    *@desc 多列查询的字段名,在queryInFields为true下，默认在全部列中查询,数据是本地时才有效 如: [0,name,age,3]  
    */    
  ,queryFields : []
	,doQuery : function (q,forceAll) {
	//q=q.replace(new RegExp(this.getCheckedDisplay() + '[ ' + this.separator + ']*'), '');
	q=q.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), ''); //加上RegExp.escape是为了防止有"()"的情况
	//alert("Query"+"-"+q)
	q = Ext.isEmpty(q) ? '' : q;
	Ext.ux.form.LovCombo.superclass.doQuery.call(this,q,forceAll);
         if(!forceAll && (q.length >= this.minChars)){          
            if((this.queryInFields===true)&&(this.mode=='local')){                  
                var len = this.queryFields.length ;    
                this.selectedIndex = -1;    
                var f = this.store.fields ;    
                this.store.filterBy(function(r,id){    
                    for(var i=0 ; i<len ; i++){    
                        var name = this.queryFields[i] ;    
                        name = f.containsKey(name) ? name : f.keys[name] ;                  
                        if(RegExp("^"+q).test(r.get(name))){return true;}    
                    }    
                    return false ;     
                },this);    
                this.onLoad();    
            };    
        }    
    }
	/**
	 * blur event handler - runs only when real blur event is fired
	 */
	,onRealBlur:function() {
		this.list.hide();
		var rv = this.getRawValue();
		var rva = rv.split(new RegExp(RegExp.escape(this.separator) + ' *'));
		var va = [];
		if(this.mode=='local')
		var snapshot = this.store.snapshot || this.store.data;
        else 
		var snapshot = this.cacheStore.snapshot || this.cacheStore.data;
		// iterate through raw values and records and check/uncheck items
		Ext.each(rva, function(v) {
			snapshot.each(function(r) {
	
				if(v === r.get(this.displayField)) {
					va.push(r.get(this.displayField));
				}
			}, this);
		}, this);
		if(va.length>0)
		{
			this.setValue(va.join(this.separator));
		}
		this.store.clearFilter();
	} // eo function onRealBlur
	// }}}
	// {{{
	,cacheStore:new Object()
	,loadCacheStore:function(display,value)
	{
	 var _record=new Ext.data.Record([this.checkField,this.displayField,this.valueField]);			
     _record.set(this.checkField,true)
	 _record.set(this.displayField,display)
	 _record.set(this.valueField,value)
	 var _index=this.cacheStore.find(this.valueField,value)
	if(_index==-1)
	this.cacheStore.add(_record)
	}
	,setDefaultValue:function(records)
	{
	 this.cacheStore.removeAll();
	 var count=records.split(this.separator).length
	 for(var i=0;i<count;i++)
	 { 
	 var record=records.split(this.separator)[i];
	 var value=record.split(this.dvSeparator)[0]
	 var display=record.split(this.dvSeparator)[1]
	 if((display=="")||(value=="")) continue;
	 this.loadCacheStore(display,value)
	}
	this.setValue(this.getCheckedDisplay());
	}
	/**
	 * Combo's onSelect override
	 * @private
	 * @param {Ext.data.Record} record record that has been selected in the list
	 * @param {Number} index index of selected (clicked) record
	 */
	,onSelect:function(record, index) {
        if(this.fireEvent('beforeselect', this, record, index) !== false){

			// toggle checked field
			record.set(this.checkField, !record.get(this.checkField));
			if(this.mode!='local')
			{
			if(record.get(this.checkField)==true)
			{
			  this.loadCacheStore(record.get(this.displayField),record.get(this.valueField))
			}
			else
			{
			  var vf=this.valueField
			  var v=record.get(vf)
			  var snapshot = this.cacheStore.snapshot || this.cacheStore.data;
			  snapshot.each(function(r)
			  {
			   if(r.get(vf)==v)
			   {
			    r.store.remove(r)
			   }
			  })
			}
			}
			// display full list
			if(this.store.isFiltered()) {
				this.doQuery(this.allQuery);
				//this.doQuery(this.lastQuery)
				//this.collapse()
			}
      //this.setWidth(250); 
			// set (update) value and fire event
			this.setValue(this.getCheckedDisplay());
     this.fireEvent('select', this, record, index);
	 this.setCursor();
        }
	} // eo function onSelect
	// }}}
	// {{{
	/**
	 * Sets the value of the LovCombo
	 * @param {Mixed} v value
	 */
	,setValue:function(v) {
		  if(v) {
			 v = '' + v;
			 var ifChecked = false;
			 if(this.valueField) {
				this.store.clearFilter();
				this.store.each(function(r) {
					
					//alert(RegExp.escape(r.get(this.displayField)))
					var checked = !(!v.match(
						 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.displayField))
						+'(' + this.separator + '|$)'));
					if(!checked) checked = !(!v.match(
						 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.valueField))
						+'(' + this.separator + '|$)'));
					ifChecked = ifChecked||checked;
					r.set(this.checkField, checked);
				}, this);
				if(ifChecked)
				{
					this.value = this.getCheckedValue();				
					this.setRawValue(this.getCheckedDisplay());
				}
				else
				{
					this.value = v;				
					this.setRawValue(v);
				}
				if(this.hiddenField) {
					this.hiddenField.value = this.value;
				}
					  
			}
			else {
				this.value = v;
				this.setRawValue(v);
				if(this.hiddenField) {
					this.hiddenField.value = v;
				}
			}
			if(this.el) {
				this.el.removeClass(this.emptyClass);
			}
		}
		else {
			this.clearValue();
		}
	} // eo function setValue
	// }}}
	// {{{
	/**
	 * Selects all items
	 */
	,selectAll:function() {
        this.store.each(function(record){
            // toggle checked field
            record.set(this.checkField, true);
        }, this);

        //display full list
        this.doQuery(this.allQuery);
        this.setValue(this.getCheckedValue());
    } // eo full selectAll
	// }}}
	// {{{
	/**
	 * Deselects all items. Synonym for clearValue
	 */
    ,deselectAll:function() {
		this.clearValue();
    } // eo full deselectAll 
	// }}}
	,onStoreBeforeLoad:function(){
		this.lastCheckedRecords = new Array();
		this.store.each(function(r) {				
			if(r.get(this.checkField)) this.lastCheckedRecords.push(r);
		}, this);
	}
	,onStoreLoad:function(){
		for(var i=0;i<this.lastCheckedRecords.length;i++)
		{
			this.store.each(function(r) {				
				if(r.get(this.valueField)== this.lastCheckedRecords[i].get(this.valueField)) this.store.remove(r);
			}, this);
			this.store.insert(i, this.lastCheckedRecords[i]);
		}
	}

}); // eo extend
 
// register xtype
Ext.reg('lovcombo', Ext.ux.form.LovCombo); 
 
// eof
