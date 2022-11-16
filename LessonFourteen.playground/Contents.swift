
import Foundation

func testQueue(){
    print("1")
    DispatchQueue.main.async {
        print("2")
        DispatchQueue.global(qos: .background).sync {
            print("3")
            DispatchQueue.main.sync {
                print("4")
                DispatchQueue.global(qos: .background).async {
                    print("5")
                }
                print("6")
            }
            print("7")
        }
        print("8")
    }
    print("9")
}

//testQueue()

// 1
/*
 Выведутся только цифры  1, 9, 2, 3
 1 выводится на главной очереди, затем добавляется асинхронно следующий блок, выполнение которого начнется после добавленных в очередь задач.
 Затем выводится 9 и управление передается следующему блоку.
 В нем выводится цифра 2. Так как новый блок добавляется, хоть и на .background очередь, но синхронно, управление передается ему. В это время главная очередь ставится на паузу, ожидая завершение выполнение блока .background.
 После вывода цифры 3, после чего .background ставится на паузу и синхронно запускается следующий блок на главном потоке, но главный поток стоит на ожидании завершения выполнения потока .background, который так же встал на ожидание. В связи с чем происходит deadlock.
 */

// 2
// Результат такой же. Происходит deadlock. Это можно исправить, сделать mainQueue так же .concurrent

func testQueue2(){
    let mainQueue = DispatchQueue(label: "Main")
    let backgorundQueue = DispatchQueue(label: "Backgroud", attributes: .concurrent)
    print("1")
    mainQueue.async {
        print("2")
        backgorundQueue.sync {
            print("3")
            mainQueue.sync {
                print("4")
                backgorundQueue.async {
                    print("5")
                }
                print("6")
            }
            print("7")
        }
        print("8")
    }
    print("9")
}

//testQueue2()


// 3
// Надо заменить  первый DispatchQueue.global(qos: .background).sync на async

func testQueue3(){
    print("1")
    DispatchQueue.main.async {
        print("2")
        DispatchQueue.global(qos: .background).async {
            print("3")
            DispatchQueue.main.sync {
                print("4")
                DispatchQueue.global(qos: .background).async {
                    print("5")
                }
                print("6")
            }
            print("7")
        }
        print("8")
    }
    print("9")
}

//testQueue3()

// Либо DispatchQueue.main.sync на async
func testQueue4(){
    print("1")
    DispatchQueue.main.async {
        print("2")
        DispatchQueue.global(qos: .background).sync {
            print("3")
            DispatchQueue.main.async {
                print("4")
                DispatchQueue.global(qos: .background).async {
                    print("5")
                }
                print("6")
            }
            print("7")
        }
        print("8")
    }
    print("9")
}

//testQueue4()

// 4

func testQueue5(){
    print("1")
    DispatchQueue.main.async {
        print("2")
        DispatchQueue.global(qos: .background).async {
            print("3")
            DispatchQueue.main.async {
                print("4")
                DispatchQueue.global(qos: .background).async {
                    print("5")
                }
                print("6")
            }
            print("7")
        }
        print("8")
    }
    print("9")
}

//testQueue5()
