// vim: ts=4:sw=4:nu:fdc=4:nospell
/*global Ext */
/**
 * @class Ext.ux.form.LovCombo
 * @extends Ext.form.ComboBox
 *
 * Simple list of values Combo
 *
 * @author    Ing. Jozef Sakáloš
 * @copyright (c) 2008, by Ing. Jozef Sakáloš
 * @version   1.3
 * @date      <ul>
 * <li>16. April 2008</li>
 * <li>2. February 2009</li>
 * </ul>
 * @revision  $Id: Ext.ux.form.LovCombo.js 733 2009-06-26 07:29:07Z jozo $
 *
 * @license Ext.ux.form.LovCombo.js is licensed under the terms of the Open Source
 * LGPL 3.0 license. Commercial use is permitted to the extent that the 
 * code/component(s) do NOT become part of another Open Source or Commercially
 * licensed development library or toolkit without explicit permission.
 * 
 * <p>License details: <a href="http://www.gnu.org/licenses/lgpl.html"
 * target="_blank">http://www.gnu.org/licenses/lgpl.html</a></p>
 *
 * @forum     32692
 * @demo      http://lovcombo.extjs.eu
 * @download  
 * <ul>
 * <li><a href="http://lovcombo.extjs.eu/lovcombo.tar.bz2">lovcombo.tar.bz2</a></li>
 * <li><a href="http://lovcombo.extjs.eu/lovcombo.tar.gz">lovcombo.tar.gz</a></li>
 * <li><a href="http://lovcombo.extjs.eu/lovcombo.zip">lovcombo.zip</a></li>
 * </ul>
 *
 * @donate
 * <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
 * <input type="hidden" name="cmd" value="_s-xclick">
 * <input type="hidden" name="hosted_button_id" value="3430419">
 * <input type="image" src="https://www.paypal.com/en_US/i/btn/x-click-butcc-donate.gif" 
 * border="0" name="submit" alt="PayPal - The safer, easier way to pay online.">
 * <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
 * </form>
 */
 var tempElDomValue="";
// Check RegExp.escape dependency
if('function' !== typeof RegExp.escape) {
	throw('RegExp.escape function is missing. Include Ext.ux.util.js file.');
}

// create namespace
Ext.ns('Ext.ux.form');
 
/**
 * Creates new LovCombo
 * @constructor
 * @param {Object} config A config object
 */
