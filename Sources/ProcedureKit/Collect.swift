//
//  ProcedureKit
//
//  Copyright © 2015-2018 ProcedureKit. All rights reserved.
//

import Foundation

open class CollectProcedure<ElementType>: Procedure, OutputProcedure {
    public var output: Pending<ProcedureResult<[ElementType]>> = .pending
    
    private var lock = NSLock()
    private var accumulatedResults = [ElementType]()
    
    override open func execute() {
        output = .ready(.success(accumulatedResults))
        finish()
    }
    
    public func collectResult<T: OutputProcedure>(from dependency: T) -> Self
        where T.Output == [ElementType] {
            return injectResult(from: dependency) { (collectProcedure, result) in
                collectProcedure.accumulateResult(result)
            }
    }
    
    public func collectResult<T: OutputProcedure>(from dependency: T) -> Self
        where T.Output == ElementType {
            return injectResult(from: dependency) { (collectProcedure, result) in
                collectProcedure.accumulateResult([result])
            }
    }
    
    private func accumulateResult<T: Sequence>(_ result: T) where T.Element == ElementType {
        lock.withCriticalScope(block: { () -> Void in
            self.accumulatedResults.append(contentsOf: result)
        })
    }
}
