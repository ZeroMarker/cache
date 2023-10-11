/*!
 * Ext JS Library 3.2.1
 * Copyright(c) 2006-2010 Ext JS, Inc.
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ns('Ext.ux.grid');

/**
 * @class Ext.ux.grid.CheckColumn
 * @extends Object
 * GridPanel plugin to add a column with check boxes to a grid.
 * <p>Example usage:</p>
 * <pre><code>
// create the column
var checkColumn = new Ext.grid.CheckColumn({
   header: 'Indoor?',
   dataIndex: 'indoor',
   id: 'check',
   width: 55
});

// add the column to the column model
var cm = new Ext.grid.ColumnModel([{
       header: 'Foo',
       ...
    },
    checkColumn
]);

// create the grid
var grid = new Ext.grid.EditorGridPanel({
    ...
    cm: cm,
    plugins: [checkColumn], // include plugin
    ...
});
 * </code></pre>
 * In addition to storing a Boolean value within the record data, this
 * class toggles a css class between <tt>'x-grid3-check-col'</tt> and
 * <tt>'x-grid3-check-col-on'</tt> to alter the background image used for
 * a column.
 */

Ext.grid.CheckColumn = function(config){
	this.addEvents({
		click: true
	});
	Ext.grid.CheckColumn.superclass.constructor.call(this);

	Ext.apply(this, config, {
		init : function(grid){
			this.grid = grid;
			this.grid.on('render', function(){
				var view = this.grid.getView();
				view.mainBody.on('mousedown', this.onMouseDown, this);
			}, this);
		},

		onMouseDown : function(e, t){
			if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
				e.stopEvent();
				var index = this.grid.getView().findRowIndex(t);
				var record = this.grid.store.getAt(index);
				record.set(this.dataIndex, !record.data[this.dataIndex]);
				this.fireEvent('click', this, e, record);
			}
		},

		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'"> </div>';
		}
	});

	if(!this.id){
		this.id = Ext.id();
	}
	this.renderer = this.renderer.createDelegate(this);
};

Ext.extend(Ext.grid.CheckColumn, Ext.util.Observable);