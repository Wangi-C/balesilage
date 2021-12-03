package kr.co.bsa.transaction;

import kr.co.bsa.common.DateCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService{
    @Autowired
    TransactionMapper transactionMapper;

    @Override
    public void insertTransaction(Transaction transaction) {
        transactionMapper.insert(transaction);
    }

    @Override
    public List<Transaction> selectTransactionList(DateCommand dateCommand) {
        List<Transaction> transactions = transactionMapper.selectAll(dateCommand);
        return transactions;
    }

    @Override
    public Transaction selectTransaction(Transaction transaction) {
        transaction = transactionMapper.select(transaction);
        return transaction;
    }

    @Override
    public void updateTransaction(Transaction transaction) {
        System.out.println("deposit------>" + transaction.isDepositStatus());
        System.out.println("remit------>" + transaction.isDepositStatus());

        transactionMapper.update(transaction);
    }

    @Override
    public void deleteTransaction(Transaction transaction) {
        transactionMapper.delete(transaction);
    }
}
