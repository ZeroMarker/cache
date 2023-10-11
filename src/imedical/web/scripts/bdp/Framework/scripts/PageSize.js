/**
 * PagingToolbarResizer plugin for Ext PagingToolbar
 * Contains a combobox where user can choose the pagesize dynamically
 * @author    sunfengchao
 * @date      2014-2-18
 * @version   1
 * 
 */
Ext.namespace('Ext.BDP.Page.plugin');

/**
 * @class Ext.BDP.Page.plugin.PagingToolbarResizer
 * @extends Ext.Component
 */
Ext.BDP.Page.plugin.PagingToolbarResizer = Ext.extend(Object, {

  options: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
  
  mode: 'remote',
  
  displayText: '每页显示记录',

  constructor: function(config){
    Ext.apply(this, config);
    Ext.BDP.Page.plugin.PagingToolbarResizer.superclass.constructor.call(this, config);
  },

  init : function(pagingToolbar) {
 
    var comboStore = this.options;
   
    var combo = new Ext.form.ComboBox({
      typeAhead: false,
      triggerAction: 'all',
      forceSelection: true,
      selectOnFocus:true,
      lazyRender:true,
      editable: false,
      mode: this.mode,
      value: pagingToolbar.pageSize,
      width:50,
      store: comboStore,
      listeners: {
          select: function(combo, value, i){
          pagingToolbar.pageSize = comboStore[i];
          pagingToolbar.doLoad(Math.floor(pagingToolbar.cursor/pagingToolbar.pageSize)*pagingToolbar.pageSize);
        }
      }
    });

    var index = 0;
    
    if (this.prependCombo){
     index = pagingToolbar.items.indexOf(pagingToolbar.first);
     index--;
    } else{
     index = pagingToolbar.items.indexOf(pagingToolbar.refresh);
        pagingToolbar.insert(++index,'-');
    }
    
    pagingToolbar.insert(++index, this.displayText);
    pagingToolbar.insert(++index, combo);
    
    if (this.prependCombo){
      pagingToolbar.insert(++index,'-');
    }
    
    //destroy combobox before destroying the paging toolbar
    pagingToolbar.on({
      beforedestroy: function(){
     combo.destroy();
      }
    });

  }
});
