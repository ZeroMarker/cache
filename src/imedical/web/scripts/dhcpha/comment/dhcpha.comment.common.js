/**
 * creator:    yunhaibao
 * createdate: 2017-03-21
 * description:处方点评公共js
 */
// 去掉fieldLabel的冒号
Ext.apply(Ext.form.Field.prototype,{labelSeparator:""});
// grid 行数列宽度
Ext.grid.RowNumberer.prototype.width = 30;