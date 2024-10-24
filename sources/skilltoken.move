module SkillTokenization::SkillToken {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a user's skill tokens.
    struct UserTokens has store, key {
        earned_tokens: u64,  // Total tokens earned by the user
    }

    /// Function for users to earn tokens for learning.
    public fun earn_tokens(user: &signer, amount: u64) acquires UserTokens {
        if (!exists<UserTokens>(signer::address_of(user))) {
            // If the user has no tokens record, create one
            let user_tokens = UserTokens { earned_tokens: 0 };
            move_to(user, user_tokens);
        };
        let user_tokens = borrow_global_mut<UserTokens>(signer::address_of(user));
        user_tokens.earned_tokens = user_tokens.earned_tokens + amount;
    }

    /// Function for users to spend tokens on additional courses.
    public fun spend_tokens(user: &signer, amount: u64) acquires UserTokens {
        let user_tokens = borrow_global_mut<UserTokens>(signer::address_of(user));
        assert!(user_tokens.earned_tokens >= amount, 1); // Ensure sufficient tokens
        user_tokens.earned_tokens = user_tokens.earned_tokens -amount;
}
}