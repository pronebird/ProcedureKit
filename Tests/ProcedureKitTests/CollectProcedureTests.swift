//
//  ProcedureKit
//
//  Copyright © 2015-2018 ProcedureKit. All rights reserved.
//

import XCTest
import TestingProcedureKit
@testable import ProcedureKit

class CollectProcedureTests: ProcedureKitTestCase {
    
    func test__collect_two_results() {
        let resultA = ResultProcedure<[Int]>(block: { [1] })
        let resultB = ResultProcedure<[Int]>(block: { [1] })
        let collect = CollectProcedure<Int>()
            .collectResult(from: resultA)
            .collectResult(from: resultB)
        
        wait(for: resultA, resultB, collect)
        PKAssertProcedureFinished(collect)
        PKAssertProcedureOutput(collect, [1, 1])
    }
}
