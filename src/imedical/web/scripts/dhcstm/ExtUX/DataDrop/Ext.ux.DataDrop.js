Ext.ns('Ext.ux.grid');
/**
 * @author Shea Frederick - http://www.vinylfox.com
 * @contributor Nigel (Animal) White, Andrea Giammarchi & Florian Cargoet
 * @class Ext.ux.grid.DataDrop
 * @singleton
 * <p>A plugin that allows data to be dragged into a grid from spreadsheet applications (tabular data).</p>
 * <p>Requires the Override.js file which adds mouse event forwarding capability to ExtJS</p>
 * <p>Sample Usage</p>
 * <pre><code>
 {
     xtype: 'grid',
     ...,
     plugins: [Ext.ux.grid.DataDrop],
     ...
 }
 * </code></pre>
 */
Ext.ux.grid.DataDrop = (function(){

    var lineEndRE = /\r\n|\r|\n/,
       // sepRe = /\s*\t\s*/;
          sepRe="	";
    //  After the GridView has been rendered, insert a static transparent textarea over it.
    function onViewRender(){
        var v = this.view;
        if (v.mainBody) {
            this.textEl = Ext.DomHelper.insertAfter(v.scroller, {
                tag: 'textarea',
                id: Ext.id(),
                value: '',
                style: {
                    'font-size': '1px',
                    border: '0px none',
                    overflow: 'hidden',
                    color: '#fff',
                    position: 'absolute',
                    top: v.mainHd.getHeight() + 'px',
                    left: '0px',
                    'background-color': '#fff',
                    margin: 0,
                    cursor: 'default'
                }
            }, true);
            this.textEl.setOpacity(0.1);
            this.textEl.forwardMouseEvents();
            this.textEl.on({
                mouseover: function(){
                    Ext.TaskMgr.start(this.changeValueTask);
                },
                mouseout: function(){
                    Ext.TaskMgr.stop(this.changeValueTask);
                },
                scope: this
            });
            resizeDropArea.call(this);
        }
    }
    
    //  on GridPanel resize, keep scroller height correct to accomodate textarea.
    function resizeDropArea(){
        if (this.textEl) {
            var v = this.view,
                sc = v.scroller,
                scs = sc.getSize,
                s = {
                    width: sc.dom.clientWidth || (scs.width - v.getScrollOffset() + 2),
                    height: sc.dom.clientHeight || scs.height
                };
            this.textEl.setSize(s);
        }
    }
    
    //  on change of data in textarea, create a Record from the tab-delimited contents.
    function dataDropped(e, el){
        var nv = el.value;
        el.blur();
        if (nv !== '') {
            var store = this.getStore(), Record = store.recordType;
            el.value = '';
            var rows = nv.split(lineEndRE), cols = this.getColumnModel().getColumnsBy(function(c){
                return !c.hidden && c.dataIndex != '';
            }), fields = Record.prototype.fields;
            
            if (cols.length && rows.length) {
            	//0-->1 : 表头不处理
                for (var i = 1; i < rows.length; i++) {
                	//alert(rows[i]);
                    var vals = rows[i].split(sepRe), data = {};
                    if (vals.join('').replace(' ', '') !== '') {
                    	//vals.length改为cols.length,vals[k]判断, 避免copy列数不符时的报错或取值undefined
                        for (var k = 0, len = cols.length; k < len; k++) {
                            var fldName = cols[k].dataIndex;
                            var fld = fields.item(fldName);
                            var colValue = vals[k] ? vals[k] : '';
                            var vv = fld ? fld.convert(colValue) : colValue;
                            if("undefined" == typeof vv) {
                            	vv= vals[k];
                            	var d=new Date(vv);
								vv = d.format(ARG_DATEFORMAT);
							}
                            //alert("fldName="+fldName+";fld="+fld+";vv="+vv);
                            data[fldName] = vv ;
                        }
                        var newRec = new Record(data);
                        store.add(newRec);
                        var idx = store.indexOf(newRec);
                        this.view.focusRow(idx);
                        Ext.get(this.view.getRow(idx)).highlight();
                    }
                }
                resizeDropArea.call(this);
            }
        }
    }
    
    return {
        init: function(cmp){
            Ext.apply(cmp, {
                changeValueTask: {
                    run: function(){
                        dataDropped.call(this, null, this.textEl.dom);
                    },
                    interval: 100,
                    scope: cmp
                },
                onResize: cmp.onResize.createSequence(resizeDropArea)
            });
            cmp.getView().afterRender = cmp.getView().afterRender.createSequence(onViewRender, cmp);
        }
    };
})();