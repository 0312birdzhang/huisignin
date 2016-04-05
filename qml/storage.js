.pragma library
.import QtQuick.LocalStorage 2.0 as SQL

function getDatabase() {
     return  SQL.LocalStorage.openDatabaseSync("huisignin", "1.0", "huihui", 1000000);
}

function initialize(){
    var db = getDatabase()
    db.transaction(function(tx){
                       tx.executeSql('CREATE TABLE IF NOT EXISTS combo(cname TEXT UNIQUE, ctitle TEXT)')
                   })
}

function addCombo(cname, ctitle){
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx){
                       var rs = tx.executeSql('INSERT OR REPLACE INTO combo VALUES (?,?);',[cname, ctitle])
                       res = rs.rowsAffected > 0;
                   })
    return res;
}

function loadCombo(model){
    model.clear();
    var db = getDatabase();
    db.readTransaction(function(tx){
                           var rs = tx.executeSql('SELECT * FROM combo')
                           for (var i=0, l = rs.rows.length; i < l; i++){
                               var t = rs.rows.item(i);
                               //console.log("ctitle:"+ t.ctitle);
                               model.append({"ctitle":t.ctitle, "cname":t.cname})
                           }
                       })
}

function removeCombo(cname){
    var db = getDatabase();
    db.transaction(function(tx){
                       tx.executeSql('DELETE FROM combo WHERE cname=?;',[cname])
                   })
}




