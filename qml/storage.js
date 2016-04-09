.pragma library
.import QtQuick.LocalStorage 2.0 as SQL

function getDatabase() {
     return  SQL.LocalStorage.openDatabaseSync("huisignin", "1.0", "huihui", 1000000);
}

function initialize(){
    var db = getDatabase()
    db.transaction(function(tx){
                       tx.executeSql('CREATE TABLE IF NOT EXISTS combo(cname TEXT UNIQUE, ctitle TEXT)')
                   });
    db.transaction(function(tx){
                       tx.executeSql("create table if not exists Event (name TEXT, startDate DATE, startTime TEXT, primary key (name,startDate))")
                    });
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


function isChecked(name,date){
    var flag = false;
    var db = getDatabase();
    db.readTransaction(function(tx){
                           var rs = tx.executeSql('select * from Event where name = ? and startDate = ?;',[name,date])
                            if(rs.rows.length>0){
                                flag = true;
                            }
                       });
    return flag;
}


function deleteData(name,date){
    var db = getDatabase();
    var flag = false;
    db.transaction(function(tx){
                       var rs = tx.executeSql('delete from Event where name =? and startDate = ?;',[name,date]);
                       flag = rs.rowsAffected > 0;
                   })
    return flag;
}


function insertData(name,date,stime){
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx){
                       var rs = tx.executeSql('INSERT or REPLACE into Event values(?,?,?);',[name,date,stime])
                       res = rs.rowsAffected > 0;
                   })
    return res;
}


function eventsForDate(model,date){
    model.clear();
    var db = getDatabase();
    db.readTransaction(function(tx){
                           var rs = tx.executeSql('SELECT * FROM Event WHERE ? >= startDate AND ? <= startTime;',[date,date])
                           for (var i=0, l = rs.rows.length; i < l; i++){
                               var t = rs.rows.item(i);
                               model.append({
                                                "name":t.name,
                                                "startDate":t.startDate,
                                                "startTime":t.startTime
                                            })
                           }
                       })
    return model;
}

function hasfeature(date){
    var db = getDatabase();
    var flag = false;
    db.readTransaction(function(tx){
                           var rs = tx.executeSql('SELECT * FROM Event WHERE ? >= startDate AND ? <= startTime;',[date,date])
                           flag = rs.rows.length >0
                       })
    return flag;
}
