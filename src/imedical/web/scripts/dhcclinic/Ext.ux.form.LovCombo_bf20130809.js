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
			,beforequery:this.onBeforeQuery   //�ɲ鿴Դ���룬��Ҫ�����ǰ������ֵ�������󴫸�doQuery,��д�Ժ����ò���
			,blur:this.onRealBlur
		});

		// remove selection from input field
		this.onLoad = this.onLoad.createSequence(function() {
			if(this.el) {
				var v = this.el.dom.value;
				this.el.dom.value = '';
				this.el.dom.value = v;
			}
		});
 
    } // e/o function initComponent
    // }}}
	// {{{
	/**
	 * Disables default tab key bahavior
	 * @private
	 */
	,initEvents:function() {
		Ext.ux.form.LovCombo.superclass.initEvents.apply(this, arguments);

		// disable default tab handling - does no good
		this.keyNav.tab = false;

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
		if(this.hiddenField) {
			this.hiddenField.value = '';
		}
		this.applyEmptyText();
	} // eo function clearValue
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
		var snapshot = this.store.snapshot || this.store.data;

		snapshot.each(function(r) {
			if(r.get(this.checkField)) {
				c.push(r.get(field));
			}
		}, this);

		return c.join(this.separator);
	} // eo function getCheckedValue
	// }}}
	// {{{
	/**
	 * beforequery event handler - handles multiple selections
	 * @param {Object} qe query event
	 * @private
	 * ��д��doQuery��û�д�������¼��������������ȡ����
	 */
	,onBeforeQuery:function(qe) {
		qe.query = qe.query.replace(new RegExp(this.getCheckedDisplay() + '[ ' + this.separator + ']*'), '');
		//alert(qe.query)
	} // eo function onBeforeQuery
	// }}}
	// {{{
	  /*
	   trueʱ �ڶ��ֶ��в�ѯ(doQuery).false����displayField�в�ѯ, �����Ǳ���ʱ����Ч  
    */    
    ,queryInFields : false    
    /**  
     ���в�ѯ���ֶ���,��queryInFieldsΪtrue�£�Ĭ����ȫ�����в�ѯ,�����Ǳ���ʱ����Ч 
    */    
  ,queryFields : []
	,doQuery : function (q,forceAll) {
	//q=q.replace(new RegExp(this.getCheckedDisplay() + '[ ' + this.separator + ']*'), '');
	q=q.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), ''); //����RegExp.escape��Ϊ�˷�ֹ��"()"�����
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
		var snapshot = this.store.snapshot || this.store.data;

		// iterate through raw values and records and check/uncheck items
		Ext.each(rva, function(v) {
			snapshot.each(function(r) {
	
				if(v === r.get(this.displayField)) {
					va.push(r.get(this.displayField));
				}
			}, this);
		}, this);
		this.setValue(va.join(this.separator));
		this.store.clearFilter();
	} // eo function onRealBlur
	// }}}
	// {{{
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

			// display full list
			if(this.store.isFiltered()) {
				this.doQuery(this.allQuery); //?????���ε���仯����
				//this.doQuery(this.lastQuery)
				//this.collapse()
			}
      //this.setWidth(250); 
			// set (update) value and fire event
			this.setValue(this.getCheckedDisplay());
      this.fireEvent('select', this, record, index);
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
			if(this.valueField) {
				this.store.clearFilter();
				this.store.each(function(r) {
					
					//alert(RegExp.escape(r.get(this.displayField)))
					var checked = !(!v.match(
						 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.displayField))
						+'(' + this.separator + '|$)'));
					r.set(this.checkField, checked);
				}, this);
				this.value = this.getCheckedValue();
				
				this.setRawValue(this.getCheckedDisplay());
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

}); // eo extend
 
// register xtype
Ext.reg('lovcombo', Ext.ux.form.LovCombo); 
 
// eof