Ext.ux.form.LovCombo = Ext.extend(Ext.form.ComboBox, {

	// {{{
    // configuration options
	/**
	 * @cfg {String} checkField Name of field used to store checked state.
	 * It is automatically added to existing fields.
	 * (defaults to "checked" - change it only if it collides with your normal field)
	 */
	 checkField:'checked',
	triggerAction:'all'
	/**
	 * @cfg {String} separator Separator to use between values and texts (defaults to "," (comma))
	 */
    ,separator:','

	/**
	 * @cfg {String/Array} tpl Template for items. 
	 * Change it only if you know what you are doing.
	 */
	// }}}
	// {{{
	,constructor:function(config) {
		config = config || {};
		config.listeners = config.listeners || {};
		Ext.applyIf(config.listeners, {
			 scope:this
			,beforequery:this.onBeforeQuery
			,blur:this.onRealBlur
		});
		Ext.ux.form.LovCombo.superclass.constructor.call(this, config);
	} // eo function constructor
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
				+'<div class="ux-lovcombo-item-text">{' + (this.displayField || 'text' )+ ':htmlEncode}</div>'
				+'</div>'
				+'</tpl>'
			;
		}
 
        // call parent
        Ext.ux.form.LovCombo.superclass.initComponent.apply(this, arguments);

		// remove selection from input field
		this.onLoad = this.onLoad.createSequence(function() {
			if(this.el) {
				var v = this.el.dom.value;
				//alert(v)
				this.el.dom.value = '';
				this.el.dom.value = v;
			}
		});
 
    } // eo function initComponent
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
	 * Clears value
	 */
	,clearValue:function() {
		//alert(this.el.dom.value)
		this.el.dom.value = '';
		this.value='';
	    this.store.each(function(record){
            // toggle checked field
            record.set(this.checkField, false);
        }, this);

		if (this.hiddenField){
			this.hiddenField.value='';
		}
		
	} // eo function clearValue
	// }}}
	// {{{
	/**
	 * @return {String} separator (plus space) separated list of selected displayFields
	 * @private
	 */
	,getCheckedDisplay:function() {
		var re = new RegExp(this.separator, "g");
		return this.getCheckedValue(this.displayField).replace(re, this.separator + ' ');
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
	 */
	,onBeforeQuery:function(qe) {
		//alert(this.separator)
		qe.query = qe.query.replace(new RegExp(RegExp.escape(this.getCheckedDisplay()) + '[ ' + this.separator + ']*'), '');
	} // eo function onBeforeQuery
	// }}}
	// {{{
	
	
	,beforeBlur:function(){
		tempElDomValue=this.el.dom.value;
		//alert(this.getCheckedValue())
        //this.setValue(this.getCheckedValue(),this.el.dom.value);
		
     }

	
	/**
	 * blur event handler - runs only when real blur event is fired
	 * @private
	 */
	,onRealBlur:function() {
          //alert("dd")
		  //alert(this.el.dom.value)
		  //alert("onRealBlur")
		  tempElDomValue="";
		  //alert(this.selectall)
		   if(this.showSelectAll){  
		        if(this.selectall.hasClass("ux-combo-selectall-icon-checked")){  
                   this.selectall.replaceClass("ux-combo-selectall-icon-checked","ux-combo-selectall-icon-unchecked");  
                }
		   }
	} 
	// eo function onRealBlur
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

		     //alert(index)
			// toggle checked field
			//alert(this.checkField)
			record.set(this.checkField, !record.get(this.checkField));
			// display full list
			if(this.store.isFiltered()) {
				this.doQuery(this.allQuery);
			}

			// set (update) value and fire event
			//alert(this.getCheckedValue())
			this.setValue(this.getCheckedValue(),"","select");
            this.fireEvent('select', this, record, index);
        }
	} // eo function onSelect
	// }}}
	// {{{
	/**
	 * Sets the value of the LovCombo. The passed value can by a falsie (null, false, empty string), in
	 * which case the combo value is cleared or separator separated string of values, e.g. '3,5,6'.
	 * @param {Mixed} v value
	 */
	,setValue:function(v,vv,vvv) {
		//alert(tempElDomValue+"v:"+v+"vv:"+vv+"vvv:"+vvv)
		if(vv){
        var text = vv;
		//alert(vv)
		//alert(this.valueField)
        if(this.valueField){
            var r = this.findRecord(this.valueField, vv);
            if(r){
                text = r.data[this.displayField];
            }else if(Ext.isDefined(this.valueNotFoundText)){
                text = this.valueNotFoundText;
            }
        }
        this.lastSelectionText = text;
        if(this.hiddenField){
            this.hiddenField.value = Ext.value(vv, '');
        }
        Ext.form.ComboBox.superclass.setValue.call(this, text);
        this.value = vv;
		this.setRawValue(vv);
        return this;
		}
		else if((tempElDomValue!="")&&(!vvv))
		{			
				//this.value = tempElDomValue;
				//this.setRawValue(tempElDomValue);
		}
		else if(v) {
			//alert(vv)	
			v = '' + v;
			if(this.valueField) {
				this.store.clearFilter();
				this.store.each(function(r) {
					var checked = !(!v.match(
						 '(^|' + this.separator + ')' + RegExp.escape(r.get(this.valueField))
						+'(' + this.separator + '|$)'))
					;

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
			   if(this.selectall){  
                if(this.getCheckedValue().split(",").length == this.store.getCount()){  
                    this.selectall.replaceClass("ux-combo-selectall-icon-unchecked","ux-combo-selectall-icon-checked");  
                }else{  
                    this.selectall.replaceClass("ux-combo-selectall-icon-checked","ux-combo-selectall-icon-unchecked")  
                }  
            }  
		}
		else {
			//alert(33)
			this.clearValue();
		}
	} // eo function setValue
	// }}}
	// {{{
	/**
	 * Selects all items
	 */
	,
	 initList : function(){  
	    //alert(this.list)
        if(!this.list){  
            var cls = 'x-combo-list';  
            this.list = new Ext.Layer({  
                parentEl: this.getListParent(),  
                shadow: this.shadow,  
                cls: [cls, this.listClass].join(' '),  
                constrain:false  
            });  
           
            var lw = this.listWidth || Math.max(this.wrap.getWidth(), this.minListWidth);  
            this.list.setSize(lw, 0);  
            this.list.swallowEvent('mousewheel');  
            this.assetHeight = 0;  
            if(this.syncFont !== false){  
                this.list.setStyle('font-size', this.el.getStyle('font-size'));  
            }  
            if(this.title){  
                this.header = this.list.createChild({cls:cls+'-hd', html: this.title});  
                this.assetHeight += this.header.getHeight();  
            }  
              
            if(this.showSelectAll){  
                this.selectall = this.list.createChild({  
                    cls:cls + 'item ux-combo-selectall-icon-unchecked ux-combo-selectall-icon',  
                    html: "选择全部"  
                });  
			
                this.selectall.on("click",function(el){  
                    if(this.selectall.hasClass("ux-combo-selectall-icon-checked")){  
                        this.selectall.replaceClass("ux-combo-selectall-icon-checked","ux-combo-selectall-icon-unchecked");  
                        this.deselectAll();  
                    }else{  
                        this.selectall.replaceClass("ux-combo-selectall-icon-unchecked","ux-combo-selectall-icon-checked")  
                        this.selectAll();  
                    }  
                },this);  
                this.assetHeight += this.selectall.getHeight();  
            }  
  
            this.innerList = this.list.createChild({cls:cls+'-inner'});  
            this.mon(this.innerList, 'mouseover', this.onViewOver, this);  
            this.mon(this.innerList, 'mousemove', this.onViewMove, this);  
            this.innerList.setWidth(lw - this.list.getFrameWidth('lr'));  
  
            if(this.pageSize){  
                this.footer = this.list.createChild({cls:cls+'-ft'});  
                this.pageTb = new Ext.PagingToolbar({  
                    store: this.store,  
                    pageSize: this.pageSize,  
                    renderTo:this.footer  
                });  
                this.assetHeight += this.footer.getHeight();  
            }  
  
            if(!this.tpl){  
                this.tpl = '<tpl for="."><div class="'+cls+'-item">{' + this.displayField + '}</div></tpl>';  
            }  
  
            this.view = new Ext.DataView({  
                applyTo: this.innerList,  
                tpl: this.tpl,  
                singleSelect: true,  
                selectedClass: this.selectedClass,  
                itemSelector: this.itemSelector || '.' + cls + '-item',  
                emptyText: this.listEmptyText  
            });  
  
            this.mon(this.view, 'click', this.onViewClick, this);  
  
            this.bindStore(this.store, true);  
  
            if(this.resizable){  
                this.resizer = new Ext.Resizable(this.list,  {  
                   pinned:true, handles:'se'  
                });  
                this.mon(this.resizer, 'resize', function(r, w, h){  
                    this.maxHeight = h-this.handleHeight-this.list.getFrameWidth('tb')-this.assetHeight;  
                    this.listWidth = w;  
                    this.innerList.setWidth(w - this.list.getFrameWidth('lr'));  
                    this.restrictHeight();  
                }, this);  
  
                this[this.pageSize?'footer':'innerList'].setStyle('margin-bottom', this.handleHeight+'px');  
            }  
        }  
    }
	,  
	  expand : function(){  
        if(this.isExpanded() || !this.hasFocus){  
            //return;  
        }  
        this.list.alignTo(this.wrap, this.listAlign);  
        this.list.show();  
        if(Ext.isGecko2){  
            this.innerList.setOverflow('auto'); // necessary for FF 2.0/Mac  
        }  
        Ext.getDoc().on({  
            scope: this,  
            mousewheel: this.collapseIf,  
            mousedown: this.collapseIf  
        });  
        this.fireEvent('expand', this);  
    },  
	selectAll:function() {
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
